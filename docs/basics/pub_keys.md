---
sidebar_position: 1
---

# Public Keys

Users encrypt their transactions using a master public key (MPK) and then choose the condition for decryption (the ID).
`fairyring` maintains at most two MPKs at any given time: an `ActivePubKey` and a `QueuedPubKey`.
Both kinds of MPKs are submitted to the network with expiry block heights. These expiry block heights mark the end of epochs.
The `ActivePubKey` is the one currently being used for encrypting transactions.
The `QueuedPubKey`, as the name suggests, is an MPK that will replace the `ActivePubKey` once the current `ActivePubKey` expires.
Active and Queued MPKs are generated and replaced at the end of epochs, which are encoded block heights for MPK generation and renewal.
