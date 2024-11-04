---
sidebar_position: 0
---

# Developer Quickstart: Build Confidentiality Apps or Chains with Fairyring

A Confidentiality App, or cApps, unlocks programmable encryption and paired conditional decryption and execution using Fairblock's decentralized appchain, Fairyring. They can take the form as an App itself on a network like an EVM or an Appchain itself.

When working with Fairyring, there are two main developer audiences that have been highlighted, and subsequent quickstarts will be provided to assist them.  

1. Blockchain Developers creating their own chains leveraging Fairblock Technologies, such as Roll-Ups and AppChains.
2. App Developers creating apps on EVMs or appchains. 

## What is a cApp?

Apps or AppChains have active communication with the Fairyring chain. This communication mainly consists of the following steps:

1.  App or Appchain listens to the Fairyring for new Master Public Keys (MPKs) to encrypt their respective transactions.
2.  Fairyring listens for a condition, and corresponding ID, to trigger generating a decryption key (keyshare).
3.  Once generated, keyshare is shared with the respective App or Appchain. The App or Appchain then executes the transaction at the beginning of the block to avoid risks arising from delayed execution.

_To learn more about the concepts above, read more in the [learn](TODO-GetLink) section._

<!-- TODO - Show visual for apps and appchains talking to Fairyring -->

### Quickstarts for App Developers 

These quickstarts will guide you through the steps to spin up a local chain or appchain quickly and deploy your own cApps using fairyring functionality. 

> The Fairblock technology can already be integrated with various EVM Rollups, Appchains, and other tech stacks. More tutorials are being actively worked on showcasing different integration setups, and will be published more over the coming months. If you would like help integrating with a different tech stack that our current tutorials do not cover, please reach out!

<!-- Links will be to their respective pages in the docs -->

1. [Deploy and interact with a cApp using Arbitrum Stylus](https://github.com/Fairblock/ArbitrumContracts)
2. Deploy and interact with a cApp using OP Stack - TBD
3. Deploy and interact with a cApp using an AppChain integrated with Fairyring - TBD

### Quickstarts for Chain Developers 

<!-- Links will be to their respective pages in the docs -->
These quickstarts are for developers interested in creating their own EVM rollups, Appchains, or other networks integrated with fairyring functionalities. These quickstarts will guide you through the steps to modify your EVM or appchain to work with fairyring, and deploy it in a local environment.

1. Modify EVMs with Precompiles to Integrate with Fairblock Technologies - TBD
2. Integrate Fairblock Technologies Modules into Your Own AppChain - TBD