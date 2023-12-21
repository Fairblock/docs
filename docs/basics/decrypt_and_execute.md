---
sidebar_position: 5
---

# Transaction decryption and execution

Upon reaching the target height, the transaction is automatically decrypted using the aggregated keyshare of the particular block height
and executed before any of the mempool transactions for that block can be processed.

Note the following two things:

- encrypted transactions are stored in the [`x/pep`](../advanced/pep_module.md) of their corresponding chains. They are not transferred over IBC to the `fairyring`.
- encrypted transactions are executed in their corresponding chains (not `fairyring`).
- the target height for the execution of an encrypted transaction corresponds to the height on `fairyring`.
