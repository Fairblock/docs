---
sidebar_position: 0
---

# `x/keyshare`

## Abstract

This document specifies the `keyshare` module of `fairyring`.

The `keyshare` module is responsible for collecting all the keyshares from validators and aggregating it to one derived private key every block.

## State

The `x/keyshare` module keeps state of the following primary objects:

1. Validator information
2. Submitted keyshares
3. Aggregated keyshares
4. Active & queued public key
5. Authorized addresss
6. Submit general keyshares
7. Submit encrypted keyshares
8. Keyshares encrypted with the validator's public key

## Params

`proto/fairyring/keyshare/params.proto`

```proto
message Params {
  option (amino.name) = "github.com/Fairblock/fairyring/x/keyshare/Params";
  option (gogoproto.equal) = true;

  uint64 key_expiry = 1 [(gogoproto.moretags) = "yaml:\"key_expiry\""];
  uint64 minimum_bonded = 2 [(gogoproto.moretags) = "yaml:\"minimum_bonded\""];
  uint64 max_idled_block = 3 [(gogoproto.moretags) = "yaml:\"max_idled_block\""];
  repeated string trusted_addresses = 4 [(gogoproto.moretags) = "yaml:\"trusted_addresses\""];
  bytes slash_fraction_no_keyshare = 5 [(gogoproto.customtype) = "cosmossdk.io/math.LegacyDec", (gogoproto.nullable) = false, (gogoproto.moretags) = "yaml:\"slash_fraction_no_keyshare\""];
  bytes slash_fraction_wrong_keyshare = 6 [(gogoproto.customtype) = "cosmossdk.io/math.LegacyDec", (gogoproto.nullable) = false, (gogoproto.moretags) = "yaml:\"slash_fraction_wrong_keyshare\""];

}
```

## Messages

### MsgRegisterValidator

Register as a validator in the `x/keyshare` module validator set.

`proto/fairyring/keyshare/tx.proto`

```proto
message MsgRegisterValidator { 
  option (cosmos.msg.v1.signer) = "creator"; 
  string creator = 1;  
}
```

The message will fail under the following conditions:

- Creator address staked token is less than minimum requirement
- Creator address already registered as a validator in `x/keyshare` module
  
### MsgDeRegisterValidator

Deregisters a validator from the `x/keyshare` module validator set.

`proto/fairyring/keyshare/tx.proto`

```proto
message MsgDeRegisterValidator {  
  string creator = 1;  
}
```

The message will fail under the following condition:

- Creator address is not a registered validator in the keyshare module

### MsgSendKeyshare

Submit keyshare for target height

`proto/fairyring/keyshare/tx.proto`

```proto
message MsgSendKeyshare {
  option (cosmos.msg.v1.signer) = "creator";
  string creator = 1;
  string message = 2;
  uint64 keyshare_index = 3;
  uint64 block_height = 4;
}
```

The message will fail under the following conditions:

- Sender is not a registered validator in the validator set
- Sender is not an authorized address
- Block height does not equal the current block height
- Keyshare index is incorrect
- Keyshare is incorrect

### MsgCreateLatestPubkey

Create master public key used for encrypting transactions.

`proto/fairyring/keyshare/tx.proto`

```proto
message MsgCreateLatestPubkey {
  option (cosmos.msg.v1.signer) = "creator";
  string creator = 1;
  string public_key = 2;
  repeated string commitments = 3;
  uint64 number_of_validators = 4;
  repeated EncryptedKeyshare encrypted_keyshares = 5;
}
```

The message will fail under the following conditions:

- Sender is not a trusted address
- A queued public key already exists
- Commitments array is empty
- encrypted keyshare array is empty
- numberOfValidators is 0

### MsgOverrideLatestPubkey

Override the latest master public key used for encrypting transactions.

`proto/fairyring/keyshare/tx.proto`

```proto
message MsgOverrideLatestPubkey {
  option (cosmos.msg.v1.signer) = "creator";
  string creator = 1;
  string public_key = 2;
  repeated string commitments = 3;
  uint64 number_of_validators = 4;
  repeated EncryptedKeyshare encrypted_keyshares = 5;
}
```

The message will fail under the following conditions:

- Sender is not a trusted address
- A queued public key already exists
- Commitments array is empty
- encrypted keyshare array is empty
- numberOfValidators is 0

### MsgCreateAuthorizedAddress

Authorize the target address to submit keyshares for the sender address.

`proto/fairyring/keyshare/tx.proto`

```proto
message MsgCreateAuthorizedAddress {
  option (cosmos.msg.v1.signer) = "creator";
  string target = 1;
  string creator = 2;
}
```

The message will fail under the following conditions:

- Target address is invalid
- Creator is not a validator in the `x/keyshare` validator set
- Target address is already authorized
- Target address is the same as sender address
- Creator already authorized another address

