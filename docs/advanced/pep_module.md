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
3. General encrypted transactions
4. Pep nonce
5. Active & queued public keys
6. Latest processed height
7. General decryption key requests
8. Private decryption key requests
9. Wasm contract addresses for callback

## Params

`proto/fairyring/pep/params.proto`

```proto
message Params {
  option (amino.name) = "fairyring/x/pep/Params";
  // option (gogoproto.equal) = true;
  string keyshare_channel_id = 1 [(gogoproto.moretags) = "yaml:\"keyshare_channel_id\""];
  bool is_source_chain = 2 [(gogoproto.moretags) = "yaml:\"is_source_chain\""];
  repeated TrustedCounterParty trusted_counter_parties = 3;
  repeated string trusted_addresses = 4 [(gogoproto.moretags) = "yaml:\"trusted_addresses\""];
  cosmos.base.v1beta1.Coin min_gas_price = 5 [(gogoproto.moretags) = "yaml:\"min_gas_price\""];
  cosmos.base.v1beta1.Coin private_decryption_key_price = 6 [(gogoproto.moretags) = "yaml:\"private_decryption_key_price\""];
}
  
message TrustedCounterParty {  
  string client_id = 1;  
  string connection_id = 2;  
  string channel_id = 3;  
}
```

<!-- <p style="text-align: center;"><a href="https://github.com/Fairblock/fairyring/blob/v0.10.2/proto/fairyring/pep/params.proto">See full code on GitHub</a></p> -->

## Messages

### MsgSubmitEncryptedTx

Submit encrypted transaction

`proto/fairyring/pep/tx.proto`

```proto
message MsgSubmitEncryptedTx {
  option (cosmos.msg.v1.signer) = "creator";
  string creator = 1;
  string data = 2;
  uint64 target_block_height = 3;
}
```

The message will fail under the following conditions:

- Target block height is lower than or equal to the latest height
- Target block height is higher than public key expiry height
- Sender does not have enough tokens for fee
- Active public key not found

### MsgSubmitGeneralEncryptedTx

Submit general encrypted transaction

`proto/fairyring/pep/tx.proto`

```proto
message MsgSubmitGeneralEncryptedTx {
  option (cosmos.msg.v1.signer) = "creator";
  string creator = 1;
  string data = 2;
  string req_id = 3;
}
```

The message will fail under the following conditions:

- Entry for the given request id not found
- Sender does not have enough tokens for fee

### MsgSubmitDecryptionKey

Submit decryption key

`proto/fairyring/pep/tx.proto`

```proto
message MsgSubmitDecryptionKey {
  option (cosmos.msg.v1.signer) = "creator";
  string creator = 1;
  uint64 height = 2;
  string data = 3;
}
```

The message will fail under the following conditions:

- Active public key does not exist
- Aggregated keyshare is invalid
- Sender is not trusted

### MsgRequestGeneralIdentity

Request a general identity

`proto/fairyring/pep/tx.proto`

```proto
message MsgRequestGeneralIdentity {
  option (cosmos.msg.v1.signer) = "creator";
  string creator = 1;
  google.protobuf.Duration estimated_delay = 2 [(gogoproto.stdduration) = true];
  string req_id = 3;
}
```

The message will fail under the following conditions:

- Request ID from the sender already exists
- Estimated delay is empty

### MsgRequestGeneralDecryptionKey

Request general decryption key

`proto/fairyring/pep/tx.proto`

```proto
message MsgRequestGeneralDecryptionKey {
  option (cosmos.msg.v1.signer) = "creator";
  string creator = 1;
  string identity = 2;
}
```

The message will fail under the following conditions:

- Entry for the given identity not found
- Sender is not the creator of the given identity

### MsgRequestPrivateIdentity

Request a private identity

`proto/fairyring/pep/tx.proto`

```proto
message MsgRequestPrivateIdentity {
  option (cosmos.msg.v1.signer) = "creator";
  string creator = 1;
  string req_id = 2;
}
```

The message will fail under the following conditions:

- Request ID from the sender already exists

