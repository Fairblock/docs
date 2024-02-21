---
sidebar_position: 1
---

# `x/pep`

## Abstract

The document specifies the `pep` module of `fairyring`.

The `pep` module is responsible for decrypting, decoding and processing encrypted transactions from users.
For a guide on encrypting transactions, please read [this guide](encrypt_tx).

## State

The `x/pep` module keeps state of the following primary objects:

1. Aggregated keyshares
2. Encrypted transactions
3. Pep nonce
4. Active & queued public keys
5. Latest processed height

## Params

`proto/fairyring/pep/params.proto`

```proto
message Params {  
  option (gogoproto.goproto_stringer) = false;  
  repeated TrustedCounterParty trusted_counter_parties = 1;  
  repeated string trusted_addresses = 2;  
  string channel_id = 3;  
  cosmos.base.v1beta1.Coin minGasPrice = 4;  
}  
  
message TrustedCounterParty {  
  string client_id = 1;  
  string connection_id = 2;  
  string channel_id = 3;  
}
```

<!-- <p style="text-align: center;"><a href="https://github.com/Fairblock/fairyring/blob/36589b54b24f5e116ae7b3d0fb8cc33ce7388194/proto/fairyring/pep/params.proto">See full code on GitHub</a></p> -->

## Messages

### MsgSubmitEncryptedTx

Submit encrypted transaction

`proto/fairyring/pep/tx.proto`

```proto
message MsgSubmitEncryptedTx {  
  string creator           = 1;  
  string data              = 2;  
  uint64 targetBlockHeight = 3;  
}
```

<!-- <p style="text-align: center;"><a href="https://github.com/Fairblock/fairyring/blob/36589b54b24f5e116ae7b3d0fb8cc33ce7388194/proto/fairyring/pep/tx.proto#L18">See full code on GitHub</a></p> -->

The message will fail under the following conditions:

- Target block height is less than or equal to the latest height
- Sender does not have enough tokens for fee

### MsgCreateAggregatedKeyShare

Submit aggregated keyshare

`proto/fairyring/pep/tx.proto`

```proto
message MsgCreateAggregatedKeyShare {  
  string creator = 1;  
  uint64 height  = 2;  
  string data    = 3;  
}
```

<!-- <p style="text-align: center;"><a href="https://github.com/Fairblock/fairyring/blob/36589b54b24f5e116ae7b3d0fb8cc33ce7388194/proto/fairyring/pep/tx.proto#L27">See full code on GitHub</a></p> -->

The message will fail under the following conditions:

- Active public key does not exist
- Aggregated keyshare is invalid
- Sender is not trusted

## Events

The pep module emits the following events:

### Message Events

#### MsgSubmitEncryptedTx

| Type | Attribute Key | Attribute Value |
|---|---|---|
| `new-encrypted-tx-submitted` | `creator` | `creatorAddress` |
| `new-encrypted-tx-submitted` | `ntarget-height` | `height` |
| `new-encrypted-tx-submitted` | `index` | `txIndex` |
| `new-encrypted-tx-submitted` | `data` | `txData` |

#### MsgCreateAggregatedKeyShare

The following events will be emitted when the aggregated keyshare is invalid:

| Type | Attribute Key | Attribute Value |
| --- | --- | --- |
| `keyshare-verification` | `creator` | `creatorAddress` |
| `keyshare-verification` | `height` | `height` |
| `keyshare-verification` | `reason` | `failReason` |

### Block Events

The following events will be emitted when processing an encrypted transaction in `BeginBlock`:

When the transaction is reverted:

| Type | Attribute Key | Attribute Value |
|---|---|---|
| `reverted-encrypted-tx` | `creator` | `creatorAddress` |
| `reverted-encrypted-tx` | `target-height` | `processedHeight` |
| `reverted-encrypted-tx` | `index` | `txIndex` |
| `reverted-encrypted-tx` | `reason` | `failReason` |

When the transaction is executed successfully:

| Type | Attribute Key | Attribute Value |
|---|---|---|
| `executed-encrypted-tx` | `creator` | `maskedAddress` |
| `executed-encrypted-tx` | `target-height` | `confirmedHeight` |
| `executed-encrypted-tx` | `index` | `transactionIndex` |
| `executed-encrypted-tx` | `data` | `redactedData` |
| `executed-encrypted-tx` | `memo` | `underlyingTxMemo` |
| `executed-encrypted-tx` | `events` | `underlyingTxEvents` |

## Client

### CLI

User can query and interact with the `pep` module using the CLI.

#### Queries

The `query` commands allows users to query `pep` state.

`fairyringd query pep --help`

##### latest-height

The `latest-height` command allows users to get the latest processed height of `x/pep` module.

`fairyringd query pep latest-height [flags]`

Example:

`fairyringd query pep latest-height`

Example Output:

```json
height: "34"
```

##### list-encrypted-tx

The `list-encrypted-tx` command allows users to get all encrypted transactions waiting to be processed.

`fairyringd query pep list-encrypted-tx [flags]`

Example:

`fairyringd query pep list-encrypted-tx`

