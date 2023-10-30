---
sidebar_position: 2
---

# PEP module

The **PEP** module is a Cosmos-SDK module responsible for the decryption and execution of encrypted transactions. This module would be installed on the destination chain.

## Encrypted Tx Array

We store the encrypted transactions in an array based on their target execution height. The height corresponds to the block height of **Fairyring**, that is, depending on the block time of the destination chain, in a particular block on the destination chain multiple keyshares may be received within the block.
Can think of the encrypted tx array as a temporary sequencer for encrypted transactions yet to be executed.

```proto
message EncryptedTx {
  uint64 targetHeight = 1;
  uint64 index = 2;
  string data = 3;
  string creator = 4;
}

message EncryptedTxArray {
  repeated EncryptedTx encryptedTx = 1 [(gogoproto.nullable) = false];
}
```

## Nonces

To prevent replay attacks, transaction signatures require a nonce or sequence in addition to signing the transaction data. Because submitting an encrypted transaction counts increments the sequence, the underlying encrypted transaction must be signed with `sequence + 1`.
However, whenever a user submits another transaction, the sequence will be changed, and the encrypted transaction will fail once it is decrypted. To address this, we include a specific `PepNonce` to address this. `PepNonce` is incremented when an `AppendEncryptedTx` is processed.

```proto
message PepNonce{
  string address = 1;
  uint64 nonce = 2;
}
```

Note that this can extend to users submitting encrypted transactions on behalf of other users. Right now, we only allow the internal transaction address to submit the encrypted transaction.
The signature verification process is kept the same for regular transactions with the modification of checking against the above sequences rather than the original sequence.

## BeginBlock

Most of the execution logic occurs in **BeginBlock**. In particular, we:

1. Fetch the decryption keys from the current mempool.
2. For all pending encrypted transactions with target height in the range of current decryption keys:

   - We perform decryption of the transactions to obtain individual transactions
   - We check the signatures of the transaction to make sure the transaction is valid
   - We try to execute the decrypted transaction