### MsgRequestPrivateDecryptionKey

Request private decryption key

`proto/fairyring/pep/tx.proto`

```proto
message MsgRequestPrivateDecryptionKey {
  option (cosmos.msg.v1.signer) = "creator";
  string creator = 1;
  string identity = 2;
  string secp_pubkey = 3;
}
```

The message will fail under the following conditions:

- Given identity & active public key not found
- Sender does not have enough tokens for fee

### MsgRegisterContract

Register a WASM contract for callback

`proto/fairyring/pep/tx.proto`

```proto
message MsgRegisterContract {
  option (cosmos.msg.v1.signer) = "creator";
  string creator = 1;
  string contract_address = 2;
  string identity = 3;
}
```

The message will fail under the following conditions:

- Contract address is invalid
- Contract info not found for the given address
- Sender is not the admin / creator of the given contract
- Contract already registered for the given identity

### MsgUnregisterContract

Unregister a WASM contract

`proto/fairyring/pep/tx.proto`

```proto
message MsgUnregisterContract {
  option (cosmos.msg.v1.signer) = "creator";
  string creator = 1;
  string contract_address = 2;
  string identity = 3;
}
```

The message will fail under the following conditions:

- Contract address is invalid
- Contract info not found for the given address
- Sender is not the admin / creator of the given contract
- Entry for the given identity not found
- The given contract is not in the registered contracts

## Events

The pep module emits the following events:

### Message Events

#### MsgSubmitEncryptedTx

| Type | Attribute Key | Attribute Value |
|---|---|---|
| `new-encrypted-tx-submitted` | `creator` | `creatorAddress` |
| `new-encrypted-tx-submitted` | `target-height` | `height` |
| `new-encrypted-tx-submitted` | `index` | `txIndex` |
| `new-encrypted-tx-submitted` | `data` | `txData` |

#### MsgSubmitGeneralEncryptedTx

| Type | Attribute Key | Attribute Value |
|---|---|---|
| `new-general-encrypted-tx-submitted` | `creator` | `creatorAddress` |
| `new-general-encrypted-tx-submitted` | `identity` | `identity` |
| `new-general-encrypted-tx-submitted` | `index` | `txIndex` |
| `new-general-encrypted-tx-submitted` | `data` | `txData` |

#### MsgCreateAggregatedKeyshare

The following events will be emitted when the aggregated keyshare is invalid:

| Type | Attribute Key | Attribute Value |
| --- | --- | --- |
| `decryption-key-verification` | `creator` | `creatorAddress` |
| `decryption-key-verification` | `height` | `height` |
| `decryption-key-verification` | `reason` | `failReason` |

### Block Events

The following events will be emitted when processing an encrypted transaction in `BeginBlock`:

When the encrypted transaction is reverted:

| Type | Attribute Key | Attribute Value |
|---|---|---|
| `reverted-encrypted-tx` | `creator` | `creatorAddress` |
| `reverted-encrypted-tx` | `height` | `height` |
| `reverted-encrypted-tx` | `index` | `txIndex` |
| `reverted-encrypted-tx` | `reason` | `revertReason` |

When the general encrypted transaction is reverted:

| Type | Attribute Key | Attribute Value |
|---|---|---|
| `reverted-encrypted-tx` | `creator` | `creatorAddress` |
| `reverted-encrypted-tx` | `index` | `txIndex` |
| `reverted-encrypted-tx` | `identity` | `identity` |
| `reverted-encrypted-tx` | `reason` | `revertReason` |

When the encrypted transaction is executed successfully:

| Type | Attribute Key | Attribute Value |
|---|---|---|
| `executed-encrypted-tx` | `creator` | `creatorAddress` |
| `executed-encrypted-tx` | `index` | `txIndex` |
| `executed-encrypted-tx` | `data` | `txData` |
| `executed-encrypted-tx` | `memo` | `txMemo` |
| `executed-encrypted-tx` | `events` | `underlyingEvents` |

When an encrypted tx is discarded:

