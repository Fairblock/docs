---
sidebar_position: 2
---

# 🍄 Fairblock: Building Apps within FairyRing

Building cApps within FairyRing continues to becomer more simpler than ever. There are two main approaches:

1. Leveraging Simple Encrypted Transactions and Block Height Condition IDs
2. Building Apps with General Condition IDs

## Building with Simple Encrypted Transactions

A rudimentary feature that apps can build within FairyRing leverages encrypted transactions with execution conditions based on a specific block height. Using this methodology, detailed output details can be used once the respective messages are decrypted so a new realm of apps can be developed. 

The quickstart demo showcasing simple encrypted transactions can be found [here](./fairyring_encrypted_msg.md), and the repo can be found [here](https://github.com/Fairblock/fairyring/tree/feat-auction).

## Building Apps with General Condition IDs

As an even bigger unlock within the Fairblock confidential computation, the `x/pep` module also has the feature of using confidential computation with general conditions, not just FairyRing block height. These conditions can take the form of anything on-chain, be it asset prices, interest rates, or any other metric including those not in DeFi.

A tutorial for building with general conditions is under progress.

More information on the `x/pep` module can be found [here](../../../advanced/pep_module.md) in the meantime.