Example Output:

```json
encryptedTxArray:
- encryptedTx:
  - chargedGas:
      amount: "300000"
      denom: ufairy
    creator: fairy1qnk2n4nlkpw9xfqntladh74w6ujtulwnsgww3g
    data: 6167652d656e...2e19e18c8
    index: "0"
    targetHeight: "10000"
pagination:
  next_key: null
  total: "0"
```

##### list-encrypted-tx-from-block

The `list-encrypted-tx-from-block` command allows users to get all encrypted transactions of a particular target block height.

`fairyringd query pep list-encrypted-tx-from-block [height] [flags]`

Example:

`fairyringd query pep list-encrypted-tx-from-block 10000`

Example Output:

```json
encryptedTxArray:
  encryptedTx:
  - chargedGas:
      amount: "300000"
      denom: ufairy
    creator: fairy1qnk2n4nlkpw9xfqntladh74w6ujtulwnsgww3g
    data: 6167652d...9e18c8
    index: "0"
    targetHeight: "10000"
```

##### list-pep-nonce

The `list-pep-nonce` command allows users to get the pep nonce of all addresses.

`fairyringd query pep list-pep-nonce [flags]`

Example:

`fairyringd query pep list-pep-nonce`

Example Output:

```json
pagination:
  next_key: null
  total: "0"
pepNonce:
- address: fairy1qnk2n4nlkpw9xfqntladh74w6ujtulwnsgww3g
  nonce: "3"
```

##### params

The `params` command allows users to get the params of `x/pep` module.

`fairyringd query pep params [flags]`

Example:

`fairyringd query pep params`

Example Output:

```json
params:
  channel_id: channel-0
  minGasPrice:
    amount: "300000"
    denom: ufairy
  trusted_addresses:
  - fairy18hl5c9xn5dze2g50uaw0l2mr02ew57zkynp0td
  - fairy1qnk2n4nlkpw9xfqntladh74w6ujtulwnsgww3g
  trusted_counter_parties:
  - channel_id: channel-0
    client_id: 07-tendermint-0
    connection_id: connection-0
```

##### show-active-pub-key

The `show-active-pub-key` command allows users to get the active & queued public key.

`fairyringd query pep show-active-pub-key [flags]`

Example:

`fairyringd query pep show-active-pub-key`

Example Output:

```json
activePubKey:
  creator: fairy18hl5c9xn5dze2g50uaw0l2mr02ew57zkynp0td
  expiry: "10025"
  publicKey: afbcd567c669f8bab34223102b94796542cdc1878b039bd533698cbe6d03df727eb01604003fbd990a60403aaa2ec7e5
queuedPubKey:
  creator: ""
  expiry: "0"
  publicKey: ""
```

##### show-encrypted-tx

The `show-encrypted-tx` command allows users to get the target encrypted transaction with its target block height and transaction index.

`fairyringd query pep show-encrypted-tx [target-height] [index] [flags]`

Example:

`fairyringd query pep show-encrypted-tx 10000 0`

Example Output:

```json
encryptedTx:
  chargedGas:
    amount: "300000"
    denom: ufairy
  creator: fairy1qnk2n4nlkpw9xfqntladh74w6ujtulwnsgww3g
  data: 616765...9e18c8
  index: "0"
  targetHeight: "10000"
```

##### show-pep-nonce

The `show-pep-nonce` command allows users to get the pep nonce of the target address.

`fairyringd query pep show-pep-nonce [address] [flags]`

Example:

`fairyringd query pep show-pep-nonce fairy1qnk2n4nlkpw9xfqntladh74w6ujtulwnsgww3g`

Example Output:

```json
pepNonce:
  address: fairy1qnk2n4nlkpw9xfqntladh74w6ujtulwnsgww3g
  nonce: "3"
```

#### Transactions

The `tx` commands allows users to interact with the `pep` module.

`fairyringd tx pep --help`

##### create-aggregated-key-share

The `create-aggregated-key-share` command allows trusted addresses to submit aggregated keyshares to `x/pep` module.

`fairyringd tx pep create-aggregated-key-share [height] [data] [flags]`

Example:

`fairyringd tx pep create-aggregated-key-share 10000 b7b0ec8be348c564d2bda911e5f69a8aef57d37cded06c601c6562e8bf6e43bdf36fd7e16aba8eea45127b381faeb81703199edf5a0b3bd05f8046778bd6ff6b16ed2c9050e50124bf1005ab03d272754a13d580fc613f7992c2a01b21db9054`

##### submit-encrypted-tx

The `submit-encrypted-tx` command allows users to submit encrypted transactions to `x/pep` module.
To encrypt a transaction for `x/pep` module, please read [this guide](encrypt_tx.md).

`fairyringd tx pep submit-encrypted-tx [data] [target-block-height] [flags]`

`[data]` is the encrypted transaction encoded in hex.

Example:

`fairyringd tx pep submit-encrypted-tx 6167652d...302bc45 10000`

## gRPC

Users can query the `pep` module using gRPC endpoints.

### EncryptedTx