### MsgUpdateAuthorizedAddress

Update the status of the target authorized address

`proto/fairyring/keyshare/tx.proto`

```proto
message MsgUpdateAuthorizedAddress {
  option (cosmos.msg.v1.signer) = "creator";
  string target = 1;
  bool is_authorized = 2;
  string creator = 3;
}
```

The message will fail under the following conditions:

- Target is not authorized
- Target is not authorized by the sender
- Target address is the same as sender address

### MsgDeleteAuthorizedAddress

Delete authorized address

`proto/fairyring/keyshare/tx.proto`

```proto
message MsgDeleteAuthorizedAddress {
  option (cosmos.msg.v1.signer) = "creator";
  string target = 1;
  string creator = 2;
}
```

The message will fail under the following conditions:

- Target is not authorized
- Sender is not the creator of the target authorized address and the authorized address itself

### MsgSubmitGeneralKeyshare

Submit general keyshare

`proto/fairyring/keyshare/tx.proto`

```proto
message MsgCreateGeneralKeyshare {  
  option (cosmos.msg.v1.signer) = "creator";
  string creator = 1;
  string id_type = 2;
  string id_value = 3;
  string keyshare = 4;
  uint64 keyshare_index = 5;
}
```

The message will fail under the following conditions:

- Sender is not a validator in the validator set
- Sender is not an authorized address
- Keyshare is incorrect
- ID type is not supported
- Decryption Key Request (ID Value) not found

### MsgSubmitEncryptedKeyshare

Submit encrypted keyshare

`proto/fairyring/keyshare/tx.proto`

```proto
message MsgSubmitEncryptedKeyshare {
  option (cosmos.msg.v1.signer) = "creator";
  string creator = 1;
  string identity = 2;
  string encrypted_keyshare = 3;
  uint64 keyshare_index = 4;
  string requester = 5;
}
```

The message will fail under the following conditions:

- Sender is not a validator in the validator set
- Sender is not an authorized address
- Encrypted keyshare is incorrect
- Private Decryption Key Request (Identity) not found

## Events

The keyshare module emits the following events:

### Message Events

#### MsgRegisterValidator

| Type | Attribute Key | Attribute Value |
| ---- | ------------- | --------------- |
| `new-validator-registered` | `creator` | `creatorAddress` |

#### MsgDeRegisterValidator

| Type | Attribute Key | Attribute Value |
| ---- | ------------- | --------------- |
| `validator-deregistered` | `creator` | `creatorAddress` |

#### MsgSendKeyshare

When a valid keyshare is received:

| Type | Attribute Key | Attribute Value |
|---|---|---|
| `keyshare-sent` | `validator` | `validatorAddress` |
| `keyshare-sent` | `keyshare-height` | `height` |
| `keyshare-sent` | `received-height` | `height` |
| `keyshare-sent` | `message` | `keyshareInHex` |
| `keyshare-sent` | `index` | `keyshareIndex` |

When enough keyshares are received & the derived private key is aggregated:

| Type | Attribute Key | Attribute Value |
|---|---|---|
| `keyshare-aggregated` | `height` | `height` |
| `keyshare-aggregated` | `data` | `aggregatedKeyshareInHex` |
| `keyshare-aggregated` | `pubkey` | `pubkeyForTheAggregatedKey` |

#### MsgCreateGeneralKeyshare

When a valid general keyshare is received:

| Type | Attribute Key | Attribute Value |
|---|---|---|
| `keyshare-sent` | `validator` | `validatorAddress` |
| `keyshare-sent` | `received-height` | `height` |
| `keyshare-sent` | `message` | `keyshareInHex` |
| `keyshare-sent` | `index` | `keyshareIndex` |
| `keyshare-sent` | `id-type` | `keyshareIdType` |
| `keyshare-sent` | `id-value` | `keyshareIdValue` |

When enough keyshares are received & the derived private key is being aggregated:

| Type | Attribute Key | Attribute Value |
|---|---|---|
| `general-keyshare-aggregated` | `data` | `aggregatedKeyshareInHex` |
| `general-keyshare-aggregated` | `pubkey` | `pubkeyForTheAggregatedKey` |
| `general-keyshare-aggregated` | `id-value` | `aggregatedKeyshareIdValue` |
| `general-keyshare-aggregated` | `id-type` | `aggregatedKeyshareIdType` |

#### MsgSubmitEncryptedKeyshare

When a valid encrypted keyshare is received:

| Type | Attribute Key | Attribute Value |
|---|---|---|
| `encrypted-keyshare-sent` | `validator` | `validatorAddress` |
| `encrypted-keyshare-sent` | `received-height` | `height` |
| `encrypted-keyshare-sent` | `message` | `keyshareInHex` |
| `encrypted-keyshare-sent` | `index` | `keyshareIndex` |
| `encrypted-keyshare-sent` | `id-value` | `keyshareIdValue` |

