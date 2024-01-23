---
sidebar_position: 3
---

# Keyshare aggregation

The key share aggregation process is made possible through Threshold Encryption.
Once enough validators have submitted keyshares for a particular block,
the keyshares are aggregated to generate the derived private key for that block.
The derived private key can then be used to decrypt encrypted transactions and execute them.
To create the aggregated keyshare, it is not required for every validator to submit their individual keyshares.
The aggregation can be performed as long as a threshold number of keyshares are submitted.
Currently, at least `2/3 + 1` of the validators have to submit keyshares to create the aggregated keyshare.
