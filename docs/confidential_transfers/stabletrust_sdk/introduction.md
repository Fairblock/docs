---
sidebar_position: 1
---

# Introduction

## Confidential transfers within your application powered by Fairblock

The Stabletrust SDK provides a simple, robust interface for executing confidential transfers using homomorphic encryption and zero-knowledge proofs. It enables developers to integrate confidentiality features directly into their apps—securing token deposits, private transfers, and withdrawals—without requiring deep cryptographic expertise.

## What it does

- **Deposit**: Convert public ERC20 tokens into a confidential encrypted balance.
- **Transfer**: Execute private transfers without leaking transaction amounts or wallet balances to the public.
- **Withdraw**: Move funds seamlessly from the confidential layer back to public ERC20 tokens.

## What you can build

Privacy by default unlocks new use cases for open finance that institutions and enterprises require. Applications you can build include:

- **Confidential payroll apps**: Stream salaries to employees and contractors without publishing compensation onchain.
- **Confidential token launchpads**: Allow participants to contribute privately, hiding contribution sizing from competitors or bots.
- **Web wallets with confidential transfers built in**: Give everyday users privacy by default for their transactions and asset balances.
- **x402 payments with confidential transfers**: Perform fast, confidential micro-payments for subscriptions, APIs, or AI agents.
- **Treasury management**: Applications for DAOs and funds to move capital without broadcasting their strategy to the market.

## Installation

You can install the Stabletrust SDK into your project via npm or yarn:

```bash
# Using npm
npm install @fairblock/stabletrust

# Using yarn
yarn add @fairblock/stabletrust
```

## Join Confidential Builders Program

Apply to build on Fairblock’s StableTrust SDK and pioneer the next generation of confidential transfers.
[https://build.fairblock.network/](https://build.fairblock.network/)

## Links

- **NPM Package**: [@fairblock/stabletrust](https://www.npmjs.com/package/@fairblock/stabletrust)
- **GitHub**: [https://github.com/Fairblock/stabletrust-sdk](https://github.com/Fairblock/stabletrust-sdk)

## Supported Networks

Currently, the Stabletrust SDK supports confidential transfers on the following testnet networks:

- **Ethereum Sepolia** (11155111)
- **Arbitrum Sepolia** (421614)
- **Base Sepolia** (84532)
- **Stable Testnet** (2201)
- **Arc** (1244)
- **Tempo** (42431) _(Note: Uses token-based fees like PathUSD)_

## Quick Start: Code Snippets

The SDK revolves around the `ConfidentialTransferClient`, which handles the cryptographic heavy lifting.

_(Note: We have a separate, dedicated tutorial document on how to build a simple Next.js app with confidential transfers from scratch. The snippets below are for quick reference.)_

### 1. Initialize the Client

Setup the client with your RPC URL and Chain ID.

```javascript
import { ConfidentialTransferClient } from '@fairblock/stabletrust';
import { ethers } from 'ethers';

// Example: Base Sepolia setup
const client = new ConfidentialTransferClient(
  'https://sepolia.base.org',
  84532
);
```

### 2. Ensure Account is Setup

Before doing confidential operations, make sure the user account is initialized on-chain. This initialization is a one-time step per user per chain.

```javascript
// signer is a standard ethers.js Signer
const { privateKey, publicKey } = await client.ensureAccount(signer);
```

### 3. Deposit Tokens

Deposit tokens to make the balance confidential. Always parse amounts using the token's decimals (e.g., 6 for USDC).

```javascript
const tokenDecimals = 6;
const depositAmount = ethers.parseUnits('1.0', tokenDecimals);

await client.confidentialDeposit(signer, tokenAddress, depositAmount);
```

### 4. Transfer Confidentially

Send tokens to any recipient. The amount being transferred will be encrypted and hidden from the public ledger.

```javascript
const transferAmount = ethers.parseUnits('0.5', tokenDecimals);

await client.confidentialTransfer(
  signer,
  recipientAddress,
  tokenAddress,
  transferAmount
);
```

### 5. Check Confidential Balance

Fetch the user's decrypted available and pending balance. Use the token's decimals to format for UI display.

```javascript
const balance = await client.getConfidentialBalance(
  signer.address,
  privateKey,
  tokenAddress
);

console.log(
  'Total Confidential Balance:',
  ethers.formatUnits(balance.amount, tokenDecimals)
);
```