#### MsgCreateLatestPubkey

| Type | Attribute Key | Attribute Value |
|---|---|---|
| `queued-pubkey-created` | `active-pubkey-expiry-height` | `activePubkeyExpiryHeight` |
| `queued-pubkey-created` | `expiry-height` | `height` |
| `queued-pubkey-created` | `creator` | `creatorAddress` |
| `queued-pubkey-created` | `pubkey` | `pubkeyCreated` |
| `queued-pubkey-created` | `number-of-validators` | `numberOfValidators` |
| `queued-pubkey-created` | `encrypted-shares` | `encryptedKeysharesArray` |

#### MsgOverrideLatestPubkey

| Type | Attribute Key | Attribute Value |
|---|---|---|
| `pubkey-overrode` | `active-pubkey-expiry-height` | `activePubkeyExpiryHeight` |
| `pubkey-overrode` | `expiry-height` | `height` |
| `pubkey-overrode` | `creator` | `creatorAddress` |
| `pubkey-overrode` | `pubkey` | `pubkeyCreated` |
| `pubkey-overrode` | `number-of-validators` | `numberOfValidators` |
| `pubkey-overrode` | `encrypted-shares` | `encryptedKeysharesArray` |

## Client

### CLI

User can query and interact with the `keyshare` module using the CLI.

#### Queries

The `query` commands allows users to query `keyshare` state.

`fairyringd query keyshare --help`

##### list-decryption-keys

The `list-decryption-keys` command allows users to query all the decryption keys.

`fairyringd query keyshare list-decryption-keys [flags]`

Example:

`fairyringd query keyshare list-decryption-keys`

Example Output:

```json
decryption_keys:
- data: a32dd1859edf01bdae54e3e4f4a0ea95e3d461ed006ea384b223cef0e3e5d87fc560954f43aba363da21aabfbc0c57340f02604965a96bd83fc9fb28b23f1586b29def1e75b3a9df06353921f33ad80cf9903899a7a9843be8be559956b06391
  height: "12345"
pagination:
  next_key: AAAAAAAAO+Ev
  total: "0"
```

##### list-authorized-address

The `list-authorized-address` command allows users to query all the authorized addresses.

`fairyringd query keyshare list-authorized-address [flags]`

Example:

`fairyringd query keyshare list-authorized-address`

Example Output:

```json
- authorized_by: fairy1zrpp8efav7kancgse2peh3k98u9ueajwvq5w5q
  is_authorized: true
  target: fairy1f6mx8wgfb9xdxeswwavh9228uv6d7yga3qqtyv
pagination:
  next_key: null
  total: "0"
```

##### list-keyshares

The `list-key-share` command allows users to query all the keyshare submitted by validators.

`fairyringd query keyshare list-keyshares [flags]`

Example:

`fairyringd query keyshare list-keyshares`

Example Output:

```json
keyshare:
- block_height: "95219"
  keyshare: 91d7674f9feff2275971dda90bc25d2f65c75f87efeb3195a4b4b00430b0cc7c4dba29a27abdf7f5fde7ebe8d95435950c763d1b81cf96fdffff9c58c31d5bbb21d6d503c4c78e4cbbdb29c3c7d290debb2dfdcfd027b81e1f88fa9b165ef45e
  keyshare_index: "1"
  received_block_height: "123456"
  received_timestamp: "1696420024"
  validator: fairy14qekdkj2nmmwea4ufg0n113a4pud23y8tcf8bb
pagination:
  next_key: ZmFpcnkxNHFla2RrajJubW13ZWE0dWZnOW4wMDJhM3B1ZDIzeTh0Y2Y4YWEvAAAAAAABdFcv
  total: "0"
```

##### list-general-keyshares

The `list-general-keyshares` command allow users to query all the general keyshare submitted by validators.

`fairyringd query keyshare list-general-keyshares [flags]`

Example:

`fairyringd query keyshare list-general-keyshares`

Example Output:

```
general_keyshare:
- validator: fairy14qekdkj2nmmwea4ufg0n113a4pud23y8tcf8bb
  id_type: "private-gov-identity"
  id_value: "1/rq"
  keyshare: 91d7674f9feff2275971dda90bc25d2f65c75f87efeb3195a4b4b00430b0cc7c4dba29a27abdf7f5fde7ebe8d95435950c763d1b81cf96fdffff9c58c31d5bbb21d6d503c4c78e4cbbdb29c3c7d290debb2dfdcfd027b81e1f88fa9b165ef45e
  keyshare_index: "1"
  received_block_height: "123456"
  received_timestamp: "1696420024"
  
pagination:
  next_key: ZmFpcnkxNHFla2RrajJubW13ZWE0dWZnOW4wMDJhM3B1ZDIzeTh0Y2Y4YWEvAAAAAAABdFcv
  total: "0"
```

##### list-validator-set

