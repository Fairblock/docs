---
sidebar_position: 2
---
# Technical Overview

## Cross-Chain Confidential Transactions with FairyRing
Fairblock is a decentralized network for app-specific, secure, and performant confidential computing. This document describes a high-level architecture for cross-chain confidential transaction system that connects existing EVM blockchains to FairyRing, Fairblock’s native chain and confidentiality execution layer.

The objective is to enable confidential balances and transactions for tokens (e.g., stablecoins) issued or circulating on EVM chains without requiring changes to the underlying token contracts and without changing user wallet behavior. Confidentiality is achieved by offloading privacy-sensitive logic to FairyRing, while settlement and liquidity remain on the originating EVM chain.

Cross-chain communication between EVM chains and FairyRing uses Inter-Blockchain Communication (IBC), a light-client-based messaging channel. This design avoids relying on a single trusted execution environment (TEE) or MPC honest-majority assumptions. Instead, confidential transfers use lightweight additive homomorphic calculations and fast zero-knowledge (ZK)-proof verification, executed within the protocol flow. The system does not rely on fully homomorphic encryption over the discretized Torus (TFHE) from an off-chain coprocessor. All homomorphic calculations and ZK proof verification are extremely lightweight, and execution runs on FairyRing.

## System Overview
Each integrated EVM chain deploys a minimal Solidity escrow contract that locks underlying tokens. On FairyRing, a set of CosmWasm contracts maintains a confidential ledger and processes encrypted balance transitions using lightweight homomorphic operations and ZK proofs.

IBC connects the EVM environment and FairyRing. Each side runs a light client of the other chain to enable state verification rather than trusting a centralized bridge. Off-chain relayers are responsible only for transporting packets. They cannot forge headers, modify proofs, or alter packet contents.

Users deposit tokens into the EVM escrow, receive a confidential balance from FairyRing, perform confidential transactions with that balance, and optionally redeem back to the EVM chain when withdrawing.
![alt text](image1.png)
## User Experience
The architecture is designed so that users interact only with their native EVM chain. The complexity of cross-chain messaging, ZK proofs, and homomorphic operations is abstracted behind the deposit, transfer, and withdrawal flows.

### Deposit
To enter the confidential system, a user submits a standard EVM transaction to the escrow contract, sending the desired amount of tokens. The escrow locks the tokens and constructs an IBC packet describing the deposit with the relevant metadata.

An IBC relayer observes this packet on the EVM side and forwards it to FairyRing. A CosmWasm contract receives the packet, verifies it, and credits the user with an encrypted balance representing the deposited amount. Only encrypted values are recorded on FairyRing. No plaintext balances are visible onchain.

FairyRing returns a response packet back to the EVM chain through IBC. On receiving the response, the escrow contract updates its internal state so the user’s confidential position is accurately reflected on the EVM side. The user can query the EVM escrow contract to view their confidential balance, without interacting with FairyRing directly.
![alt text](image2.png)

### Confidential Transactions
Once the user has an encrypted balance, they can transfer to other confidential accounts while still transacting on the EVM chain. To initiate a transfer, the user submits a transaction to the escow contract that includes an encrypted transfer amount and the necessary ZK proofs. These proofs attest, among other things, that the sender’s balance is sufficient, that the transfer preserves total value, and that no negative balances are created as a result of the operation.

The escrow contract wraps this payload into an IBC packet. A relayer forwards it to FairyRing, where a CosmWasm contract verifies the ZK proofs. If the proofs are valid, FairyRing updates the encrypted balances of both sender and the receiver using homomorphic addition/subtraction, without revealing the underlying token amounts.

FairyRing then returns a response packet via IBC. Once processed on the EVM side, the escrow contract updates its view of the confidential balances for both parties, allowing users to query the escrow contract and observe that their confidential balances have changed.
![alt text](image3.png)

### Withdrawal
When the user wishes to redeem their confidential balance to native stablecoins, they can submit a transaction to the escrow contract with the withdrawal amount and a ZK proof showing sufficient confidential balance.

The escrow contract constructs an IBC packet for this withdrawal request and emits it. A relayer forwards the packet to FairyRing, where the CosmWasm contract verifies the proof and updates the encrypted balance accordingly.

