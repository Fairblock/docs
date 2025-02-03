---
sidebar_position: 0
---

# Troubleshooting `fairyring`

<!-- TODO - Talk to p0p3yee with recent update for FairyPort. Perhaps add a more general FAQ to start, then get into the nitty gritty of FairyRing and fairyclient -->

## Sequence mismatch or Invalid Signature

When sending transactions using the `fairyringd` binary, If you get `sequence mismatch` / `Invalid Signature` error:

1. Make sure the `chain-id` is set correctly:

```bash
fairyringd config
```

The command above will show you the binary config:

```bash
{
 "chain-id": "fairyring-testnet-1",
 "keyring-backend": "test",
 "output": "text",
 "node": "tcp://localhost:26657",
 "broadcast-mode": "sync"
}
```

Make sure the `chain-id` is set correctly, the chain id for latest testnet is `fairyring-testnet-1` and you can update it in `$HOME/.fairyring/config/client.toml`

2. If you are validator and running `fairyringclient`, stop it and wait for around 10 seconds (2 blocks), then try sending the transaction again.

## Error reconnecting to peer

When running the node, if you get error like this:

```bash
Error reconnecting to peer. Trying again addr={"id":"21f2101e89236698274555b985822857c3ec5918","ip":"35.38.127.127","port":24756} err="incompatible: peer is on a different network. Got fairyring-2, expected fairyring-testnet-1" module=p2p tries=7`
```

It means your chain id is incorrect, you can update it by following [this](#sequence-mismatch-or-invalid-signature)

## Gentx bonded token amount confusion

Currently `10000000000ufairy` is the suggested amount.
It is recommended to bond the amount not less than the suggested amount if you would like to participate in submitting keyshares,
because there is a minimum bonded token requirement when registering as a validator in the `keyshare` module.

## `fairyring` binary log error messages

These error messages can be ignored if it shows up in the logs:

- `ERR Last executed height not exists module=x/pep`
- `Beginblocker get keys err module=x/pep`
- `ERR port ID (pep) channel ID (): channel not found module=x/pep`
- `Latest height does not exists in EndBlock module=x/pep`

This occurs when there are no destination chains connected to `fairyring`.

## Validator Status: Unbonding or Jailed

You can check your validator status by the following command:

```bash
fairyringd query staking validators -o json | jq
```

When your validator status is showing `Unbonding` like this:

```json
{
  "operator_address": "fairyvaloper1zrpp7dfav7kancgse2peh3k98u9ueajwhmnm3y",
  "consensus_pubkey": {
 "@type": "/cosmos.crypto.ed25519.PubKey",
 "key": "03vG/iogYilO9qeSoVIJIZl6QC3ARWFgqSwhQ621z3g="
  },
  "jailed": false,
  "status": "BOND_STATUS_UNBONDING",
},
```

or `Jailed` like this:

```json
{
  "operator_address": "fairyvaloper1zrpp7dfav7kancgse2peh3k98u9ueajwhmnm3y",
  "consensus_pubkey": {
 "@type": "/cosmos.crypto.ed25519.PubKey",
 "key": "03vG/iogYilO9qeSoVIJIZl6QC3ARWFgqSwhQ621z3g="
  },
  "jailed": true,
},
```

You can run the following command to unjail your validator:

```bash
fairyringd tx slashing unjail \
  --from=<YOUR KEY NAME> \
  --chain-id=fairyring-testnet-1 \
  --gas=auto \
  --gas-adjustment=1.4
```