| Type | Attribute Key | Attribute Value |
|---|---|---|
| `discarded-encrypted-tx` | `height` | `height` |
| `discarded-encrypted-tx` | `index` | `txIndex` |

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
encrypted_tx_array:
- encrypted_txs:
  - charged_gas:
      amount: "300000"
      denom: ufairy
    creator: fairy1qnk2n4nlkpw9xfqntladh74w6ujtulwnsgww3g
    data: 6167652d656e...2e19e18c8
    index: "0"
    target_height: "10000"
    expired: false
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
encrypted_tx_array:
  encrypted_txs:
  - charged_gas:
      amount: "300000"
      denom: ufairy
    creator: fairy1qnk2n4nlkpw9xfqntladh74w6ujtulwnsgww3g
    data: 6167652d...9e18c8
    index: "0"
    target_height: "10000"
    expired: false
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
pep_nonce:
- address: fairy1qnk2n4nlkpw9xfqntladh74w6ujtulwnsgww3g
  nonce: "3"
```

##### list-general-identities

The `list-general-identities` command gets all the identity execution entries.

`fairyringd query pep list-general-identities [flags]`

Example:

`fairyringd query pep list-general-identities`

Example Output:

```json
pagination:
  total: "1"
request_details_list:
- creator: fairy1m9l358xunhhwds0568za49mzhvuxx9uxdra8sq
  identity: fairy1m9l358xunhhwds0568za49mzhvuxx9uxdra8sq/testing123
  pubkey: b64c4e...8de
  tx_list:
    encrypted_txs:
    - charged_gas:
        amount: "300000"
        denom: ufairy
      creator: fairy1m9l358xunhhwds0568za49mzhvuxx9uxdra8sq
      data: 616...9eb3
      identity: fairy1m9l358xunhhwds0568za49mzhvuxx9uxdra8sq/testing123
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
  min_gas_price:
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
active_pubkey:
  creator: fairy18hl5c9xn5dze2g50uaw0l2mr02ew57zkynp0td
  expiry: "10025"
  public_key: afbcd567c669f8bab34223102b94796542cdc1878b039bd533698cbe6d03df727eb01604003fbd990a60403aaa2ec7e5
queued_pubkey:
  creator: ""
  expiry: "0"
  public_key: ""
```

##### show-encrypted-tx

The `show-encrypted-tx` command allows users to get the target encrypted transaction with its target block height and transaction index.

`fairyringd query pep show-encrypted-tx [target-height] [index] [flags]`

Example:

`fairyringd query pep show-encrypted-tx 10000 0`

Example Output:

```json
encrypted_tx:
  charged_gas:
    amount: "300000"
    denom: ufairy
  creator: fairy1qnk2n4nlkpw9xfqntladh74w6ujtulwnsgww3g
  data: 616765...9e18c8
  index: "0"
  target_height: "10000"
  expired: false
```

##### show-pep-nonce

The `show-pep-nonce` command allows users to get the pep nonce of the target address.

`fairyringd query pep show-pep-nonce [address] [flags]`

Example:

`fairyringd query pep show-pep-nonce fairy1qnk2n4nlkpw9xfqntladh74w6ujtulwnsgww3g`

Example Output:

```json
pep_nonce:
  address: fairy1qnk2n4nlkpw9xfqntladh74w6ujtulwnsgww3g
  nonce: "3"
```

##### show-general-identity

The `show-general-identity` command allow user to get informations of the given identity.

`fairyringd query pep show-general-identity [identity] [flags]`

Example:

`fairyringd query pep show-general-identity fairy1m9l358xunhhwds0568za49mzhvuxx9uxdra8sq/testing123`

Example Output:

```json
request_details:
  creator: fairy1m9l358xunhhwds0568za49mzhvuxx9uxdra8sq
  decryption_key: a2f...407
  identity: fairy1m9l358xunhhwds0568za49mzhvuxx9uxdra8sq/testing123
  pubkey: b64c4e...bb8de
  tx_list:
    encrypted_txs:
    - charged_gas:
        amount: "300000"
        denom: ufairy
      creator: fairy1m9l358xunhhwds0568za49mzhvuxx9uxdra8sq
      data: 6167652d...e19eb3
      identity: fairy1m9l358xunhhwds0568za49mzhvuxx9uxdra8sq/testing123
