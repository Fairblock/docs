---
sidebar_position: 2
---

# Fairblock High-Level Architecture

When Apps or AppChains integrate with Fairblock technologies, they have active communication with the Fairyring chain. This communication is the foundation to the transaction flow when working with Fairblock.

**Typical Components**

The high level architecture and components involved in most integrations are listed below and correspond to the FairyRing v1 schematic shared too. Links to more information on each are provided for easier reference as well:

<!-- TODO: get links to all of these -->

![Simplified Architecture of Fairblock v1](../../static/img/FairyRingInfoGraphic.png)

1. [Fairyring](TODO:GetLinkToAdvancedSectionForThis) - Fairblock's native chain and ecosystem, that also provides decentralized keys for encryption and decryption to other chains.
2. [Encryption SDK](../../advanced/encrypt_tx.md) - An off-chain software used to encrypt transactions to be submitted to the Destination Chain. Once the encrypter is integrated with applications (front-end or wallets), users will seamlessly encrypt their transactions. Encryption happens, end-to-end, locally within the browser and is not relying on any third parties.
3. [`fairy` module](TODO:GetLinkToAdvancedSectionForThis) - Developers can simply install this module to empower their appchains and EVM apps to receive and process encrypted transactions. To be more specific, this module's takes care of receiving and storing encrypted transactions, decryption, verification, and execution within Destination Chains. 
<!-- TODO: make a new sub page in advanced for `fairy` module -->
4. [Fairyport](../../advanced/fairyport.md) - An off-chain software that actively listens and coordinates between the Fairyring and  destination chains for transaction decryption and execution. 
5. Destination Chain - The chain storing encrypted transactions, receiving public keys, and secret keys from Fairyring, and where the transactions are executed. This can be Fairyring itself with native applications to its chain.

_To learn more about the concepts above, read more in the [learn](TODO-GetLink) and respective [advanced](TODO-GetLink) sections._

Now that the high level components have been introduced, developers are encouraged to be work with the technology by going through quick starts that interest them.