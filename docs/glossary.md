---
sidebar_position: 6
---
# Glossary

This page contains explanations of common terms used within Fairblock. It is actively updated as more the Fairblock ecosystem and technologies expand.

## A

### Arbitrum Stylus

Arbitrum Stylus is an environment that allows developers to write smart contracts in programming languages that compile to WASM, such as Rust, C, C++, and others. Fairblock leverages Stylus by being able to deploy Decrypter Rust contracts to integrate respective chains using Stylus and FairyRing for dynamic confidential computing. This bring cApps to Stylus chains.

## B

### Block Height Decryption

Among the multiple MPC schemes, the FairyRing testnet currently uses tIBE for default confidential computing, and its default condition for encryption and decryption is a user-specific FairyRing block height.

## C

### Confidential Application (cApp)

A confidential application, or cApp for short, is built using Fairblock's infrastructure. Developers can create cApps to leverage Fairblock's encryption capabilities, ensuring that sensitive data within the application upholds confidentiality and security as per a developers design. cApps can be built on FairyRing, an EVM, or any other independent chain itself. External chains, AKA not FairyRing, integrate with FairyRing for dynamic confidential computing.

### Confidential AI

The integration of confidentiality with artificial intelligence has many different use cases. One application is assuring that the inputs and the data processed by AI models remains private. Fairblock is currently working with projects like Ritual to expand within this field of confidential AI. 

### Confidentiality

The assurance that sensitive information is not disclosed to unauthorized entities. Fairblock emphasizes confidentiality to protect user transactions from being exposed to centralized or privileged parties, such as bots or exploitative relayers. FairyRing uses dynamic confidential computing via various MPC schemes, and thus compliance can still be maintained.

### Cosmos SDK

The Cosmos SDK is a framework for building blockchain applications in Golang. Fairblock utilizes the Cosmos SDK to build its blockchain and provides modules for integration with other Cosmos SDK-based app-chains.

## D

### DeFi (Decentralized Finance)

A financial system built on blockchain technology that operates without central intermediaries in the ideal sense. Fairblock enhances DeFi by introducing confidentiality features, such as protected encrypted trades, sealed-bid auctions, and fair price discovery mechanisms. These are the tip of the iceberg.

### Derived Private Key

A Derived Private Key corresponds to a specific encryption condition (identity) and is required to decrypt transactions once conditions are met. Validators generate derived keyshares. The derived private key is obtained by aggregating a threshold number of derived private keyshares.

### Distributed Key Generation (DKG)

Distributed Key Generation is a process by which a group of participants jointly generate a public and private key pair without any single party knowing the private key. Fairblock now uses this instead of the ShareGenerationClient for generation of the decryption key and distributing it to the validator network enhancing security and decentralization.

### Dynamic Confidential Computing

The core engine of FairyRing. It offers the ability to adjust the level of confidentiality based on the specific needs of the integrating application, or specific transaction. This means that even within the same app integrating into Fairblock, different variance in confidentiality can be obtained in the UX. Fairblock's network leverages MPC-based multimodal cryptography, allowing developers to tailor performance, security, and costs to their applications’ unique requirements.

## E

### External Chain cApp

An external chain cApp is a confidential application (cApp) built on the different chains (ex. EVMs, RustVMs, Cosmos Chains, etc.) using Fairblock's infrastructure and integrating with FairyRing. This allows developers to create cApps on a multitude of blockchains.

## F

### Fair Price Discovery

A mechanism that ensures prices are determined in a transparent and equitable manner, free from manipulation. Fairblock aims to provide fair price discovery for token launches and other financial activities by preventing frontrunning and other exploitative behaviors. Future articles will be written on this topic.

### Fairblock

Fairblock leverages dynamic confidential computing to mitigate centralized risks and prevent information leakage and manipulation in decentralized applications. This unlocks Credible and Confidential DeFi mechanisms and AI models.

Fairblock consists of a blockchain purpose-built for hosting cApps leveraging the full dynamic confidential compute features within its chain, and also offers flexible integration into external chains looking to bring confidential compute to their ecosystems.

### FairyPort

Acting as a relayer option, FairyPort is an off-chain service that acts as a messaging bridge, reading the state of the destination chain and FairyRing. It is used to communicate between the two networks for the passing of keys for decryption. Each transaction has a respective ID that corresponds to a keyshare used to decrypt on the destination chain, enabling the execution of the respective transaction.

<!-- TODO: add link to FairyPort repo -->

### FairyRing

A dynamic and decentralized network that hosts app-specific secure and performant confidential computing.

FairyRing is Fairblock's native blockchain and is a Cosmos chain itself. It holds a number of novel features. Among the most important is that no relayers are needed since the confidential computation, and contract call-back are native functions of the hosting chain itself. Apps built within FairyRing benefit from more performant operations. FairyRing frictionlessly integrates with any chain where having an interconnected environment of chains deepens liquidity and ultimately makes FairyRing as a network more robust.

### `fairyringclient`

Every validator on `fairyring` runs `fairyringclient`, which is responsible for updating the MSK share each time it changes, deriving the private keyshare from the MSK for each ID (condition for which transactions are encrypted/decrypted), and then sending that derived private keyshare to `fairyring`. The submitted keyshares are then used to construct the derived private key.

### FairyKit

A module that enables confidential computing for applications within our native ecosystem or across external chains.

### Fully Homomorphic Encryption (FHE)