```

##### show-private-identity

The `show-private-identity` command allow user to get informations of the given identity.

`fairyringd query pep show-private-identity [identity] [flags]`

Example: 

`fairyringd query pep show-private-identity fairy1m9l358xunhhwds0568za49mzhvuxx9uxdra8sq/test_req_1`

Example Output: 

```json
creator: fairy1m9l358xunhhwds0568za49mzhvuxx9uxdra8sq
identity: fairy1m9l358xunhhwds0568za49mzhvuxx9uxdra8sq/test_req_1
private_decryption_keys:
- private_keyshares:
  - encrypted_keyshare_index: "1"
    encrypted_keyshare_value: 1917...8sq
pubkey: b64c...8de
```

##### decrypt-data

The `decrypt-data` command allow user to decrypt a cipher with given decryption key and encryption key (pubkey).

`fairyringd query pep decrypt-data [pubkey] [decryption-key] [cipher] [flags]`

Example:

`fairyringd query pep decrypt-data b64c4..b8de a2f...307 6167652d....c0ba2b8ed58`

Example Output:

```json
decrypted_data: "test_data_1"
```

#### Transactions

The `tx` commands allows users to interact with the `pep` module.

`fairyringd tx pep --help`

##### submit-decryption-key

The `submit-decryption-key` command allows trusted addresses to submit decryption key to `x/pep` module.

`fairyringd tx pep submit-decryption-key [height] [data] [flags]`

Example:

`fairyringd tx pep submit-decryption-key 10000 b7b0ec8be348c564d2bda911e5f69a8aef57d37cded06c601c6562e8bf6e43bdf36fd7e16aba8eea45127b381faeb81703199edf5a0b3bd05f8046778bd6ff6b16ed2c9050e50124bf1005ab03d272754a13d580fc613f7992c2a01b21db9054`

##### submit-encrypted-tx

The `submit-encrypted-tx` command allows users to submit encrypted transactions to `x/pep` module.
To encrypt a transaction for `x/pep` module, please read [this guide](encrypt_tx.md).

`fairyringd tx pep submit-encrypted-tx [data] [target-block-height] [flags]`

`[data]` is the encrypted transaction encoded in hex.

Example:

`fairyringd tx pep submit-encrypted-tx 6167652d...302bc45 10000`

##### submit-general-encrypted-tx

The `submit-general-encrypted-tx` command allows users to submit general encrypted transactions to `x/pep` module.
To encrypt a transaction for `x/pep` module, please read [this guide](encrypt_tx.md).

`fairyringd tx pep submit-general-encrypted-tx [data] [req-id] [flags]`

`[data]` is the encrypted transaction encoded in hex.

`[req-id]` is the request id / identity you used when encrypting the transaction.

Example:

`fairyringd tx pep submit-general-encrypted-tx 6167652d...302bc45 fairy1m9l358xunhhwds0568za49mzhvuxx9uxdra8sq/testing123`

##### request-general-identity

The `request-general-identity` command allow users to request a custom identity for encryption.

`fairyringd tx pep request-general-identity [estimated-delay] [req-id] [flags]`

`[estimated-delay]` is the estimated delay on when the general identity will be used.

`[req-id]` is your custom request identity.

Example:

`fairyringd tx pep request-general-identity 30s testing123`

##### request-general-decryption-key

The `request-general-decryption-key` command allow the creator to get the decryption key for the requested identity.

`fairyringd tx pep request-general-decryption-key [req-id] [flags]`

`[req-id]` is the identity you requested. 

Keep in mind the `req-id` used here is different from the one you requested, for example if you requested `testing123`, 
then the `req-id` here will be `{YOUR_ADDRESS}/testing123`

Example:

`fairyringd tx pep request-general-decryption-key fairy1m9l358xunhhwds0568za49mzhvuxx9uxdra8sq/testing123`

##### request-private-identity

The `request-private-identity` command allow users to request a custom private identity for encryption.

`fairyringd tx pep request-private-identity [req-id] [flags]`

`[req-id]` is your custom request identity.

Example:

`fairyringd tx pep request-private-identity testing1234`

##### request-private-decryption-key

The `request-private-decryption-key` command allow the creator to get the decryption key for the requested private identity.

`fairyringd tx pep request-private-decryption-key [req-id] [secp-pubkey] [flags]`

`[req-id]` is the identity you requested. 

`[secp-pubkey]` is the pubkey validators should be using to encrypt your decryption key.

Keep in mind the `req-id` used here is different from the one you requested, for example if you requested `testing1234`, 
then the `req-id` here will be `{YOUR_ADDRESS}/testing1234`

Example:

`fairyringd tx pep request-private-decryption-key fairy1m9l358xunhhwds0568za49mzhvuxx9uxdra8sq/testing1234 A/MdHV+pi...IfXp9`

##### register-contract

The `register-contract` command allow users to register a WASM contract in `x/pep` module for contract callback function.

`fairyringd tx pep register-contract [contract-address] [identity] [flags]`

`[contract-address]` is the WASM contract address.

`[identity]` is the general identity you requested.

Example:

`fairyringd tx pep register-contract fairy1m9l358xunhhwds0568za49mzhvuxx9uxdra8sq fairy1m9l358xunhhwds0568za49mzhvuxx9uxdra8sq/contract`

##### unregister-contract

The `unregister-contract` command allow users to remove a registered WASM contract in `x/pep` module.

`fairyringd tx pep unregister-contract [contract-address] [identity] [flags]`

`[contract-address]` is the WASM contract address you registered earlier.

`[identity]` is the same general identity you used when registering the contract.

Example:

`fairyringd tx pep unregister-contract fairy1m9l358xunhhwds0568za49mzhvuxx9uxdra8sq fairy1m9l358xunhhwds0568za49mzhvuxx9uxdra8sq/contract`

## gRPC

Users can query the `pep` module using gRPC endpoints.

### EncryptedTx

The `EncryptedTx` endpoint allows users to query encrypted transaction with a particular target height and transaction index.

`fairyring.pep.Query/EncryptedTx`

Example:

```bash
grpcurl -plaintext \
 -d '{"target_height": 10000, "index": 0}' \
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
      "encryptedTxs": [
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
 -d '{"target_height": 10000}' \
 localhost:9090 \
 fairyring.pep.Query/EncryptedTxAllFromHeight
```

Example Output:

```json
{
  "encryptedTxArray": {
    "encryptedTxs": [
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

### Pubkey

The `Pubkey` endpoints allows users to query active & queued public keys.

`fairyring.pep.Query/Pubkey`

Example:

`grpcurl -plaintext localhost:9090 fairyring.pep.Query/Pubkey`

Example Output:

```json
{
  "activePubkey": {
    "publicKey": "afbcd567c669f8bab34223102b94796542cdc1878b039bd533698cbe6d03df727eb01604003fbd990a60403aaa2ec7e5",
    "creator": "fairy18hl5c9xn5dze2g50uaw0l2mr02ew57zkynp0td",
    "expiry": "10025"
  },
  "queuedPubkey": {

  }
}
```

### GeneralIdentity

The `GeneralIdentity` endpoints allow users to query information of specific general identity.

`fairyring.pep.Query/GeneralIdentity`

Example:

```bash
grpcurl -plaintext \
 -d '{"identity": "fairy1m9l358xunhhwds0568za49mzhvuxx9uxdra8sq/testing123"}' \
 localhost:9090 \
 fairyring.pep.Query/GeneralIdentity
```

Example Output:

```json
{
  "requestDetails": {
    "creator": "fairy1m9l358xunhhwds0568za49mzhvuxx9uxdra8sq",
    "identity": "fairy1m9l358xunhhwds0568za49mzhvuxx9uxdra8sq/testing123",
    "pubkey": "a6e4502...313104",
    "txList": {
      "encryptedTxs": [
        {
          "identity": "fairy1m9l358xunhhwds0568za49mzhvuxx9uxdra8sq/testing123",
          "data": "61676...a5bfca",
          "creator": "fairy1m9l358xunhhwds0568za49mzhvuxx9uxdra8sq",
          "chargedGas": {
            "denom": "ufairy",
            "amount": "300000"
          }
        }
      ]
    },
    "decryptionKey": "924...c8f7"
  }
}
```

### GeneralIdentityAll

The `GeneralIdentityAll` endpoints allow users to query all information of all general identities.

`fairyring.pep.Query/GeneralIdentityAll`

Example:

```bash
grpcurl -plaintext localhost:9090 fairyring.pep.Query/GeneralIdentityAll
```

Example Output:

```json
{
  "requestDetailsList": [
    {
      "creator": "fairy1m9l358xunhhwds0568za49mzhvuxx9uxdra8sq",
      "identity": "fairy1m9l358xunhhwds0568za49mzhvuxx9uxdra8sq/testing123",
      "pubkey": "a6e4502...3d2313104",
      "txList": {
        "encryptedTxs": [
          {
            "identity": "fairy1m9l358xunhhwds0568za49mzhvuxx9uxdra8sq/testing123",
            "data": "616...5bfca",
            "creator": "fairy1m9l358xunhhwds0568za49mzhvuxx9uxdra8sq",
            "chargedGas": {
              "denom": "ufairy",
              "amount": "300000"
            }
          },
          {
            "identity": "fairy1m9l358xunhhwds0568za49mzhvuxx9uxdra8sq/testing123",
            "index": "1",
            "data": "6167652d...6dc4",
            "creator": "fairy1m9l358xunhhwds0568za49mzhvuxx9uxdra8sq",
            "chargedGas": {
              "denom": "ufairy",
              "amount": "300000"
            }
          }
        ]
      },
      "decryptionKey": "9247...c8f7"
    }
  ],
  "pagination": {
    "total": "1"
  }
}
```

### PrivateIdentity

The `PrivateIdentity` endpoints allow users to query information of specific private identity.

`fairyring.pep.Query/PrivateIdentity`

Example:

```bash
grpcurl -plaintext \
 -d '{"identity": "fairy1m9l358xunhhwds0568za49mzhvuxx9uxdra8sq/test_req_1"}' \
 localhost:9090 \
 fairyring.pep.Query/PrivateIdentity
```

Example Output:

```json
{
  "creator": "fairy1m9l358xunhhwds0568za49mzhvuxx9uxdra8sq",
  "identity": "fairy1m9l358xunhhwds0568za49mzhvuxx9uxdra8sq/test_req_1",
  "pubkey": "a6e45020b...13104",
  "privateDecryptionKeys": [
    {
      "requester": "fairy1m9l358xunhhwds0568za49mzhvuxx9uxdra8sq",
      "privateKeyshares": [
        {
          "encryptedKeyshareValue": "607a...f8f",
          "encryptedKeyshareIndex": "1"
        }
      ]
    }
  ]
}
```

### DecryptData

The `DecryptData` endpoints allow users to decrypt given cipher with given decryption key and encryption id.

`fairyring.pep.Query/DecryptData`

Example:

```bash
grpcurl -plaintext -d @ localhost:9090 fairyring.pep.Query/DecryptData <<EOM
{
  "pubkey": "a6e4502...313104",
  "decryption_key": "92479f...15c8f7",
  "encrypted_data": "61676...5d3b"
}
EOM
```

Example Output:

```json
{
  "decryptedData": "test_data_1"
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
    "keyshareChannelId": "channel-1",
    "isSourceChain": true,
    "trustedAddresses": [
      "fairy18hl5c9xn5dze2g50uaw0l2mr02ew57zkynp0td",
      "fairy1qnk2n4nlkpw9xfqntladh74w6ujtulwnsgww3g"
    ],
    "minGasPrice": {
      "denom": "ufairy",
      "amount": "300000"
    },
    "privateDecryptionKeyPrice": {
      "denom": "ufairy",
      "amount": "300000"
    }
  }
}
```