The `list-validator-set` command allows users to query all the validators in the validator set.

`fairyringd query keyshare list-validator-set [flags]`

Example:

`fairyringd query keyshare list-validator-set`

Example Output:

```json
pagination:
  next_key: null
  total: "0"
validatorSet:
- cons_addr: 475c76e62b6bd684fdd33575610f973fcb1ca0a8
  index: fairy14qekdkj2nmmwea4ufg0n134b6pud23y9tcf8aa
  is_active: true
  validator: fairy14qekdkj2nmmwea4ufg0n134b6pud23y9tcf8aa
```

##### params

The `params` command allows users to query current params of the `keyshare` module.

`fairyringd query keyshare params [flags]`

Example:

`fairyringd query keyshare params`

Example Output:

```json
params:
  key_expiry: "10000"
  max_idled_block: "10000"
  minimum_bonded: "100000000000"
  slash_fraction_no_keyshare: "0.500000000000000000"
  slash_fraction_wrong_keyshare: "0.500000000000000000"
  trusted_addresses:
  - fairy1cmly9rn64tp5pmdwjbf40t0h7ttme6ld85je6f
```

##### show-active-pub-key

The `show-active-pub-key` command allows users to query current active & queued public keys and encrypted key shares.

`fairyringd query keyshare show-active-pub-key [flags]`

Example:

`fairyringd query keyshare show-active-pub-key`

Example Output:

```json
active_pubkey:
  creator: fairy1cmly9rn64tp5pmdwjbf40t0h7ttme6ld85je6f
  expiry: "123456"
  public_key: 8cef6ace8b47e47e7b0488f1550bcd9555a74be99677c3a487e57f3de76c28d274bc936ffa9b8da06c0fa5ded6412378
  number_of_validators: 1
  encrypted_keyshares:
  - data: XaMhXRlQ/wLVzXsQn4K/vwLKACBPV90koTC452UXPjgq1sSakgr33jLBNGFpzc71p7niKwAgfWc5Yd9ZupN3pcz9aC7EBG+Q2/ocxZerPR2rpbkq5NNAAnTY/yN7+xA7HcSm61fBFcv/ZPhthtvA8Qg+QYHfnQI8PouunWpHXjlOtWNY8g5GGFSqFSEkyHtaHOcC9OApPeosvv1o3Mrp+HenxURUqw==
    validator: fairy18hl5c9xn5dze2g50uaw0l2mr02ew57zkynp0td
queued_pubhey:
  creator: fairy1cmly9rn64tp5pmdwjbf40t0h7ttme6ld85je6f
  expiry: "133456"
  public_key: 859f30ece2ea1e25897bfd2bdb64c4762c6bd32e683600ca7a04572b1c639c6885cff981daab8bbf1dd9b1cd523c3e18
  number_of_validators: 1
  encrypted_keyshares:
  - data: XaMhXRlQ/wLVzXsQn4K/vwLKACBPV90koTC452UXPjgq1sSakgr33jLBNGFpzc71p7niKwAgfWc5Yd9ZupN3pcz9aC7EBG+Q2/ocxZerPR2rpbkq5NNAAnTY/yN7+xA7HcSm61fBFcv/ZPhthtvA8Qg+QYHfnQI8PouunWpHXjlOtWNY8g5GGFSqFSEkyHtaHOcC9OApPeosvv1o3Mrp+HenxURUqw==
    validator: fairy18hl5c9xn5dze2g50uaw0l2mr02ew57zkynp0td
```

##### show-decryption-key

The `show-decryption-key` command allows users to query decryption key of the target height.

`fairyringd query keyshare show-decryption-key [height] [flags]`

Example:

`fairyringd query keyshare show-decryption-key 100000`

Example Output:

```json
decryption_key:
  data: a19e5b345e236f9d07bbea401332e8d3f6f5d5cdfcfc0c7948609c263006036bf73a2db2b4ee726be48ea2181c093fc807442a8b81d135ca98d1db206d31fe4d082c5b9ad4483d6933989dace8a142b28927c6b868470116dc3d194b3934d276
  height: "100000"
```

##### show-authorized-address

The `show-authorized-address` command allows users to check if the target address is authorized.

`fairyringd query keyshare show-authorized-address [target] [flags]`

Example:

`fairyringd query keyshare show-authorized-address fairy1...`

Example Output:

```json
authorized_address:
  authorized_by: fairy1zrpp8efav7kancgse2peh3k98u9ueajwvq5w5q
  is_authorized: true
  target: fairy1f6mx8wgfb9xdxeswwavh9228uv6d7yga3qqtyv
```

##### show-commitments

The `show-commitments` command allows users to query all the active & queued commitments.

`fairyringd query keyshare show-commitments [flags]`

Example:

`fairyringd query keyshare show-commitments`

Example Output:

