---
sidebar_position: 5
---

# Share Generation Client

The Share Generation Client is currently responsible for performing the verifiable secret sharing for keyshares.
Keyshares will be rotated every `N` blocks meaning that the master public key (used for encrypting transactions),
keyshares and keyshare commitments (used for submitting to `fairyring`) will be different every round.
The keyshares submitted to fairyring are encrypted with the public key of registered validators.
The master public key will also be submitted to `fairyring` (along with keyshare commitments and number of validators) at the beginning of every round.

This tutorial explains how to interact with fairyring to get the encrypted key shares.

## Getting Encrypted Key Share & Public Key

```bash
fairyringd q keyshare show-active-pub-key -o json | jq
```

Fetches all encrypted keyshares & public key for the current & next round.

**Keep in mind that the keyshare will be rotated every `N` blocks. Make sure to send the share request every `N` blocks for the latest keyshare.**

### Example Output

```json
{
  "activePubKey": {
    "publicKey": "91efe43e750ed1290a2ffe18a2ad4263587fe09cdd50476ce9e819ad85b754d9998b8f3c5615db6424b1361c7c3a31d5",
    "creator": "fairy10tq25z63m3fedlwmtssf5g5qzh9zsjswvmcxc9",
    "expiry": "55",
    "numberOfValidators": "1",
    "encryptedKeyShares": [
      {
        "data": "sN+aiOYCJRrqzdumder0uALKACAcTbu9pILB82reU1vHdp6rl3wol0OFuAomIZXoafE3JQAgZ+RYrmxxCjd7uoJuKo+AgZXD0FQ2RE/vYWIP39+J8VO5yrbtrZ9DddfcNCBEoQuRNkieEUyyl1hAckXanPMR+CzF343AGioVlS5PVli+4ry2QNQK8ZLQUW5ILKHbbZGInd7eQ/79DjsBPI4U5m/KLQ==",
        "validator": "fairy18hl5c9xn5dze2g50uaw0l2mr02ew57zkynp0td"
      }
    ]
  },
  "queuedPubKey": {
    "publicKey": "8d16c3f9a799db33aae1891fbeceab3ae810a9da3af513f5e4afb4236f07dea7685246675909eb5c5f65720ad8deb646",
    "creator": "fairy10tq25z63m3fedlwmtssf5g5qzh9zsjswvmcxc9",
    "expiry": "105",
    "numberOfValidators": "1",
    "encryptedKeyShares": [
      {
        "data": "rJBNYnOA1BK0Cot4YT3bCgLKACBYO5CpT2UM5QWWf7h9qAq88eEEZIbM/iYzgyiBZoz63QAgbXtaLkZHqsY0IKeFfpbK+pNPuYXIJsH3pRe0vYSgo1VDTx/FbEVlt4WhW/w1nsyaX17ymLeGem1Hj/izu4IqBayeUOVHioiswDbRu2OSyliwbx09iRaQfISBKWseHcuEKQTWtfp6KZdd/GfP3C7k8Q==",
        "validator": "fairy18hl5c9xn5dze2g50uaw0l2mr02ew57zkynp0td"
      }
    ]
  }
}
```

- `activePubKey` is the key shares and public key data for the current round
- `queuedPubKey` is the key shares and public key data for the next round
- `publicKey`, the public key / encryption key for the given round.
- `creator` is the creator address of the round
- `expiry`, block number of the key shares expires.
- `numberOfValidators` total number of validators for the round.
- `encryptedKeyShares.data`, keyshare encrypted with `encryptedKeyShares.validator` validator public key.
