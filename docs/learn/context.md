---
sidebar_position: 1
---

# Why Fairblock

<!-- TODO - reword this copy that was the original intro to remove redundancies that arise after the reorg. -->

Encryption is desperately lacking in blockchain networks and their applications. This lack is a critical roadblock to the global adoption of blockchains - a roadblock that stands tall for millions of everyday users and institutions alike.

Fairblock is building programmable encryption solutions that serve as building blocks for decentralized applications and networks. We’re developing encryption services that can be integrated directly into application frontends and as deep as the protocol level of blockchains. 

# How Fairblock Works

Fairblock's appchain, The `fairyring` chain uses Threhsold IBE (Identity Based Encryption) to allow users to encrypt transactions using a public key,
which then decrypts and executes automatically at the target height.
For this to work, the derived private key required to decrypt the transactions must be created on a per-block basis to leave no room for front-running.
Also, once the derived private key is available, the encrypted transactions must be executed before any other transactions from the mempool.
This is the crux of the operation of the `fairyring` chain.

More specifically, the `fairyring` chain is responsible for generating identities (encryption keys).
It is also responsible for generating the aggregated key for each corresponding identity (decryption keys).
On `fairyring` itself, any encrypted transactions can also automatically be decrypted and executed when a decryption key is made available. This means that the `fairyring` chain can have its own thriving ecosystem as other appchains do.

The following flow gives an idea of how `fairyring` works.

![General flow for `fairyring`](../assets/fairyring-overview.png)
