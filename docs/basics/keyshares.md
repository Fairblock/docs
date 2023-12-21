---
sidebar_position: 2
---

# Keyshares

Keyshares are submitted by validators corresponding to the `ActivePubKey` to generate decryption keys per block.
Each validator needs to run their own client to submit their keyshares.
The client gets their keyshare from our [Share Generation API](../running-a-node/share_generation_api.md),
derives the keyshare corresponding to the current block height and finally submits a transaction to `fairyring`.
Malicious validators that send incorrect keyshares will be slashed.

The initial release will be a Proof of Authority (PoA) chain similar to the approach used by [Noble](https://github.com/strangelove-ventures/noble).
There are some simple slashing conditions implemented for now (such as submitting incorrect keyshares, or skipping blocks), but this may change.
