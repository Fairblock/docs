---
sidebar_position: 0
---

# v1 Overview

<!-- The org of this section should be (assuming reader has read the intro, but then jumped straight to Learn to understand the protocol). We will assume that it is an average reader:
1. Overview of how Fairblock works again (schematic); use the schematic and walk through key points. Make sure to point out how AppChains and EVMs differ in how they work under the hood, but not in practice.
2. Introduce the next pages: cryptography and the network. -->

For v1, Fairblock's appchain, the `fairyring` chain uses Threhsold IBE (Condition ID Based Encryption) to allow users to encrypt transactions using a public key,
which then decrypts and executes automatically at the target height.

The following flow gives an idea of how `fairyring` v1 works.

![General flow for `fairyring` v1](../../assets/fairyring-overview.png)

> Apps refer to applications living on EVMs, and AppChains are those within the cosmos ecosystem.

Apps or AppChains have active communication with the Fairyring chain. This communication mainly consists of the following steps:

1.  App or Appchain listens to the Fairyring for new Master Public Keys (MPKs) to encrypt their respective transactions.
2.  Fairyring listens for a condition, and corresponding ID, to trigger generating a decryption key (keyshare).
3.  Once generated, keyshare is shared with the respective App or Appchain. The App or Appchain then executes the transaction at the beginning of the block to avoid risks arising from delayed execution.

Apps can do this because their EVMs will have access to a immutable contract exposing necessary function for encryption, decryption and execution, due to a Fairblock precompile being integrated into said EVM. Appchains add on the `x/pep` module to communicate with the `fairyring` chain, which is elaborated further in this section.

> In addition to communicating and unlocking encryption and conditional decryption/execution for destination chains, the `fairyring` chain can have its own thriving ecosystem as other appchains do. This is possible because any encrypted transactions can also automatically be decrypted and executed on the `fairyring` when a decryption key is made available.

The later pages in this section covers the detailed fundamentals of Fairblock. These include:

**The Cryptography**

1. [An explanation on how IBE and tIBE are used within the `fairyring` chain.](./v1_cryptography.md)

**The Network**

1. [The purpose of Master Public Keys (MPKs), and how they are used to encrypt transactions.](./network/pub_keys_and_encryption.md)
2. [How MPKs and Decryption Keys (keyshares) are generated using the `fairyring` and its validators in a decentralized manner.](./network/keyshares_and_aggregation.md)
3. [How the keyshares are used to decrypt and enact automatic execution of an encrypted transaction at the beginning of a block.](./network/decrypt_and_execute.md)
<!-- TODO: 4. [How Fairblock Works with EVMs and Appchains](./network/evm_and_appchains.md) -->

<!-- Hmm. Where do we talk about the way EVM integration works? It will be part of the quickstart, sure, but it should be in a spot clearly in the LEARN section. -->