```json
active_commitments:
  commitments:
  - 8d42569a19d9823c14b9720ea68da33edac30863ab1559745978fb5a99db3eecaeefee7a511134714f04a08c0043ae03
  - 8280c76cf24d52e993ff157eb4368fe8a192e5ba3b7ddc3e6467328f5f74806ed7d1df191330226cb4b6b337d31ded5d
queued_commitments:
  commitments:
  - 95aabdd25677133b81f0e2a6648e3510c950f822152bb283d3f5e6b251a5b70762f6de7a1b5ecc2d35e17743d7389284
  - b1cec7b711c48bb21cb9b218cfb9e7f201b7d750837a64b5a4b2a2d48704a7ffc55cb8db3efa27ba15a5e1bae11d3adb
```

##### show-keyshare

The `show-keyshare` command allows users to query the keyshare submitted by the target validator on a particular height.

`fairyringd query show-keyshare [validator] [block-height] [flags]`

Example:

`fairyringd query keyshare show-keyshare fairy14qekdkj3mnmveb5ugh0n112a3pud23y8tcf9bb 100000`

Example Output:

```
keyshare:
  block_height: "100000"
  keyshare: 845da5dfe6ddc0fb685d5cbb2702bcbdb678ba4743c18d968caecbf050426e56450b999feb44bdb26032f0d67188999a187e3acb6dcfb92cfe25aedda0adb887edd65931aa7d94fc4f3fa49d26f420df5d51d24b539ec54d288b80c3720959b0
  keyshare_index: "9"
  received_block_height: "100000"
  received_timestamp: "1697561125"
  validator: fairy14qekdkj3mnmveb5ugh0n112a3pud23y8tcf9bb
```

##### show-general-keyshare

The `show-general-keyshare` command allow users to query the target general keyshare submitted by its validator, id type and id value.

`fairyringd query show-general-keyshare [validator] [id-type] [id-value] [flags]`

Example:

`fairyringd query keyshare show-general-keyshare fairy14qekdkj3mnmveb5ugh0n112a3pud23y8tcf9bb private-gov-identity "1/rq"`

Example Output:

```
general_keyshare:
  validator: fairy14qekdkj3mnmveb5ugh0n112a3pud23y8tcf9bb
  id_type: "private-gov-identity"
  id_value: "1/rq"
  keyshare: 91d7674f9feff2275971dda90bc25d2f65c75f87efeb3195a4b4b00430b0cc7c4dba29a27abdf7f5fde7ebe8d95435950c763d1b81cf96fdffff9c58c31d5bbb21d6d503c4c78e4cbbdb29c3c7d290debb2dfdcfd027b81e1f88fa9b165ef45e
  keyshare_index: "1"
  received_block_height: "123456"
  received_timestamp: "1696420024"
```

##### show-validator-set

The `show-validator-set` command allows users to check if the target address is in validator set.

`index` is the target validator address.

`fairyringd query show-validator-set [index] [flags]`

Example:

`fairyringd query show-validator-set fairy14qekdkj3mnmveb5ugh0n112a3pud23y8tcf9bb`

Example Output:

```
validatorSet:
  cons_addr: 475c76e62b5ad583fdd23587710f973fcb2ca0a8
  index: fairy14qekdkj3mnmveb5ugh0n112a3pud23y8tcf9bb
  is_active: true
  validator: fairy14qekdkj3mnmveb5ugh0n112a3pud23y8tcf9bb
```

#### Transactions

The `tx` commands allows users to interact with the `keyshare` module.

`fairyringd tx keyshare --help`

##### create-authorized-address

The `create-authorized-address` command allow validators to authorize another address to submit keyshare for them.

`fairyringd tx keyshare create-authorized-address [target] [flags]`

Example:

`fairyringd tx keyshare create-authorized-address fairy1...`

##### update-authorized-address

The `update-authorized-address` command allow validators to update the status of the authorized address.

`fairyringd tx keyshare update-authorized-address [target] [is-authorized] [flags]`

Example:

`fairyringd tx keyshare update-authorized-address fairy1... false`

##### delete-authorized-address

The `delete-authorized-address` command allow validators / the authorized address itself to delete the authorized address.

`fairyringd tx keyshare delete-authorized-address [target] [flags]`

Example:

`fairyringd tx keyshare delete-authorized-address fairy1...`

##### create-latest-pubkey

The `create-latest-pubkey` command allow trusted addresses to submit public key, commitments and encrypted key shares.

`fairyringd tx keyshare create-latest-pubkey [public-key] [commitments] [number-of-validators] [encrypted-key-shares] [flags]`

Example:

