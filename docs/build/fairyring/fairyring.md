---
sidebar_position: 2
---

# Fairblock: Building Apps within FairyRing

Building cApps within FairyRing continues to becomer more simpler than ever. cApps currently can leverage the following chain features built atop of FairyRing's confidential computing. The chain is continuously adding native features, so make sure to keep up to date with the project updates. 

1. Leveraging Simple Encrypted Transactions and Block Height Condition IDs
2. Building cApps with General Condition IDs
3. Using private decryption for encrypted transaction access control 
4. Using the `auction` module to carry out sealed-bid auctions

## Building with Simple Encrypted Transactions

A rudimentary feature that apps can build within FairyRing leverages encrypted transactions with execution conditions based on a specific block height. Using this methodology, detailed output details can be used once the respective messages are decrypted so a new realm of apps can be developed. 

The quickstart demo showcasing simple encrypted transactions can be found [here](./fairyring_encrypted_msg.md), and the repo can be found [here](https://github.com/Fairblock/fairyring/tree/feat-auction).

## Building Apps with General Condition IDs

As an even bigger unlock within the Fairblock confidential computation, the `x/pep` module also has the feature of using confidential computation with general conditions, not just FairyRing block height. These conditions can take the form of anything on-chain, be it asset prices, interest rates, or any other metric including those not in DeFi. These conditions are defined within a smart contract, and given unique IDs that are mapped within FairyRing via the `x/pep` module.

A tutorial showcasing general conditions is shown [here](../../build/fairyring/fairyring_private_decryption.md), and more tutorials are under development.

More information on the `x/pep` module can be found [here](../../../advanced/pep_module.md) in the meantime.

## Using Private Decryption vs Public Decryption for Access Control

Encrypted transactions are decrypted using FairyRing where the decryption key is generated once the respective condition is hit. This decryption key is generated in full transparency, and is deemed "Public Decryption," on the FairyRing chain. This fully public generation of the decryption key is fine for many cApp designs, but for some, something called "Private Decryption" may be better suited.

"Private Decryption" is the user flow where the validator keyshares, that are used to construct the transaction-specific decryption key ultimately, are encrypted using the calling user's wallet's public key. This allows tighter sharing of encrypted transactions between parties. For example, a cApp may be creating encrypted messages containing a one-time use password to gain access into a content platform. That one-time password is meant only for one person, whitelisted within a smart contract. The smart contract enabling this transaction can carry out "Private Decryption" and encrypt the keyshares, and ultimately the decryption key, specific to the whitelisted user and no one else.

Further examples (not exhaustive) of both public decryption and private decryption are shown below:

| Public Decryption  | Private Decryption  |
|-----------|-----------|
| Carrying out a swap once a certain price is hit    | Price-Gated content with one-time passwords   |
|  DEX contracts carrying ready-to-go encrypted transactions with swap, liquidity modification, and other details that do not care who decrypts it and executes it    | Intent markets where the intents are encrypted and whitelisted towards specific, trusted solvers    |
| Sealed Bid Auctions for Solvers competing to solve an intent    | Private Data Marketplaces for AI Models    |

## Building with `x/auction` module

A flagship feature of the FairyRing chain, sealed bid auctions are a economic asset the chain brings to cosmos and other chains. Natively, cApps can be deployed using the `x/auction` module within FairyRing where a few commands can start decentralized, sealed bid auctions. As a new innovative space, some builds and examples currently being explored are outlined in the [ecosystem pages](../../ecosystem/ecosystem.md).