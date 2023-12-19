---
sidebar_position: 4
---

# Integration

For integrating with Fairblock to enable encrypted transactions, the destination chain has to import the **Decryption** module as well as run a relayer service.
From the user perspective, the encryption needs to occur in browser. The following is an example of the potential flow.

1. User makes a transaction with a desired execution height `h` of **Fairyring**.
2. The frontend or wallet would first fetch:
   - the current public key `mpk` from **Fairyring**
   - the user's **PepNonce** from the destination chain used for signing.
3. The transaction `tx` will first be signed with the user's **PepNonce** (result `signed_tx`)
4. The signed transaction will be encrypted with `mpk` and `h` (result `enc_tx = Enc(signed_tx, mpk, h)`)
5. The user signs the `SubmitEncryptedTx(enc_tx, h)` transaction with the regular sequence number and submits to the destination chain.

The signing part of the transaction may be possible to do via one action from the user to make UX friction as little as possible.