`fairyringd tx keyshare create-latest-pubkey "856ec61e4a6adc43f76262afbe503276e3798b35d7a329548322eac342f819f42466d92b81e7861e341326668f4f9a09" "856ec61e4a6adc43f76262afbe503276e3798b35d7a329548322eac342f819f42466d92b81e7861e341326668f4f9a09,a6f02f598d3b89c524792889b0b115cd229ba60aeb568c228de7db1e8c182fd07bb473fab5258564c26fe5164e287e35" 1 '[{"data": "XaMhXRlQ/wLVzXsQn4K/vwLKACBPV90koTC452UXPjgq1sSakgr33jLBNGFpzc71p7niKwAgfWc5Yd9ZupN3pcz9aC7EBG+Q2/ocxZerPR2rpbkq5NNAAnTY/yN7+xA7HcSm61fBFcv/ZPhthtvA8Qg+QYHfnQI8PouunWpHXjlOtWNY8g5GGFSqFSEkyHtaHOcC9OApPeosvv1o3Mrp+HenxURUqw==", "validator": "fairy18hl5c9xn5dze2g50uaw0l2mr02ew57zkynp0td"}]'`

##### register-validator

The `register-validator` command allow validators to register as a validator in `x/keyshare` module validator set.

`fairyringd tx keyshare register-validator [flags]`

Example:

`fairyringd tx keyshare register-validator`

##### deregister-validator

The `deregister-validator` command allow validators to deregister in `x/keyshare` module validator set.

`fairyringd tx keyshare deregister-validator [flags]`

Example:

`fairyringd tx keyshare deregister-validator`

##### send-keyshare

The `send-keyshare` command allow validators to submit their keyshare for specific block height.

`fairyringd tx keyshare send-keyshare [message] [keyshare-index] [block-height] [flags]`

Example:

`fairyringd tx keyshare send-keyshare a7348fb8cf57c1adf655f8d27c79086a5fd356285a6f00c9aea05ea6d2a8da63e08ea27d10d91b83be0778fc652d9c920ed18690f5e776ec3fb57e2504949bbe31deef8648c488263d871f040d5d2781068a3c2f78b057fef57397310367fb7d 1 100000`

## gRPC

Users can query the `keyshare` module using gRPC endpoints.

### Commitments

The `Commitments` endpoint allows users to query the active & queued commitments.

`fairyring.keyshare.Query/Commitments`

Example:

`grpcurl -plaintext localhost:9090 fairyring.keyshare.Query/Commitments`

Example Output:

```json
{
  "activeCommitments": {
    "commitments": [ "8d42569a19d9823c14b9720ea58d533edac69862ab1559745978fb5a99db3eecaeefee7a511134714f04a08c0043ae03","8280c76cf24d52e993ff146ea2368fe9a122e5ba3b7ddc3e6467328f5f74806ed7d1df191330226cb4b6b337d31ded5d",
    ]
  },
  "queuedCommitments": {
    "commitments": [   "96aabdd25677133b70e0e1a6648e3510c950f822152bb283d3f5e6b251a5b70762f6de7a1b5ecc2d35e27744d7389284",  "b1cec7b713d48bb10cb9b218cfb9e7f201b7d750837a64b5a4b2a2d48704a7ffc55cb8db3efa27ba15a5e1bbe21d3ada",
    ]
  }
}
```

### Params

The `Params` endpoint allows users to query `x/keyshare` module params.

`fairyring.keyshare.Query/Params`

Example:

`grpcurl -plaintext localhost:9090 fairyring.keyshare.Query/Params`

Example Output:

```json
{
  "params": {
    "keyExpiry": "10000",
    "trustedAddresses": [
      "fairy1cmly9rn75tp5pmdwjae39t8h8ttme6ld85jf7g",
    ],
    "slashFractionNoKeyshare": "NTAwMDAwMDAwMDAwMDAwMDAw",
    "slashFractionWrongKeyshare": "NTAwMDAwMDAwMDAwMDAwMDAw",
    "minimumBonded": "100000000000",
    "maxIdledBlock": "10000"
  }
}
```

### ValidatorSet

The `ValidatorSet` endpoint allows users to query if the target address is in the validator set.

`fairyring.keyshare.Query/ValidatorSet`

Example:

```bash
grpcurl -plaintext \
 -d '{"index": "fairy14qekdkj3nmmwea5ufg9n002a3pud23y8tcf7bb"}' \
 localhost:9090 \
 fairyring.keyshare.Query/ValidatorSet
```

Example Output:

```json
{
  "validatorSet": {
    "index": "fairy14qekdkj3nmmwea5ufg9n002a3pud23y8tcf7bb",
    "validator": "fairy14qekdkj3nmmwea5ufg9n002a3pud23y8tcf7bb",
    "consAddr": "475c76e62b5ad583fdd33575610f973fcb1ca0a8",
    "isActive": true
  }
}
```

### ValidatorSetAll

The `ValidatorSetAll` endpoint allows users to query all validators in the validator set.

`fairyring.keyshare.Query/ValidatorSetAll`

Example:

`grpcurl -plaintext localhost:9090 fairyring.keyshare.Query/ValidatorSetAll`

