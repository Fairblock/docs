---
sidebar_position: 0
---

# Overview

The `fairyring` chain uses Threhsold IBE (Identity Based Encryption) to allow users to encrypt transactions using a public key,
which then decrypts and executes automatically at the target height.
For this to work, the derived private key required to decrypt the transactions must be created on a per-block basis to leave no room for front-running.
Also, once the derived private key is available, the encrypted transactions must be executed before any other transactions from the mempool.
This is the crux of the operation of the `fairyring` chain.

More specifically, the `fairyring` chain is responsible for generating identities (encryption keys).
It is also responsible for generating the aggregated key for each corresponding identity (decryption keys).
On `fairyring` itself, any encrypted transactions can also automatically be decrypted and executed when a decryption key is made available.

The following flow gives an idea of how `fairyring` works.

![General flow for `fairyring`](../assets/fairyring-overview.png)
