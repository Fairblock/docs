---
sidebar_position: 2
---

# Public Keys and Encrypting Transactions

<!-- Add an intro blurb here -->

## Public Keys

Users encrypt their transactions using a master public key (MPK) and then choose the condition for decryption (the ID).
`fairyring` maintains at most two MPKs at any given time: an `ActivePubKey` and a `QueuedPubKey`.
Both kinds of MPKs are submitted to the network with expiry block heights. These expiry block heights mark the end of epochs.
The `ActivePubKey` is the one currently being used for encrypting transactions.
The `QueuedPubKey`, as the name suggests, is an MPK that will replace the `ActivePubKey` once the current `ActivePubKey` expires.
Active and Queued MPKs are generated and replaced at the end of epochs, which are encoded block heights for MPK generation and renewal.

## Encrypting Transactions

Unlike normal transactions, encrypted transactions work a bit differently.
Users can encrypt any transaction with the current `ActivePubKey`.
The user must also specify the target block height of `fairyring` (condition) at which the transaction is to be executed on the chain the transaction resides on.
The submitted encrypted transaction then resides in the [`x/pep`](../advanced/pep_module.md) module of the destination chain.

For more details, refer to [this tutorial](../advanced/encrypt_tx.md).
