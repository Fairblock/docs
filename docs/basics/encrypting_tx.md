---
sidebar_position: 4
---

# Encrypting transactions

Unlike normal transactions, encrypted transactions work a bit differently.
Users can encrypt any transaction with the current `ActivePubKey`.
The user must also specify the target block height of `fairyring` (condition) at which the transaction is to be executed on the chain the transaction resides on.
The submitted encrypted transaction then resides in the [`x/pep`](../advanced/pep_module.md) module of the destination chain.

For more details, refer to [this tutorial](../advanced/encrypt_tx.md).