The `EncryptedTx` endpoint allows users to query encrypted transaction with a particular target height and transaction index.

`fairyring.pep.Query/EncryptedTx`

Example:

```bash
grpcurl -plaintext \
 -d '{"targetHeight": 10000, "index": 0}' \
 localhost:9090 \
 fairyring.pep.Query/EncryptedTx
```

Example Output:

```json
{
  "encryptedTx": {
    "targetHeight": "10000",
    "data": "6167652...e18c8",
    "creator": "fairy1qnk2n4nlkpw9xfqntladh74w6ujtulwnsgww3g",
    "chargedGas": {
      "denom": "ufairy",
      "amount": "300000"
    }
  }
}
```

### EncryptedTxAll

The `EncryptedTxAll` endpoint allows users to query all encrypted transactions.

`fairyring.pep.Query/EncryptedTxAll`

Example:

`grpcurl -plaintext localhost:9090 fairyring.pep.Query/EncryptedTxAll`

Example Output:

```json
{
  "encryptedTxArray": [
    {
      "encryptedTx": [
        {
          "targetHeight": "10000",
          "data": "6167652...9e18c8",
          "creator": "fairy1qnk2n4nlkpw9xfqntladh74w6ujtulwnsgww3g",
          "chargedGas": {
            "denom": "ufairy",
            "amount": "300000"
          }
        }
      ]
    }
  ],
  "pagination": {
    "total": "1"
  }
}
```

### EncryptedTxAllFromHeight

The `EncryptedTxAllFromHeight` endpoint allows users to query all encrypted transactions for a particular target block height.

`fairyring.pep.Query/EncryptedTxAllFromHeight`

Example:

```bash
grpcurl -plaintext \
 -d '{"targetHeight": 10000}' \
 localhost:9090 \
 fairyring.pep.Query/EncryptedTxAllFromHeight
```

Example Output:

```json
{
  "encryptedTxArray": {
    "encryptedTx": [
      {
        "targetHeight": "10000",
        "data": "6167652...9f3c2e19e18c8",
        "creator": "fairy1qnk2n4nlkpw9xfqntladh74w6ujtulwnsgww3g",
        "chargedGas": {
          "denom": "ufairy",
          "amount": "300000"
        }
      }
    ]
  }
}
```

### LatestHeight

The `LatestHeight` endpoints allows users to query the latest processed height.

`fairyring.pep.Query/LatestHeight`

Example:

`grpcurl -plaintext localhost:9090 fairyring.pep.Query/LatestHeight`

Example Output:

```json
{
  "height": "34"
}
```

### PepNonce

The `PepNonce` endpoints allows users to query the pep nonce of a particular address.

`fairyring.pep.Query/PepNonce`

Example:

```bash
grpcurl -plaintext \
 -d '{"address": "fairy1qnk2n4nlkpw9xfqntladh74w6ujtulwnsgww3g"}' \
 localhost:9090 \
 fairyring.pep.Query/PepNonce
```

Example Output:

```json
{
  "pepNonce": {
    "address": "fairy1qnk2n4nlkpw9xfqntladh74w6ujtulwnsgww3g",
    "nonce": "3"
  }
}
```

### PepNonceAll

The `PepNonceAll` endpoints allows users to query all pep nonces.

`fairyring.pep.Query/PepNonceAll`

Example:

`grpcurl -plaintext localhost:9090 fairyring.pep.Query/PepNonceAll`

Example Output:

```json
{
  "pepNonce": [
    {
      "address": "fairy1qnk2n4nlkpw9xfqntladh74w6ujtulwnsgww3g",
      "nonce": "3"
    }
  ],
  "pagination": {
    "total": "1"
  }
}
```

### PubKey

The `PubKey` endpoints allows users to query active & queued public keys.

`fairyring.pep.Query/PubKey`

Example:

`grpcurl -plaintext localhost:9090 fairyring.pep.Query/PubKey`

Example Output:

```json
{
  "activePubKey": {
    "publicKey": "afbcd567c669f8bab34223102b94796542cdc1878b039bd533698cbe6d03df727eb01604003fbd990a60403aaa2ec7e5",
    "creator": "fairy18hl5c9xn5dze2g50uaw0l2mr02ew57zkynp0td",
    "expiry": "10025"
  },
  "queuedPubKey": {

  }
}
```

### Params

The `Params` endpoints allows users to query `x/pep` module params.

`fairyring.pep.Query/Params`

Example:

`grpcurl -plaintext localhost:9090 fairyring.pep.Query/Params`

Example Output:

```json
{
  "params": {
    "trustedCounterParties": [
      {
        "clientId": "07-tendermint-0",
        "connectionId": "connection-0",
        "channelId": "channel-0"
      }
    ],
    "trustedAddresses": [
      "fairy18hl5c9xn5dze2g50uaw0l2mr02ew57zkynp0td",
      "fairy1qnk2n4nlkpw9xfqntladh74w6ujtulwnsgww3g"
    ],
    "channelId": "channel-0",
    "minGasPrice": {
      "denom": "ufairy",
      "amount": "300000"
    }
  }
}
```
