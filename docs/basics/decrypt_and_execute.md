---
sidebar_position: 5
---

# Transaction decryption and execution

Upon reaching the target height, the transaction is decrypted using the derived private key of the particular block height
and executed before any of the mempool transactions for that block can be processed.

The derived private key for target block heights is sent to the destination chain via [`fairyport`](../advanced/fairyport.md),
a messaging bridge developed by the Fairblock team that reads the state of the destination chain and `fairyring` to communicate to
`fairyring` when conditions for decryption are met on the destination chain.
When `fairyring` is notified that the decryption conditions have been met,
the validators compute their derived private key shares and submit them to `fairyring` for key share aggregation.
When the threshold is met, `fairyring` constructs the derived private key, emits a state change with the derived private key in the state,
and then `fairyport` sends the private key to the destination chain after observing the FairyRing state change.

Once the destination chain has access to the derived private key, it decrypts the encrypted transaction in the mempool and executes it.

Note the following two things:

- encrypted transactions are stored in the [`x/pep`](../advanced/pep_module.md) of their corresponding chains. They are not transferred over IBC to `fairyring`.
- encrypted transactions are executed in their corresponding chains (not `fairyring`).
- the target height for executing an encrypted transaction corresponds to the height on `fairyring`. Decryption triggered by another chain's conditions is live for private governance, while alternative conditions for decryption on destination chains will soon be implemented.
- interactions between `fairyring` and Cosmos chains will work differently than non-Cosmos chains. We will share information regarding non-Cosmos chains soon.

Here is a diagram to show how this process works from end to end:
![](docs/assets/Fairblock architecture - cosmos.png)
