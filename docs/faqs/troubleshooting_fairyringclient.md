---
sidebar_position: 1
---

# Troubleshooting `fairyringclient`

## Error getting share:Get Share Resp is empty

When starting Fairyringclient, if you see the following error:

```json
Error getting share:Get Share Resp is empty, body: {"pk":"","encShare":"","index":""}
```

This means your RSA key is not whitelisted on our Share Generation API Server, wait until your key is whitelisted before running the client.

## Account sequence mismatch

This might happens when the client is submitting keyshare and you restart it. Wait around 10 seconds (2 blocks) before restarting the client.

## Validator authorized another address

If you see this error when starting Fairyringclient:

```json
rpc error: code = Unknown desc = failed to execute message; message index: 0: validator authorized another address to submit key share is not allow to submit key share
```

That means your validator address already authorized another address to submit key share for you. You can update the config to use the authorized address to submit key share or delete the authorized address.

## Validator not registered error

If you see this error when starting Fairyringclient:

```json
ERROR: rpc error: code = Unknown desc = failed to execute message; message index: 0: 'your address': validator not registered
```

Check if is your validator status jailed / unbonding:

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