Fully Homomorphic Encryption (FHE) is a technology that enables processing data without decrypting it. This unlocks a lot of applications, such as providing a service without ever seeing users’ data, and users will never notice a difference in functionality. This type of environment truly allows for end-to-end encryption. Fairblock includes FHE within its suite of dynamic confidential computing methods.

### Frontrunning

Frontrunning is an example of bad-MEV ([`maximal extractable value`](https://ethereum.org/developers/docs/mev#mev-extraction-generalized-frontrunners)) where MEV searchers can observe a user's unexecuted profitable trade in a mempool and manipulate the ordering of transactions within a block. The most common type of frontrunning is _sandwich attacks_.

## H

### Hidden Information GameFi

The main GameFi category that Fairblock is focusing on. Through the use of dynamic confidential computing, the blockchain gaming industry can explore new narratives revolving around conditionally hidden traits, skills, storylines, and more. Fairblock is working with projects like XAI to explore these paradigms.

## G

### General Condition Decryption

The use of any condition to trigger the decryption of an encrypted transaction or message. In FairyRing, this is enabled using the `x/pep` module where conditions, including but not limited to block height, can be used for encryption and decryption. Some examples include: asset price, lending market interest rates, game-specific variables, etc.

## I

### Intent Matching

The process of aligning user intentions with optimal transaction outcomes. FairyRing strives to help unlock confidential intent matching to optimize transactions like trades and auctions, ensuring that user intentions are met without exposing sensitive information.

## M

### Malicious Validators

In Fairblock, malicious validators include those who send incorrect private keyshares to FairyRing or skip blocks. Such actions are subject to slashing conditions under the Proof of Authority consensus mechanism.

### Master Public Key (MPK) or Active Public Key

A public key is a large cryptographic value that is used to encrypt data. The public key is publicly visible and used to identify some encrypted data. The public key is derived from the private key, a randomly generated cryptographic value that is needed to decrypt data.

In asymmetric encryption and its derivatives, public keys are openly known, while private keys are only made available to owners or receivers of some dataset and signify true owners of data.

A **Master Public Key (MPK) or Active Public Key** is used to encrypt every transaction within an epoch. At the end of an epoch, a new MPK is generated, ensuring transaction confidentiality is preserved dynamically over time.

The active public key (`ActivePubKey`) is replaced by the queued public key (`QueuedPubKey`) at the beginning of a new epoch. The MPKs are derived from the Master Secret Key, which is generated by the [`ShareGenerationClient`](./running-a-node/share_generation_client.md).


### Multi-Party Computation (MPC)

A cryptographic method that allows multiple parties to jointly compute a function over their inputs while keeping those inputs private. In Fairblock, MPC is used in various ways depending on what applications need. In a general sense, Fairblock uses MPC is used to enable decentralized confidential transactions, ensuring that no single party has access to all the information.

### Proof of Authority (PoA)

Proof of Authority is a consensus mechanism that gives a vetted, designated number of validators permission to validate transactions on the network. In Fairblock's initial release, PoA is utilized, with slashing conditions for malicious validators who submit incorrect keyshares or skip blocks.

## P

### Precompiles

Precompiles are predefined smart contracts that have special addresses and provide specific functionality which is executed not at the EVM bytecode level, but natively by the respective client itself, such as Arbitrum. Precompiles are primarily used to introduce specific functions that would be computationally expensive if executed in EVM bytecode, and functions that facilitate the interaction between the parent chain and the child chain. By having them natively in the client, they can be optimized for performance. Fairblock uses precompiles to integrate confidential compute functionality, in communication with FairyRing, to any EVM.

Smart contracts can interact with these precompiles on said EVMs the same way as any other EVM solidity function.

### Private Governance (privgov)

A sample blockchain built using Cosmos SDK and Tendermint, and a mixture of the x/pep module created with Ignite CLI. It is a basic working cosmos chain that uses the Fairblock/cosmos-sdk to enable private governance. It is showcased as a blockchain for educational demonstrative purposes [here](./build/cosmos/cosmos_privgov.md).

## Q

### Queued public key

The queued public Key (`QueuedPubKey`) is the queued MPK that will replace the `ActivePubKey` at the start of a new epoch.

## S

### Sealed-Bid Auctions

An auction format where all bidders submit their bids without knowing the bids of other participants. Fairblock strives to use this format for optimized intent matching, ensuring fairness and confidentiality in the bidding process. Currently, sealed-bid auctions can be seen within the FairyRing testnet and in the Fairblock tutorials.

### ShareGenerationClient

The `ShareGenerationClient` was responsible for generating the MSK and distributing it to the validator network using VSS
([Verifiable Secret Sharing](https://en.wikipedia.org/wiki/Verifiable_secret_sharing)).
Refer to [`ShareGenerationClient`](./advanced/share_generator.md) for more details.

**Note:** The `ShareGenerationClient` has replaced by distributed key generation (DKG).

## T

### Threshold encryption

Threshold encryption is a form of cryptography that allows a private key to be derived as long as a certain threshold of network participants come together to aggregate their private keyshares.

### Threshold IBE

Identity-based encryption is a form of encryption based on some identifying conditions.
Fairblock uses **threshold** IBE so that no single party controls the decryption keys. Instead of "Identity", Fairblock uses "conditional ids" which are less about actual identity, and more about a range of different variables, often related to a chain's global state, such as block height.

## X

### x/pep

<!-- TODO: confirm about this -->

The pep module is responsible for decrypting, decoding and processing encrypted transactions from users. It is inherent to FairyRing, and can be adopted by other Cosmos Chains. For a guide on encrypting transactions, please read the guide [here](./advanced/pep_module.md).


