---
sidebar_position: 2
---

# Encrypt transactions for `x/pep` module

This tutorial explains how to encrypt your transaction for `x/pep` module using `encrypter` that built-in `fairyringd`.
Ensure you installed the [`fairyring` binary](../running-a-node/installation.md) prior to following the instructions below.

## Encrypt your transaction

1. Getting the public key for encryption

```bash
PUBKEY=$(fairyringd query pep show-active-pub-key | jq -r '.active_pubkey.public_key')
```

2. Create the signed transaction. We'll use a bank send transaction in this example.

```bash
fairyringd tx bank send [FROM_ADDRESS] [TO_ADDRESS] [AMOUNT] --from [YOUR_ACCOUNT_NAME] --gas-prices 1ufairy --generate-only -o json -y > unsigned.json
```

- `[FROM_ADDRESS]` is the address you are using to send the token.
- `[TO_ADDRESS]` is the recipient address.
- `[AMOUNT]` is the amount you would like to send.
- `[YOUR_ACCOUNT_NAME]` is the account name of your `[FROM_ADDRESS]`.
- `--gas-prices` is the gas price you are paying.
- `--generate-only` means you only generate the unsigned transaction.
- `-o json` means to output the unsigned transaction in `json` format.
- `> unsigned.json` means outputs the unsigned transaction to a file named `unsigned.json`.

Example:

```bash
fairyringd tx bank send fairy18hl5c9xn5dze2g50uaw0l2mr02ew57zkynp0td fairy1qnk2n4nlkpw9xfqntladh74w6ujtulwnsgww3g 100ufairy --from alice --gas-prices 1ufairy --generate-only -o json -y > unsigned.json
```

This corresponds to a transaction that sends `100ufairy` from `alice` (`fairy18hl5c9xn5dze2g50uaw0l2mr02ew57zkynp0td`) to `fairy1qnk2n4nlkpw9xfqntladh74w6ujtulwnsgww3g`.

The `unsigned.json` looks something like this:

```json
{
 "body": {
  "messages": [
   {
    "@type": "/cosmos.bank.v1beta1.MsgSend",
    "from_address": "fairy18hl5c9xn5dze2g50uaw0l2mr02ew57zkynp0td",
    "to_address": "fairy1qnk2n4nlkpw9xfqntladh74w6ujtulwnsgww3g",
    "amount": [{ "denom": "ufairy", "amount": "100" }]
   }
  ],
  "memo": "",
  "timeout_height": "0",
  "extension_options": [],
  "non_critical_extension_options": []
 },
 "auth_info": {
  "signer_infos": [],
  "fee": {
   "amount": [{ "denom": "ufairy", "amount": "200000" }],
   "gas_limit": "200000",
   "payer": "",
   "granter": ""
  },
  "tip": null
 },
 "signatures": []
}
```

3. Signing the transaction

```bash
SIGNED=$(fairyringd tx sign unsigned.json --from [ACCOUNT_NAME] --offline \
--account-number $(fairyringd query account $(fairyringd keys show [ACCOUNT_NAME] -a) -o json | jq -r '.account_number') \
--sequence $(fairyringd query pep show-pep-nonce $(fairyringd keys show [ACCOUNT_NAME] -a) -o json | jq -r '.pepNonce.nonce'))
```

- `[ACCOUNT_NAME]` replace all instances to the account name you are using to sign the transaction.
- `--offline` means that you are signing your transaction offline with the provided account number & sequence instead of fetching it from the chain.
- `--account-number` is your account number, the command above will fetch it for you automatically.
- `--sequence` is the **pep nonce** of your address, the command above will fetch it for you automatically.

Example:

```bash
SIGNED=$(fairyringd tx sign unsigned.json --from alice --offline \
--account-number $(fairyringd query account $(fairyringd keys show alice -a) -o json | jq -r '.account_number') \
--sequence $(fairyringd query pep show-pep-nonce $(fairyringd keys show alice -a) -o json | jq -r '.pepNonce.nonce'))
```

The signed transaction looks like this:

```json
{
 "body": {
  "messages": [
   {
    "@type": "/cosmos.bank.v1beta1.MsgSend",
    "from_address": "fairy18hl5c9xn5dze2g50uaw0l2mr02ew57zkynp0td",
    "to_address": "fairy1qnk2n4nlkpw9xfqntladh74w6ujtulwnsgww3g",
    "amount": [{ "denom": "ufairy", "amount": "100" }]
   }
  ],
  "memo": "",
  "timeout_height": "0",
  "extension_options": [],
  "non_critical_extension_options": []
 },
 "auth_info": {
  "signer_infos": [
   {
    "public_key": {
     "@type": "/cosmos.crypto.secp256k1.PubKey",
     "key": "A3wiGqD+PZYB+hgRmWbD3Sugv2Ofw3G7rFjT0PJ7SBIZ"
    },
    "mode_info": { "single": { "mode": "SIGN_MODE_DIRECT" } },
    "sequence": "3"
   }
  ],
  "fee": {
   "amount": [{ "denom": "ufairy", "amount": "200000" }],
   "gas_limit": "200000",
   "payer": "",
   "granter": ""
  },
  "tip": null
 },
 "signatures": [
  "vmPWsuAsasg...10Ad2QafEByg2q0zug=="
 ]
}
```

You can check your signed transaction with the following command:

`echo $SIGNED | jq`

4. Encrypting the transaction

```bash
ENCRYPTED=$(fairyringd encrypt [TARGET_HEIGHT / REQ-ID] $PUBKEY $SIGNED)
```

- `[TARGET_HEIGHT / REQ-ID]` is the target execution height of your transaction, or if you are encrypting a general tx, it is the request id / identity. It will also be used when you submit the encrypted transaction.
- `$PUBKEY` is the public key (encryption key) you got from Step 1.
- `$SIGNED` is the signed transaction from Step 3.

5. Check the encrypted transaction by:

`echo $ENCRYPTED`

6. Submit the encrypted transaction

```bash
fairyringd tx pep submit-encrypted-tx $ENCRYPTED [TARGET_HEIGHT] --from [ACCOUNT_NAME] --gas-prices 1ufairy -y
```

- `$ENCRYPTED` is the hex encoded encrypted tx from `encrypter`
- `[TARGET_HEIGHT]` is the target execution height of your transaction. This should be the same as the `[TARGET_HEIGHT]` used when encrypting the transaction using `encrypter`
- `[ACCOUNT_NAME]` is the account you would like to send the transaction from. This should be the same as the account you used to sign the transaction.

If you are submitting a general encrypted transaction:

```bash
fairyringd tx pep submit-general-encrypted-tx $ENCRYPTED [REQ-ID] --from [ACCOUNT_NAME] --gas-prices 1ufairy -y
```

- `$ENCRYPTED` is the hex encoded encrypted tx from `encrypter`
- `[REQ-ID]` is the request id / identity used in encryption. This should be the same as the `[REQ-ID]` used when encrypting the transaction using `encrypter`
- `[ACCOUNT_NAME]` is the account you would like to send the transaction from. This should be the same as the account you used to sign the transaction.