FairyRing then returns a response packet to the EVM chain. The escrow contract processes it and updates its internal state and releases the corresponding amount of locked tokens back to the user’s EVM address.

Throughout this lifecycle, the user interacts only with the EVM escrow contract. Deposits, transfers, and withdrawals appear as conventional EVM transactions, while cryptography and cross-chain coordination occur under the hood.
![alt text](image4.png)



## Architectural Components
### FairyRing: Confidentiality Provider
FairyRing operates as a dedicated confidentiality execution layer. Its core logic is implemented as CosmWasm contracts that maintain a confidential ledger of encrypted balances per account and per asset. These contracts process confidential transactions based on ZK proof verification and lightweight homomorphic addition/subtraction, ensuring that all balance updates are internally consistent while never exposing the underlying amounts.

FairyRing also supports selective disclosure under defined conditions. Users decrypt their own balances locally with their own keys, while only encrypted amounts are stored onchain. When required for compliance, audits, or investigations, authorized parties can be granted access to scoped decryption keys. This is enabled by FairyRing’s threshold identity-based encryption (IBE), which allows specific accounts or transaction subsets to be revealed under well-defined conditions without introducing a single persistent audit key that compromises global confidentiality.

### EVM Escrow Contract
On each EVM chain, a dedicated escrow contract serves as the bridge endpoint and local interface for users. Its primary functions are to lock and unlock tokens and to interface with IBC.

When a user deposits tokens, the escrow contract locks the funds and emits an IBC packet to FairyRing. When a valid IBC response is received from FairyRing (for example, confirming a successful transaction or withdrawal), the contract updates its internal state and, in the case of withdrawals, releases the corresponding tokens back to the user.

The escrow contract is intentionally minimal in logic. It handles token accounting and the IBC packet interface but avoids complex cryptographic operations. Heavy cryptographic verification and homomorphic balance management are delegated to FairyRing.

### IBC Relaying
IBC provides trust-minimized communication between chains and FairyRing. Each chain maintains a light client of the other, allowing it to verify headers and proofs accompanying incoming packets. Off-chain relayers merely move packets between chains; they do not participate in validation and cannot forge valid headers, tamper with proofs, or undetectably alter packet contents.

As a result, the security of cross-chain communication is ultimately anchored in the consensus of the connected chains rather than in any external custodian or relayer.

## Leveraging the Confidentiality Provided by FairyRing
FairyRing provides the ability to make confidential transactions both natively and externally. Natively, developers can build confidential applications (cApps) directly on FairyRing. FairyRing is a self-sufficient chain that can host its own native cApps. At the same time, FairyRing can provide similar levels of confidentiality to external chains and systems seamlessly via IBC or relayers.

### Stabletrust: The Complete Confidential Package
Stabletrust is Fairblock's browser-based interface for confidential payments and transfers. It includes wallet integrations, browser-based local ZK proof generation, balance decryption, and the ability to execute on FairyRing or chain that uses FairyRing for confidential transactions. It is a pre-built solution that can be used directly by both FairyRing users and users on different chains. Users on other chains do not need to interact with FairyRing directly. Stabletrust comes with built-in wallet integrations, which allow users to log in to their accounts on the chains they already use and make transactions without bridging funds. Stabletrust is an all-in-one interface to start making confidential transactions immediately without any prior setup or crytography knowledge.

### Custom Integrations
FairyRing is chain-agnostic and can extend confidentiality to other ecosystems (e.g. EVM, Solana, Stellar, etc.) seamlessly via IBC or custom relayers. No cross-chain token transfer is required. FairyRing acts as the core confidential execution layer and keeper of confidential ledgers.

Developers can build bespoke user interfaces and applications using the available tools provided by Fairblock. APIs are available for submitting transactions and querying the native chain. Command-line utility and JavaScript packages support local ZK proof generation and balance decryption. Finally, developers can simply follow the wallet integration guide (as implemented in Stabletrust) to have their complete user interface, which runs on their native chain, with FairyRing as the confidential execution layer. The APIs and tools provided allow for seamless integration with not only browser-based frontends, but also anything from Telegram and Discord bots to AI agents.

### Native Solutions
While IBC provides trustless relaying between chains, custom relayers are available for IBC-incompatible systems. For systems and chains that prefer a native confidentiality implementation, Fairblock can provide custom integrations.