Example Output:

```json
{ 
  "validatorSet": [
    {
      "index": "fairy14qekdkj3nmmwea5ufg9n002a3pud23y8tcf7bb",
      "validator": "fairy14qekdkj3nmmwea5ufg9n002a3pud23y8tcf7bb",
      "consAddr": "475c76e62b5ad583fdd33575610f973fcb1ca0a8",
      "isActive": true
    },
    {
      "index": "fairy15davlswu4dfud5zushgp1ybm70p5cnu6w5vcfd",
      "validator": "fairy15davlswu4dfud5zushgp1ybm70p5cnu6w5vcfd",
      "consAddr": "21d6289fb05259639afe91963ebb18d06f8a976f",
      "isActive": true
    },
  ],
  "pagination": {
    "total": "2"
  }
}
```

### Keyshare

The `Keyshare` endpoint allows users to query the keyshare submitted by target validator on particular block height.

`fairyring.keyshare.Query/Keyshare`

Example:

```bash
grpcurl -plaintext \
 -d '{"validator": "fairy14qekdkj3nmmwea5ufg9n002a3pud23y8tcf7bb", "block_height": 100000}' \
 localhost:9090 \
 fairyring.keyshare.Query/Keyshare
```

Example Output:

```json
{
  "keyshare": {
    "validator": "fairy14qekdkj3nmmwea5ufg9n002a3pud23y8tcf7bb",
    "blockHeight": "100000",
    "keyshare": "845da5dfe6ddc0fb685d5cbb1691abaca678ba4743c18d968caecbf050426e56450b999feb44bdb26032f0d67188999a187e3acb5ccfb92cfe25aedda0adb887edd65931aa7d94fc4f3fa49d26f420df5d51d24b539ec54d288b80c3720959b0",
    "keyshareIndex": "9",
    "receivedTimestamp": "1697561125",
    "receivedBlockHeight": "100000"
  }
}
```

### KeyshareAll

The `KeyshareAll` endpoint allows users to query all the submitted keyshares.

`fairyring.keyshare.Query/KeyshareAll`

Example:

`grpcurl -plaintext localhost:9090 fairyring.keyshare.Query/KeyshareAll`

Example Output:

```json
{
  "keyshare": [
    {
      "validator": "fairy14qekdkj3nmmwea5ufg9n002a3pud23y8tcf7bb",
      "blockHeight": "95219",
      "keyshare": "91d7674f9feff2275971dda90bc25d1f75c64f87efeb3195a4b4b00430b0cc7c4dba29a27abdf7f5fde7ebe8d95435950c763d1b81cf96ffffff9c58c30c4bbb21d6d503c4c78e4cbbdb29c3c7d290debb2dfdcfd027b81e1f88fa9b165ef45e",
      "keyshareIndex": "9",
      "receivedTimestamp": "1697533024",
      "receivedBlockHeight": "95219"
    },
    {
      "validator": "fairy14qekdkj3nmmwea5ufg9n002a3pud23y8tcf7bb",
      "blockHeight": "95220",
      "keyshare": "aa35cbbe3394308f823080085ffa82940f5f79d622b0dc48fe12413cd9717d6730dd0f192d52a079812cab8ba67d9b6712dbf0558e8db3e1ec099be66d5ccc29b4e40a7f244f80ee7a5585b25205971daa10d1da68e783c0e12b865ccb9dd465",
      "keyshareIndex": "9",
      "receivedTimestamp": "1697533030",
      "receivedBlockHeight": "95220"
    }
  ],
  "pagination": {
    "nextKey": "ZmFpcnkxNHFla2RrajJubW13ZWE0dWZnOW4wMDJhM3B1ZDIzeTh0Y2Y4YWEvAAAAAAABdFcv",
    "total": "3493980"
  }
}
```

### DecryptionKey

The `DecryptionKey` endpoint allows users to query the decryption key on a particular height.

`fairyring.keyshare.Query/DecryptionKey`

Example:

```bash
grpcurl -plaintext \
 -d '{"height": 100000}' \
 localhost:9090 \
 fairyring.keyshare.Query/DecryptionKey
```

Example Output:

```json
{
  "decryptionKey": {
    "height": "100000",
    "data": "a19e5b345e236f9d07bbea401321e7d2e6f5d5cdfcfc0c7948609c263006036bf73a2db2b4ee726be48ea2181c093fc807442a8b81d135ca98d1db206d31fe4d082c5b9ad4483d6933989dace8a142b28927c6b868470116dc3d194b3934d276"
  }
}
```

### DecryptionKeyAll

The `DecryptionKeyAll` endpoint allows users to query all decryption keys.

`fairyring.keyshare.Query/DecryptionKeyAll`

Example:

`grpcurl -plaintext localhost:9090 fairyring.keyshare.Query/DecryptionKeyAll`

