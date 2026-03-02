---
sidebar_position: 2
---

# Building with Stabletrust

**Live Demo:** [https://Stabletrust-sdk-demo.vercel.app/](https://Stabletrust-sdk-demo.vercel.app/)<br/>
**GitHub Repository:** [https://github.com/Fairblock/Stabletrust-sdk-demo](https://github.com/Fairblock/Stabletrust-sdk-demo)

This guide walks you through building a complete confidential decentralized application using the Stabletrust SDK and Privy for wallet authentication. By the end, you will have a working Next.js application where users can deposit tokens into an encrypted balance, transfer them privately on-chain, and withdraw back to a public balance.

---

## What You Are Building

Stabletrust uses Fully Homomorphic Encryption (FHE) to give each user a confidential token balance alongside their normal public balance. Once tokens enter the confidential layer, their amounta are encrypted on-chain — opaque to block explorers and other observers.

The user flow:

1. Connect wallet via Privy.
2. Initialize a confidential account, which generates the user's FHE keypair through a wallet signature.
3. Deposit public tokens into the encrypted layer, transfer privately to another address, and withdraw back to a public balance when needed.

**Stack used in this guide:**

- Next.js 16 (App Router, TypeScript)
- Privy for embedded wallet and authentication
- ethers.js v6 for signer management and amount formatting
- `@fairblock/Stabletrust` for confidential operations
- viem for chain definitions

---

## Prerequisites

- Node.js 18 or higher
- A Privy App ID — created at [dashboard.privy.io](https://dashboard.privy.io)
- A wallet funded with test ETH on Base Sepolia for gas

---

## Step 1: Create the Next.js Application

```bash
npx create-next-app@latest example
cd example
```

When prompted, choose: TypeScript, ESLint, Tailwind CSS, App Router.

---

## Step 2: Install Dependencies

```bash
npm install @privy-io/react-auth viem ethers @fairblock/Stabletrust
```

| Package                  | Role                                             |
| :----------------------- | :----------------------------------------------- |
| `@privy-io/react-auth`   | Wallet connection and authentication             |
| `viem`                   | Chain definitions for Privy configuration        |
| `ethers`                 | Signer extraction, amount parsing and formatting |
| `@fairblock/Stabletrust` | Confidential deposit, transfer, withdraw         |

---

## Step 3: Environment Variables

Create `.env.local` in the root of your project:

```env
NEXT_PUBLIC_PRIVY_APP_ID=your_privy_app_id_here
NEXT_PUBLIC_RPC_URL=https://base-sepolia.drpc.org
NEXT_PUBLIC_TOKEN_ADDRESS=0x036CbD53842c5426634e7929541eC2318f3dCF7e
NEXT_PUBLIC_CHAIN_ID=84532
```

- `NEXT_PUBLIC_PRIVY_APP_ID` — from your Privy dashboard
- `NEXT_PUBLIC_RPC_URL` — the JSON-RPC endpoint for Base Sepolia
- `NEXT_PUBLIC_TOKEN_ADDRESS` — the ERC20 token for this demo (test USDC on Base Sepolia)
- `NEXT_PUBLIC_CHAIN_ID` — `84532` is Base Sepolia

---

## Step 4: Add the Privy Provider

Privy must wrap the entire application so its authentication context is available everywhere. Create `app/Providers.tsx`:

```tsx
'use client';

import { PrivyProvider } from '@privy-io/react-auth';
import { baseSepolia } from 'viem/chains';

export const supportedChains = [baseSepolia];

export default function Providers({ children }: { children: React.ReactNode }) {
  return (
    <PrivyProvider
      appId={process.env.NEXT_PUBLIC_PRIVY_APP_ID!}
      config={{
        appearance: {
          theme: 'light',
          accentColor: '#000000',
        },
        supportedChains: supportedChains,
        defaultChain: baseSepolia,
      }}
    >
      {children}
    </PrivyProvider>
  );
}
```

`supportedChains` and `defaultChain` lock the app to Base Sepolia so the wallet always targets the correct network.

You can see the complete Provider implementation here: [app/Providers.tsx](https://github.com/Fairblock/Stabletrust-sdk-demo/blob/main/app/Providers.tsx)

Then wrap your layout in `app/layout.tsx`:

```tsx
import Providers from './Providers';

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <body>
        <Providers>{children}</Providers>
      </body>
    </html>
  );
}
```

All components inside now have access to `usePrivy()` and `useWallets()`.

You can see the complete `Providers.tsx` used in the demo here: [app/Providers.tsx](https://github.com/Fairblock/Stabletrust-sdk-demo/blob/main/app/Providers.tsx)

---

## Step 5: Building the Hook — Step by Step

Everything from this point forward lives inside a single React hook: `app/hooks/useConfidentialClient.ts`. This section builds it piece by piece so each operation is clear before the next one is added.

Start by creating the file with its imports and state:

```typescript
// app/hooks/useConfidentialClient.ts
'use client';

import { useState, useEffect } from 'react';
import { usePrivy, useWallets } from '@privy-io/react-auth';
import { ethers } from 'ethers';
import { ConfidentialTransferClient } from '@fairblock/Stabletrust';

const config = {
  rpcUrl: process.env.NEXT_PUBLIC_RPC_URL!,
  chainId: Number(process.env.NEXT_PUBLIC_CHAIN_ID!),
  tokenAddress: process.env.NEXT_PUBLIC_TOKEN_ADDRESS!,
};

export function useConfidentialClient() {
  const { authenticated } = usePrivy();
  const { wallets } = useWallets();

  const [client, setClient] = useState<ConfidentialTransferClient | null>(null);
  const [signer, setSigner] = useState<ethers.Signer | null>(null);
  const [userKeys, setUserKeys] = useState<{
    publicKey: string;
    privateKey: string;
  } | null>(null);
  const [balances, setBalances] = useState({
    public: '0',
    confidential: '0',
    native: '0',
  });
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [tokenDecimals, setTokenDecimals] = useState(6);
  const [tokenSymbol, setTokenSymbol] = useState('TOKEN');

  // ... operations are added below
}
```

Each of the following sections adds one piece to this hook.

---

### 5.1 Initialize the SDK Client

The `ConfidentialTransferClient` is the entry point to all SDK operations. It connects to the network and resolves the correct Stabletrust contract automatically from the chain ID.

Add this `useEffect` to your hook:

```typescript
useEffect(() => {
  const c = new ConfidentialTransferClient(
    config.rpcUrl, // rpcUrl: JSON-RPC endpoint for the target network
    config.chainId // chainId: used to auto-resolve the Stabletrust contract address
  );
  setClient(c);
}, []);
```

**Parameters for `new ConfidentialTransferClient`:**

| Parameter | Type     | Description                                                                |
| :-------- | :------- | :------------------------------------------------------------------------- |
| `rpcUrl`  | `string` | The HTTP JSON-RPC endpoint of the network                                  |
| `chainId` | `number` | The chain ID — the SDK resolves the Stabletrust contract address from this |

You only need one client instance for the lifetime of the app. Creating it once on mount is sufficient.

---

### 5.2 Wrap the Privy Wallet into an Ethers Signer

The Stabletrust SDK expects a standard `ethers.Signer`. Privy provides its own wallet abstraction, so you need to extract the raw EIP-1193 provider from it and wrap it with ethers.

Add this `useEffect` to your hook — it runs whenever authentication state or the wallet list changes:

```typescript
useEffect(() => {
  async function setupSigner() {
    if (authenticated && wallets.length > 0) {
      const wallet = wallets[0];

      // 1. Switch to the correct chain before doing anything
      await wallet.switchChain(config.chainId);

      // 2. Get the raw EIP-1193 provider from Privy
      const provider = await wallet.getEthereumProvider();

      // 3. Wrap it in ethers.BrowserProvider
      const ethersProvider = new ethers.BrowserProvider(provider);

      // 4. Derive the Signer — this is what the SDK expects
      const s = await ethersProvider.getSigner();
      setSigner(s);
    } else {
      setSigner(null);
    }
  }
  setupSigner();
}, [authenticated, wallets]);
```

**What each step does:**

- `switchChain` — forces the wallet onto the correct network before any transaction is signed. Without this, the user could accidentally sign on the wrong chain.
- `getEthereumProvider()` — returns the raw EIP-1193 provider Privy uses internally.
- `BrowserProvider` — the ethers.js v6 wrapper for browser-injected providers.
- `getSigner()` — returns a `JsonRpcSigner` capable of signing transactions and messages.

The `signer` produced here is passed into every SDK operation below.

---

### 5.3 Initialize the Confidential Account

Before any confidential operation can happen, the user must have a confidential account registered on-chain with their FHE public key. `ensureAccount` handles the full flow in one call: it prompts a wallet signature, derives the FHE keypair from that signature, and registers the public key on-chain if it does not yet exist.

Add this function to your hook:

```typescript
const ensureAccount = async () => {
  if (!client || !signer) throw new Error('Not initialized');
  setLoading(true);
  setError(null);
  try {
    const keys = await client.ensureAccount(
      signer // ethers.Signer — the user's signer derived from the Privy wallet
    );
    setUserKeys(keys);
  } catch (e: any) {
    setError(e.message);
  } finally {
    setLoading(false);
  }
};
```

**Parameters for `client.ensureAccount`:**

| Parameter | Type            | Description                                     |
| :-------- | :-------------- | :---------------------------------------------- |
| `signer`  | `ethers.Signer` | The user's signer derived from the Privy wallet |

**Returns:** `{ publicKey: string, privateKey: string }`

The `privateKey` returned here is a derived FHE key — not the user's wallet private key. It never leaves the browser and is re-derived on each session from the wallet signature. Store it in React state and pass it to `getConfidentialBalance` later.

Account initialization includes an on-chain finalization step. Expect this to take approximately 45 seconds on the first call. The method waits for finalization before returning, so `loading` will be true for the duration.

---

### 5.4 Deposit — Move Tokens into the Confidential Layer

Deposit converts public ERC20 tokens into an encrypted confidential balance. The SDK handles the ERC20 approval and the deposit transaction in a single call — you do not need to send a separate `approve` transaction.

Add this function to your hook:

```typescript
const confidentialDeposit = async (humanAmount: string) => {
  if (!client || !signer) throw new Error('Not initialized');
  setLoading(true);
  setError(null);
  try {
    // Convert the human-readable amount to token base units
    const amount = ethers.parseUnits(humanAmount, tokenDecimals);
    // e.g. "10" with 6 decimals → 10_000_000n

    await client.confidentialDeposit(
      signer, // ethers.Signer — the user's wallet signer
      config.tokenAddress, // string — the ERC20 contract address to deposit
      amount // BigInt — amount in token base units
    );

    // Wait briefly for the chain state to settle, then refresh balances
    setTimeout(() => fetchBalances(), 2000);
  } catch (e: any) {
    setError(e.message);
  } finally {
    setLoading(false);
  }
};
```

**Parameters for `client.confidentialDeposit`:**

| Parameter      | Type            | Description                                                                 |
| :------------- | :-------------- | :-------------------------------------------------------------------------- |
| `signer`       | `ethers.Signer` | The user's wallet signer                                                    |
| `tokenAddress` | `string`        | The ERC20 token contract address                                            |
| `amount`       | `BigInt`        | Amount in the token's base unit — always use `ethers.parseUnits` to convert |

**Returns:** A transaction receipt once the deposit is confirmed and finalized on-chain.

Always use `ethers.parseUnits(humanAmount, decimals)` to convert. Never pass a raw decimal number directly — the SDK expects base units as a `BigInt`.

---

### 5.5 Withdraw — Move Tokens Back to Public

Withdraw removes tokens from the encrypted confidential balance and returns them to the user's standard ERC20 balance. After withdrawal, the amount is visible on-chain again.

Add this function to your hook:

```typescript
const withdraw = async (humanAmount: string) => {
  if (!client || !signer) throw new Error('Not initialized');
  setLoading(true);
  setError(null);
  try {
    // Convert to base units, then cast to Number as the withdraw method expects
    const amount = ethers.parseUnits(humanAmount, tokenDecimals);

    await client.withdraw(
      signer, // ethers.Signer — the user's wallet signer
      config.tokenAddress, // string — the ERC20 token contract address
      Number(amount) // number — amount in base units, cast to Number
    );

    setTimeout(() => fetchBalances(), 2000);
  } catch (e: any) {
    setError(e.message);
  } finally {
    setLoading(false);
  }
};
```

**Parameters for `client.withdraw`:**

| Parameter      | Type            | Description                                                           |
| :------------- | :-------------- | :-------------------------------------------------------------------- |
| `signer`       | `ethers.Signer` | The user's wallet signer                                              |
| `tokenAddress` | `string`        | The ERC20 token contract address                                      |
| `amount`       | `number`        | Amount in token base units — pass as `Number(ethers.parseUnits(...))` |

**Returns:** A transaction receipt.

Note that `withdraw` takes a `number`, not a `BigInt` — unlike deposit. Always cast with `Number(ethers.parseUnits(...))`.

---

### 5.6 Transfer — Send Tokens Privately

Confidential transfer sends tokens from the caller's encrypted balance to another address's encrypted balance. The amount and destination are both encrypted on-chain. Block explorers show the transaction as occurring, but reveal neither the value nor the true destination.

Add this function to your hook:

```typescript
const confidentialTransfer = async (
  recipientAddress: string,
  humanAmount: string
) => {
  if (!client || !signer) throw new Error('Not initialized');
  setLoading(true);
  setError(null);
  try {
    const amount = ethers.parseUnits(humanAmount, tokenDecimals);

    await client.confidentialTransfer(
      signer, // ethers.Signer — the sender's wallet signer
      recipientAddress, // string — the recipient's public Ethereum address (0x...)
      config.tokenAddress, // string — the ERC20 token contract address
      Number(amount) // number — amount in base units, cast to Number
    );

    setTimeout(() => fetchBalances(), 2000);
  } catch (e: any) {
    setError(e.message);
  } finally {
    setLoading(false);
  }
};
```

**Parameters for `client.confidentialTransfer`:**

| Parameter          | Type            | Description                                                           |
| :----------------- | :-------------- | :-------------------------------------------------------------------- |
| `signer`           | `ethers.Signer` | The sender's wallet signer                                            |
| `recipientAddress` | `string`        | The recipient's public Ethereum address (`0x...`)                     |
| `tokenAddress`     | `string`        | The ERC20 token contract address                                      |
| `amount`           | `number`        | Amount in token base units — pass as `Number(ethers.parseUnits(...))` |

**Returns:** A transaction receipt.

**Important:** The recipient must have already called `ensureAccount` and have a registered confidential account before you can transfer to them. If their account does not exist on-chain, the transaction will fail with `"Account does not exist"`.

---

### 5.7 Fetch the Confidential Balance

The confidential balance is stored encrypted on-chain. The SDK decrypts it client-side using the user's `privateKey` from `ensureAccount`. Call this after every operation to reflect the latest state.

Add this function to your hook:

```typescript
const fetchBalances = async () => {
  if (!client || !signer || !userKeys) return;
  try {
    const address = await signer.getAddress();

    // Decrypt the confidential balance using the user's FHE private key
    const confidentialBalance = await client.getConfidentialBalance(
      address, // string — the user's wallet address
      userKeys.privateKey, // string — the FHE private key from ensureAccount
      config.tokenAddress // string — the ERC20 token contract address
    );

    // confidentialBalance.amount     — BigInt: total of available + pending
    // confidentialBalance.available  — { amount: BigInt, ciphertext: string }
    // confidentialBalance.pending    — { amount: BigInt, ciphertext: string }

    // Also fetch the public ERC20 balance
    const publicBalance = await client.getPublicBalance(
      address,
      config.tokenAddress
    );

    setBalances({
      confidential: ethers.formatUnits(
        confidentialBalance.amount,
        tokenDecimals
      ),
      public: ethers.formatUnits(publicBalance, tokenDecimals),
      native: '0', // fetch native ETH separately if needed
    });
  } catch (e: any) {
    // Balance fetch errors are non-blocking — don't surface them as UI errors
    console.error('Balance fetch failed:', e.message);
  }
};
```

**Parameters for `client.getConfidentialBalance`:**

| Parameter      | Type     | Description                                     |
| :------------- | :------- | :---------------------------------------------- |
| `address`      | `string` | The user's wallet address                       |
| `privateKey`   | `string` | The FHE private key returned by `ensureAccount` |
| `tokenAddress` | `string` | The ERC20 token contract address                |

**Return fields:**

| Field       | Type                                     | Description                                  |
| :---------- | :--------------------------------------- | :------------------------------------------- |
| `amount`    | `BigInt`                                 | Total balance — available + pending combined |
| `available` | `{ amount: BigInt, ciphertext: string }` | Settled, spendable balance                   |
| `pending`   | `{ amount: BigInt, ciphertext: string }` | Incoming balance not yet settled             |

`available` is what can be transferred or withdrawn immediately. `pending` represents amounts that have been deposited but are still finalizing on-chain — after finalization, pending becomes available. For most display purposes, show `amount` (the total) and optionally break it down into available and pending.

---

### 5.8 Finish the Hook

Wire up balance polling and export everything. Add this to the bottom of the hook, just before the closing return:

```typescript
// Poll balances every 10 seconds when keys are available
useEffect(() => {
  if (!userKeys) return;
  fetchBalances();
  const interval = setInterval(fetchBalances, 10_000);
  return () => clearInterval(interval);
}, [userKeys]);

return {
  signer,
  userKeys,
  balances,
  loading,
  error,
  tokenSymbol,
  ensureAccount,
  confidentialDeposit,
  confidentialTransfer,
  withdraw,
};
```

The hook is now complete. You can see the complete implementation here: [app/hooks/useConfidentialClient.ts](https://github.com/Fairblock/Stabletrust-sdk-demo/blob/main/app/hooks/useConfidentialClient.ts)

Components import it like this:

```typescript
const {
  signer,
  userKeys,
  balances, // { public: string, confidential: string, native: string }
  loading,
  error,
  tokenSymbol,
  ensureAccount,
  confidentialDeposit,
  confidentialTransfer,
  withdraw,
} = useConfidentialClient();
```

You can see the complete implementation of this hook here: [app/hooks/useConfidentialClient.ts](https://github.com/Fairblock/Stabletrust-sdk-demo/blob/main/app/hooks/useConfidentialClient.ts)

---

## Step 6: Building the UI — Step by Step

The UI is a single page component at `app/page.tsx`. This section builds it piece by piece in the same order as the hook — connect, initialize, deposit, withdraw, transfer.

Start with the skeleton:

```tsx
// app/page.tsx
'use client';

import { usePrivy } from '@privy-io/react-auth';
import { useState } from 'react';
import { useConfidentialClient } from './hooks/useConfidentialClient';

export default function Home() {
  const { login, logout, authenticated, user } = usePrivy();
  const {
    userKeys,
    balances,
    loading,
    error,
    tokenSymbol,
    ensureAccount,
    confidentialDeposit,
    confidentialTransfer,
    withdraw,
  } = useConfidentialClient();

  // Local form state — added in the sections below

  return (
    <main className="min-h-screen bg-gray-50 p-8">
      <div className="max-w-lg mx-auto space-y-6">
        {/* Sections added below */}
      </div>
    </main>
  );
}
```

---

### 6.1 Connect Wallet

The first thing the user sees is a connect button. Show it when unauthenticated, and swap it for a disconnect button and the user's wallet address once connected.

Add this block inside `<main>`:

```tsx
{
  /* Connect / Disconnect */
}
<div className="bg-white rounded-xl p-6 shadow-sm">
  <h1 className="text-xl font-semibold mb-4">Stabletrust Demo</h1>

  {!authenticated ? (
    <button
      onClick={login}
      className="w-full bg-black text-white py-2 rounded-lg font-medium hover:bg-gray-800"
    >
      Connect Wallet
    </button>
  ) : (
    <div className="flex items-center justify-between">
      <span className="text-sm text-gray-500 truncate">
        {user?.wallet?.address}
      </span>
      <button
        onClick={logout}
        className="text-sm text-red-500 hover:text-red-700"
      >
        Disconnect
      </button>
    </div>
  )}
</div>;
```

Privy's `login()` opens its built-in modal. `user?.wallet?.address` is the connected address — it only exists after authentication, so the optional chain prevents errors during the pre-auth render.

---

### 6.2 Initialize Confidential Account

Once connected, the user must initialize their confidential account before any other action is possible. Show this block only when authenticated but `userKeys` is still null.

Add this block after the connect section:

```tsx
{
  /* Initialize Account */
}
{
  authenticated && !userKeys && (
    <div className="bg-white rounded-xl p-6 shadow-sm">
      <h2 className="font-semibold mb-2">Initialize Confidential Account</h2>
      <p className="text-sm text-gray-500 mb-4">
        This creates your encrypted account on-chain. It takes about 45 seconds
        and requires one wallet signature.
      </p>
      <button
        onClick={ensureAccount}
        disabled={loading}
        className="w-full bg-blue-600 text-white py-2 rounded-lg font-medium
                 hover:bg-blue-700 disabled:opacity-50"
      >
        {loading ? 'Initializing... (~45s)' : 'Initialize Account'}
      </button>
    </div>
  );
}
```

`ensureAccount` comes directly from the hook. `loading` is set to `true` by the hook for the duration of the call, so the button disables automatically while the transaction is processing.

---

### 6.3 Balance Display

Once `userKeys` exists, show the user's public and confidential balances at the top of the action area. These values are refreshed automatically by the hook's 10-second polling interval and after each operation.

Add this block after the initialize section:

```tsx
{
  /* Balance Display */
}
{
  userKeys && (
    <div className="bg-white rounded-xl p-6 shadow-sm">
      <h2 className="font-semibold mb-4">Balances</h2>
      <div className="grid grid-cols-2 gap-4">
        <div className="bg-gray-50 rounded-lg p-4">
          <p className="text-xs text-gray-400 mb-1">Public</p>
          <p className="text-lg font-mono font-semibold">
            {balances.public}{' '}
            <span className="text-sm font-normal">{tokenSymbol}</span>
          </p>
        </div>
        <div className="bg-blue-50 rounded-lg p-4">
          <p className="text-xs text-gray-400 mb-1">Confidential</p>
          <p className="text-lg font-mono font-semibold">
            {balances.confidential}{' '}
            <span className="text-sm font-normal">{tokenSymbol}</span>
          </p>
        </div>
      </div>
    </div>
  );
}
```

`balances.public` and `balances.confidential` are already formatted as human-readable strings by the hook (via `ethers.formatUnits`) — no conversion needed here.

---

### 6.4 Deposit Form

The deposit form moves tokens from the public balance into the confidential layer. Add this state to the top of the component alongside the other state declarations:

```typescript
const [depositAmount, setDepositAmount] = useState('');
```

Then add this block after the balance display:

```tsx
{
  /* Deposit */
}
{
  userKeys && (
    <div className="bg-white rounded-xl p-6 shadow-sm">
      <h2 className="font-semibold mb-4">Deposit</h2>
      <p className="text-sm text-gray-500 mb-3">
        Move tokens from your public balance into the encrypted layer.
      </p>
      <input
        type="number"
        placeholder={`Amount in ${tokenSymbol}`}
        value={depositAmount}
        onChange={(e) => setDepositAmount(e.target.value)}
        className="w-full border rounded-lg px-3 py-2 mb-3 text-sm"
      />
      <button
        onClick={async () => {
          await confidentialDeposit(depositAmount);
          setDepositAmount('');
        }}
        disabled={loading || !depositAmount}
        className="w-full bg-green-600 text-white py-2 rounded-lg font-medium
                 hover:bg-green-700 disabled:opacity-50"
      >
        {loading ? 'Processing...' : 'Deposit'}
      </button>
    </div>
  );
}
```

The input captures a human-readable amount (e.g. `"10"`). The hook's `confidentialDeposit` function handles the `ethers.parseUnits` conversion internally, so you pass the raw string directly.

---

### 6.5 Withdraw Form

The withdraw form moves tokens from the confidential balance back to the public ERC20 balance. Add this state:

```typescript
const [withdrawAmount, setWithdrawAmount] = useState('');
```

Then add this block:

```tsx
{
  /* Withdraw */
}
{
  userKeys && (
    <div className="bg-white rounded-xl p-6 shadow-sm">
      <h2 className="font-semibold mb-4">Withdraw</h2>
      <p className="text-sm text-gray-500 mb-3">
        Move tokens from the encrypted layer back to your public balance.
      </p>
      <input
        type="number"
        placeholder={`Amount in ${tokenSymbol}`}
        value={withdrawAmount}
        onChange={(e) => setWithdrawAmount(e.target.value)}
        className="w-full border rounded-lg px-3 py-2 mb-3 text-sm"
      />
      <button
        onClick={async () => {
          await withdraw(withdrawAmount);
          setWithdrawAmount('');
        }}
        disabled={loading || !withdrawAmount}
        className="w-full bg-orange-600 text-white py-2 rounded-lg font-medium
                 hover:bg-orange-700 disabled:opacity-50"
      >
        {loading ? 'Processing...' : 'Withdraw'}
      </button>
    </div>
  );
}
```

---

### 6.6 Transfer Form

The transfer form sends tokens privately to another address. It requires a recipient address in addition to an amount. Add this state:

```typescript
const [transferAmount, setTransferAmount] = useState('');
const [recipient, setRecipient] = useState('');
```

Then add this block:

```tsx
{
  /* Transfer */
}
{
  userKeys && (
    <div className="bg-white rounded-xl p-6 shadow-sm">
      <h2 className="font-semibold mb-4">Transfer</h2>
      <p className="text-sm text-gray-500 mb-3">
        Send tokens privately. The recipient must have an initialized
        confidential account.
      </p>
      <input
        type="text"
        placeholder="Recipient address (0x...)"
        value={recipient}
        onChange={(e) => setRecipient(e.target.value)}
        className="w-full border rounded-lg px-3 py-2 mb-3 text-sm font-mono"
      />
      <input
        type="number"
        placeholder={`Amount in ${tokenSymbol}`}
        value={transferAmount}
        onChange={(e) => setTransferAmount(e.target.value)}
        className="w-full border rounded-lg px-3 py-2 mb-3 text-sm"
      />
      <button
        onClick={async () => {
          await confidentialTransfer(recipient, transferAmount);
          setTransferAmount('');
          setRecipient('');
        }}
        disabled={loading || !transferAmount || !recipient}
        className="w-full bg-purple-600 text-white py-2 rounded-lg font-medium
                 hover:bg-purple-700 disabled:opacity-50"
      >
        {loading ? 'Processing...' : 'Transfer Privately'}
      </button>
    </div>
  );
}
```

The button stays disabled until both `recipient` and `transferAmount` have values, preventing accidental empty submissions.

---

### 6.7 Error Display

Add a global error banner that surfaces errors from any hook operation. Place this at the bottom of the `<main>` content, after all the action blocks:

```tsx
{
  /* Error Banner */
}
{
  error && (
    <div className="bg-red-50 border border-red-200 text-red-700 rounded-xl p-4 text-sm">
      <span className="font-medium">Error: </span>
      {error}
    </div>
  );
}
```

The `error` string is set by the hook when any operation throws. It resets to `null` at the start of each new operation, so stale errors clear automatically when the user retries.

You can see the complete UI implementation here: [app/page.tsx](https://github.com/Fairblock/Stabletrust-sdk-demo/blob/main/app/page.tsx)

---

## Step 7: Run the Application

```bash
npm run dev
```

Open [http://localhost:3000](http://localhost:3000).

**Expected flow:**

1. Click **Connect Wallet** — Privy opens a modal.
2. Click **Initialize Confidential Account** — the wallet prompts a signature. Wait approximately 45 seconds for on-chain finalization.
3. The balance display and action forms appear once the account is active.
4. **Deposit** — moves tokens from your public balance into the encrypted layer.
5. **Withdraw** — moves tokens from the encrypted layer back to your public ERC20 balance.
6. **Transfer** — sends tokens privately to another address (recipient must have an initialized account).

Ensure your wallet has test ETH on Base Sepolia for gas. You can get test ETH from the [Base Sepolia faucet](https://www.alchemy.com/faucets/base-sepolia).

---

## SDK Method Reference

### `new ConfidentialTransferClient(rpcUrl, chainId)`

Initializes the client. The SDK resolves the Stabletrust contract from the chain ID automatically.

### `client.ensureAccount(signer)`

Derives the user's FHE keypair from a wallet signature and registers the public key on-chain if not yet present. Required before any other operation.

### `client.confidentialDeposit(signer, tokenAddress, amount)`

Moves ERC20 tokens from the user's public balance into their encrypted confidential balance. `amount` must be a `BigInt` in token base units.

### `client.confidentialTransfer(signer, recipientAddress, tokenAddress, amount)`

Sends tokens privately between two confidential accounts. `amount` must be a `number` in token base units. Recipient must have an initialized confidential account.

### `client.withdraw(signer, tokenAddress, amount)`

Moves tokens from the encrypted confidential balance back to the user's public ERC20 balance. `amount` must be a `number` in token base units.

### `client.getConfidentialBalance(address, privateKey, tokenAddress)`

Decrypts and returns the user's confidential balance. Returns `{ amount, available, pending }`. Requires the `privateKey` from `ensureAccount`.

### `client.getPublicBalance(address, tokenAddress)`

Returns the user's standard ERC20 token balance as a `BigInt`.

---

## Supported Networks

| Network          | Chain ID |
| :--------------- | :------- |
| Base Sepolia     | 84532    |
| Ethereum Sepolia | 11155111 |
| Arbitrum Sepolia | 421614   |
| Stable           | 2201     |
| Arc              | 1244     |

---

## Common Errors

| Error                          | Cause                                    | Resolution                                         |
| :----------------------------- | :--------------------------------------- | :------------------------------------------------- |
| "Account does not exist"       | Recipient has not called `ensureAccount` | Recipient must initialize their account first      |
| "Insufficient balance"         | Amount exceeds confidential balance      | Deposit more or reduce the amount                  |
| "Account finalization timeout" | Account is still processing on-chain     | Wait and retry after a few minutes                 |
| "Proof generation failed"      | Invalid inputs or FHE operation error    | Verify parameters and check available balance      |
| "Not initialized"              | `client` or `signer` is null             | Ensure wallet is connected and SDK client is ready |

---

## Further Reading

- [Fairblock Technical Overview](https://docs.fairblock.network/docs/confidential_transfers/technical_overview)
- [Stabletrust Protocol](https://docs.fairblock.network/docs/confidential_transfers/Stabletrust)
- [Confidential Transaction Mechanics](https://docs.fairblock.network/docs/confidential_transfers/confidential_transactions)
