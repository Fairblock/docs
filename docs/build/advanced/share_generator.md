---
sidebar_position: 3
---

# `ShareGenerator`

`ShareGenerator` is a binary for generating & deriving keyshares, mainly for a local development / testing environment.
It can generate valid key shares, commitments and master public keys while also providing functionality to derive keyshares for a specific ID.
Developers can use this binary to test the encryption, decryption and key aggregation processes on `fairyring`.

This tutorial explains how to install and run the `ShareGenerator`.
Make sure you have completed the steps in the [prerequisites](../running-a-node/prerequisites.md) prior to following the instructions below.

## Installation

```bash
cd $HOME
git clone https://github.com/Fairblock/ShareGenerator.git
cd ShareGenerator
go mod tidy
go install
```

## Usage

### Generate shares

```bash
ShareGenerator generate [number-of-shares] [threshold]
```

Example on generating 1 keyshare with threshold 1:

```bash
ShareGenerator generate 1 1 | jq
{
  "Shares": [
    {
      "Value": "4fcc919fbbac7ddca4be891bc0ee6afd02a3dfe3acee206d7ee1bfba42abeba6",
      "Index": 1
    }
  ],
  "MasterPublicKey": "820b2db6e86aabed93b3aa18e1a7416434f5a0d87b3fdba20a3ccd331472dc4285e4b10d0ca8f3e340924c2b858df5d1",
  "Commitments": ["820b2db6e86aabed93b3aa18e1a7416434f5a0d87b3fdba20a3ccd331472dc4285e4b10d0ca8f3e340924c2b858df5d1"
  ]
}
```

### Derive keyshare for a specific ID

```bash
ShareGenerator derive [share-in-hex] [share-index] [ID]
```

You can get the `[share-in-hex]` & `[share-index]` from the `generate` command, here is an example on the deriving the keyshare above for ID `100`:

```bash
ShareGenerator derive 4fcc919fbbac7ddca4be891bc0ee6afd02a3dfe3acee206d7ee1bfba42abeba6 1 100 | jq
{
  "KeyShare": "93096b31b1af2728a8d82cf5b27eead2d802e229b8fb7597e47702d691ee65d271cf2f6c4728f8aee0bc042636b2c86400d721d2355aeb307b88906b9e403025bb8566a4adc58b1c412cf11fab8ed9cd357ebbaa1db5f2deb31327c7b901e1ec",
  "Commitment": "820b2db6e86aabed93b3aa18e1a7416434f5a0d87b3fdba20a3ccd331472dc4285e4b10d0ca8f3e340924c2b858df5d1"
}
```

The ID does not need to be a number, it can also be a string:

```bash
ShareGenerator derive 4fcc919fbbac7ddca4be891bc0ee6afd02a3dfe3acee206d7ee1bfba42abeba6 1 "target_id" | jq
{
  "KeyShare": "a7348fb8cf57c1adf655f8d27c79086a5fd356285a6f00c9aea05ea6d2a8da63e08ea27d10d91b83be0778fc652d9c920ed18690f5e776ec3fb57e2504949bbe31deef8648c488263d871f040d5d2781068a3c2f78b057fef57397310367fb7d",
  "Commitment": "820b2db6e86aabed93b3aa18e1a7416434f5a0d87b3fdba20a3ccd331472dc4285e4b10d0ca8f3e340924c2b858df5d1"
}
```