Example Output:

```json
{
  "decryptionKeys": [
    {
      "height": "15229",
      "data": "a32dd1859edf01bdae54e3e4f4a0ea95d2c461ed006ea384b223cef0e3e5d87fc560954f43aba363da21aabfbc0c57340f02604965a96bd83fc9fb28b23f1586b29def1e75b3a9df06353921f33ad80cf9903899a7a9843be8be559956b06391"
    },
    {
      "height": "15230",
      "data": "b13a3f707271acc7d83f3f28f1b819df439f064b7714b970b880e60abfbeaff2777f455f3a92952cc983b306deb193f802e697808acdc7145ebc1cc55aaaac881bb05d73cf212c465672615d57e6b8ffd115a40bc917f62bc70f62198b50ced0"
    }
  ],
  "pagination": {
    "nextKey": "AAAAAAAAO+Ev",
    "total": "831477"
  }
}
```

### Pubkey

The `Pubkey` endpoint allows users to query active & queued public keys and encrypted key shares.

`fairyring.keyshare.Query/Pubkey`

Example:

`grpcurl -plaintext localhost:9090 fairyring.keyshare.Query/Pubkey`

Example Output:

```json
{
  "activePubkey": {
    "publicKey": "8d56d4fc13b594fbb28edd326dcb957e1da44846caeacb6414d0a6335e8b1c71595bfb0d3856ddba081c95c100db3853",
    "creator": "fairy10tq25z63m3fedlwmtssf5g5qzh9zsjswvmcxc9",
    "expiry": "205",
    "numberOfValidators": "1",
    "encryptedKeyshares": [
      {
        "data": "z3dRFcwsIBsMtbLAfWnCJQLKACC7q6t+Ox64n9g7iRah4ojv0qyNoRMG0keZvU53urgqMgAgecCv1SKJ9nhx7F3iEmaO2p6MZSHAsCFVavSXyovIPtHX4VugFjx41LsO800HT6Fp5I3RU1yjFWWJ8RwpnkPjXCit7TGCD+5mvLAO0YlTQepuIxqbxr62SIG++dfklRwzfJleesQEXpc9gzsjNDq5/Q==",
        "validator": "fairy18hl5c9xn5dze2g50uaw0l2mr02ew57zkynp0td"
      }
    ]
  },
  "queuedPubkey": {
    "publicKey": "8aa4996b6622432eead77305c8774ed65c700c10c31da586af5db7bedb512ee437f37baaf19080bbfcd700bfbe0e862f",
    "creator": "fairy10tq25z63m3fedlwmtssf5g5qzh9zsjswvmcxc9",
    "expiry": "255",
    "numberOfValidators": "1",
    "encryptedKeyshares": [
      {
        "data": "W+5TnZxz4q33vaY8a3i6AQLKACCqYvBl0KpBglT5LiYMd02uAW7gcFkRYjNNOZbAXo4PIQAgBaxzXRl/PEurAbheNotnaXK2twRttRVDIDffDHmd+S615Oo4T/orCl5qYUWa2fnrz0o6+0BxtCdS3O2+0HNYQJhupPFs9SEW/r1jju8/IaNR4GgYpISY99zh6A7aH/1ToqlAJWLzvMLC3yCOE5AgGg==",
        "validator": "fairy18hl5c9xn5dze2g50uaw0l2mr02ew57zkynp0td"
      }
    ]
  }
}
```

### AuthorizedAddress

The `AuthorizedAddress` endpoint allows users to query target authorized address.

`fairyring.keyshare.Query/AuthorizedAddress`

Example:

```bash
grpcurl -plaintext \
 -d '{"target": "fairy1f6mx8wgfb9xdxeswwavh9228uv6d7yga3qqtyv"}' \
 localhost:9090 \
 fairyring.keyshare.Query/AuthorizedAddress
```

Example Output:

```json
{
  "authorizedAddress": {
    "target": "fairy1f6mx8wgfb9xdxeswwavh9228uv6d7yga3qqtyv",
    "isAuthorized": true,
    "authorizedBy": "fairy1zrpp8efav7kancgse2peh3k98u9ueajwvq5w5q"
  }
}
```

### AuthorizedAddressAll

The `AuthorizedAddressAll` endpoint allows users to query all authorized addresses.

`fairyring.keyshare.Query/AuthorizedAddressAll`

Example:

`grpcurl -plaintext localhost:9090 fairyring.keyshare.Query/AuthorizedAddressAll`

Example Output:

```json
{
  "authorizedAddress": [
    {
      "target": "fairy1f6mx8wgfb9xdxeswwavh9228uv6d7yga3qqtyv",
      "isAuthorized": true,
      "authorizedBy": "fairy1zrpp8efav7kancgse2peh3k98u9ueajwvq5w5q"
    }
  ],
  "pagination": {
    "total": "1"
  }
}
```
