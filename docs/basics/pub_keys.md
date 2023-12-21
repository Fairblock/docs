---
sidebar_position: 1
---

# Public Keys

Users need to encrypt their transaction using a public key and the private keys for decrypting the transactions must be generated on a per block basis.
`fairyring` maintains at most 2 public keys at any given time, An `ActivePubKey` and a `QueuedPubKey`.
Both kinds of public keys are submitted to the network with expiry heights.
The `ActivePubKey` is the one currently being used for encrypting transactions.
The `QueuedPubKey`, as the name suggests, is a pubkey that will replace the `ActivePubKey` once the current `ActivePubKey` expires.
