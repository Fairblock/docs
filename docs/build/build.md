---
sidebar_position: 1
---
# Building cApps with FairyRing and Other Chains

Within this section, we'll get into tutorials on the specifics of building on FairyRing, and how to build with other chains, including setting up your own chain to work with FairyRing.

_We recommend checking out the "[Start a cApp in 5 minutes](../start-a-capp-in-5-minutes/)" section before digging too deep into the technical aspects within this section._

These tutorials will guide you through the steps to spin up a local blockchain quickly and deploy your own cApps using FairyRing functionality. When working with FairyRing, there are two main developer audiences that have been highlighted. Each tutorial has elements for both audiences to assist them. These audiences are:

1. Blockchain Developers working on their own chains leveraging Fairblock, including, but not limited to, RollUps and Cosmos Chains.
2. App Developers creating apps on EVMs or other blockchains.

> **App Developers do not need to know how to setup the blockchain integration, and Blockchain Developers do not need to know how to setup apps.**

Most of our integration guides and tutorials focus on applications built using MPC and IBE, such as frontrunning protection, auctions, prediction markets, limit orders, and access control.

For confidential stablecoin transfers, we use Homomorphic Encryption (HE). This application does not require special integrations or developer setup. It works seamlessly across all Fairblock-integrated chains, including EVM chains, Solana, Cosmos chains, and FairyRing itself. Developers **do not need to deploy or install any precompiles, modules, or smart contracts**; everything is handled automatically by Fairblock’s simple smart contracts on each supported chain, and the cryptographic computation is abstracted away in FairyRing, without bridging user's funds.

Within each tutorial, developers are invited to skip ahead if they have already integrated the Fairblock modules within the chain that they are working with. This is the recommended route app developers take if possible, and is clearly marked within the beginning of each tutorial.

More tutorials are being actively worked on showcasing different integration setups, and will be published more over the coming months. If you would like help integrating with a different tech stack that our current tutorials do not cover, please reach out!

1. [Apps Native to FairyRing](./fairyring/)
2. [EVMs Modified with Pre-Compiles](./evms/evms.md)
3. [Cosmos Chains Quickstart](./cosmos/cosmos_quickstarts.md)
4. [RustVM Integration with Rust Contracts](./Arbitrum/stylus_rustvm.md)