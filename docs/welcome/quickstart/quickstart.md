---
sidebar_position: 0
---

# Developer Quickstart: Build Confidentiality Apps or Chains with Fairyring

A Confidentiality App, or cApps, unlocks programmable encryption and paired conditional decryption and execution using Fairblock's decentralized appchain, Fairyring. They can take the form as an App itself on a network like an EVM or an Appchain itself.

When working with Fairyring, there are two main developer audiences that have been highlighted, and subsequent quickstarts will be provided to assist them.  

1. Blockchain Developers creating their own chains leveraging Fairblock Technologies, such as Roll-Ups and AppChains.
2. App Developers creating apps on EVMs or appchains. 

## Typical Transaction Integrating Fairblock

When Apps or AppChains integrate with Fairblock technologies, they have active communication with the Fairyring chain. This communication is the foundation to the transaction flow when working with Fairblock.

**Typical Components**

The components involved in most integrations are listed below. Links to more information on each are provided for easier reference as well:

<!-- TODO: get links to all of these -->

1. [Fairyring](TODO: get link to advanced section for this) - Fairblock's own app chain and ecosystem, that also provides decentralized keys for encryption and decryption to other chains.
2. [Fairyport](TODO: get link to advanced section for this) - An off-chain software that actively listens and coordinates between the Fairyring and respective destination chains for transaction decryption and execution. 
3. Destination Chain - The chain storing encrypted transactions, receiving public keys, and secret keys from Fairyring, and where the transactions are executed.
4. Encrypter - An off-chain software used to generate the encrypted transactions to be stored within the Destination Chain.
5. `x/pep` module (only for AppChains) - Rust module containing the decryption logic that can be used by AppChains integrating Fairblock v1 technologies. It ensures aspects such as: transaction execution within the `begin block` to avoid the front-running, cryptographic checks during the decryption sequence, and more.

**Transaction Flow**

Alongside the transaction flow schematic shared below, here are the quick steps involved when using Fairblock v1 technologies with your App or AppChain.

<!-- TODO:  -->

1. Encrypt the transaction:
    - User or App queues up a transaction. The Front end communicates with Destination Chain to use the public key and encrypt the transaction.
        - The `Encrypter` can be used for this.
    - Encryption requires an ID, which by default is a user-specified Fairyring block height.
    - Encrypted transactions are stored on the Destination Chain.
2. User signs the transaction and the underlying app ultimately calls `SubmitEncryptedTransaction(Encrypt(tx, custom_id))` to `x/pep` module on DChain, or precompiled contracts on EVM. Encrypted tx lives in the destination chain awaiting for decryption and execution. 
3. When decryption condition is met (default is a user-specified Fairyring block height), the Destination Chain will emit an event requesting a decryption key for a specific transaction `id`. Fairyport listens to the request, gets new decryption key from Fairyring, corresponding to respective mined Fairyring block (TODO: confirm if it is most recent block or older block if ID is older). Fairyport then forwards new decryption key to the Destination Chain. 
4. All within the same transaction sequence still: the decryption key is received by the Destination Chain, and decryption and execution is carried our respectively. The App or Appchain then executes the transaction at the beginning of the block to avoid risks arising from delayed execution.
   - TODO: is this just by default with `x/pep` module implemented? OR does the logic need to be written in with respect to the respective appchain? From my understanding, it is 

_To learn more about the concepts above, read more in the [learn](TODO-GetLink) section._

<!-- ![Simplified Architecture of Fairblock v1](TODO: get image from Darshita once done) -->

<!-- TODO: - Show visual for apps and appchains talking with Fairyring -->

Now that the high level components and transaction flow have been touched on, developers are encouraged to be work with the technology by going through quick starts that interest them.

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