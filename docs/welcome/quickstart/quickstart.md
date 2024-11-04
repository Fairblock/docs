---
sidebar_position: 0
---

# Developer Quickstart: Build Encrypted/Decrypted Apps or Chains with Fairyring

An encrypted/decrypted App or Appchain unlocks programmable encryption and paired conditional decryption and execution using Fairblock's decentralized appchain, Fairyring. 

When working with Fairyring, there are two main developer audiences that have been highlighted, and subsequent quickstarts will be provided to assist them.  

1. Blockchain Developers creating their own chains leveraging Fairblock Technologies, such as Roll-Ups and AppChains.
2. App Developers creating apps on EVMs or appchains. 

> These quickstarts are currently under development, and will be added to these docs as soon as possible.

Currently, the Arbitrum Stylus quickstart, v1, has been added to these docs, and can be found on the next page.

<!-- OK, the layout of the quickstart:
1. Describe the NECESSARY things to not get lost in the quickstart. REMEMBER: the quickstart itself will have explanations for key fundamental concepts.
2. Outline that there are two different quickstart categories: chain development and app development
3. Inside each of the quickstarts, that's where you can break out what they will learn in them -->

## What is an Encrypted/Decrypted App?

<!-- TODO ALL: - replace encrypted/decrypted with a name for apps that use fairblock - we need to finalize that term -->

Apps or AppChains have active communication with the Fairyring chain. This communication mainly consists of the following steps:

1.  App or Appchain listens to the Fairyring for new Master Public Keys (MPKs) to encrypt their respective transactions.
2.  Fairyring listens for a condition, and corresponding ID, to trigger generating a decryption key (keyshare).
3.  Once generated, keyshare is shared with the respective App or Appchain. The App or Appchain then executes the transaction at the beginning of the block to avoid risks arising from delayed execution.

_To learn more about the concepts above, read more in the [learn](TODO-GetLink) section._

<!-- TODO - Show visual for apps and appchains talking to Fairyring -->

### Quickstarts for App Developers 

These quickstarts will guide you through the steps to spin up a local chain or appchain quickly and deploy your own apps using fairyring functionality.

<!-- Links will be to their respective pages in the docs -->

1. [Deploy and interact with contracts using Arbitrum Stylus that allows for encryption and decryption using Fairyring functionality](https://github.com/Fairblock/ArbitrumContracts)
2. Create an App that works with encryption and decryption offering fairyring functionality - TBD
3. Create an App that works with encryption and decryption with an AppChain offering fairyring functionality - TBD

### Quickstarts for Chain Developers 

<!-- Links will be to their respective pages in the docs -->
These quickstarts will guide you through the steps to modify your EVM or appchain to work with fairyring, and deploy it in a local environment.

1. Modify EVMs with Precompiles to Integrate with Fairblock Technologies - TBD
2. Integrate Fairblock Technologies Modules into Your Own AppChain - TBD


