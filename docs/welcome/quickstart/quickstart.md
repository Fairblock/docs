---
sidebar_position: 0
---

# Developer Quickstart: Build Confidential Apps or Chains with Fairyring

A Confidential App, or cApps, unlocks programmable encryption and paired conditional decryption and execution using Fairblock's decentralized appchain, Fairyring. They can take the form as an App itself on a network like an EVM or an Appchain itself.

When working with Fairyring, there are two main developer audiences that have been highlighted, and subsequent quickstarts will be provided to assist them.  

1. Blockchain Developers creating their own chains leveraging Fairblock Technologies, such as Roll-Ups and AppChains.
2. App Developers creating apps on EVMs or appchains. 

## Fairblock High-Level Architecture

When Apps or AppChains integrate with Fairblock technologies, they have active communication with the Fairyring chain. This communication is the foundation to the transaction flow when working with Fairblock.

**Typical Components**

The high level architecture and components involved in most integrations are listed below and correspond to the FairyRing v1 schematic shared too. Links to more information on each are provided for easier reference as well:

<!-- TODO: get links to all of these -->

![Simplified Architecture of Fairblock v1](../../../static/img/FairyRingInfoGraphic.png)

1. [Fairyring](TODO:GetLinkToAdvancedSectionForThis) - Fairblock's native chain and ecosystem, that also provides decentralized keys for encryption and decryption to other chains.
2. [Encryption SDK](../../advanced/encrypt_tx.md) - An off-chain software used to encrypt transactions to be submitted to the Destination Chain. Once the encrypter is integrated with applications (front-end or wallets), users will seamlessly encrypt their transactions. Encryption happens, end-to-end, locally within the browser and is not relying on any third parties.
3. [`fairy` module](TODO:GetLinkToAdvancedSectionForThis) - Developers can simply install this module to empower their appchains and EVM apps to receive and process encrypted transactions. To be more specific, this module's takes care of receiving and storing encrypted transactions, decryption, verification, and execution within Destination Chains. 
<!-- TODO: make a new sub page in advanced for `fairy` module -->
4. [Fairyport](../../advanced/fairyport.md) - An off-chain software that actively listens and coordinates between the Fairyring and  destination chains for transaction decryption and execution. 
5. Destination Chain - The chain storing encrypted transactions, receiving public keys, and secret keys from Fairyring, and where the transactions are executed. This can be Fairyring itself with native applications to its chain.

_To learn more about the concepts above, read more in the [learn](TODO-GetLink) and respective [advanced](TODO-GetLink) sections._

Now that the high level components have been introduced, developers are encouraged to be work with the technology by going through quick starts that interest them.

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