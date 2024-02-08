---
sidebar_position: 5
---

# Share Generation API

The Share Generation API is currently responsible for performing the verifiable secret sharing for keyshares.
Keyshares will be rotated every `N` blocks meaning that the master public key (used for encrypting transactions),
keyshares and keyshare commitments (used for submitting to `fairyring`) will be different every round.
The keyshares stored on the server are encrypted with public key of registered validators.
The master public key will be submitted to `fairyring` (along with keyshare commitments and number of validators) at the beginning of every round.

This tutorial explains how to interact with our Share Generation API.

## Share Request

```bash
GET https://7d3q6i0uk2.execute-api.us-east-1.amazonaws.com/share-req
```

Fetches your keyshare for the current round.

**Keep in mind that the keyshare will be rotated every `N` blocks. Make sure to send the share request every `N` blocks for the latest keyshare.**

### Request Body

```json
{
  "path": "/share-req",
  "httpMethod": "GET",
  "queryStringParameters": {
    "publicKey": "VALIDATOR_PUBLIC_KEY",
    "msg": "CURRENT_TIMESTAMP",
    "signedMsg": "CURRENT_TIMESTAMP_SIGNED_WITH_VALIDATOR_PRIVATE_KEY"
  }
}
```

- `path`, the path of your request, `/share-req` in this case.
- `httpMethod`, request method, `GET` in this case.
- `publicKey`, your validator cosmos account public key encoded in base64, for the server to know who is sending the request.
- `msg`, the timestamp of when the request is being made as a string.
- `signedMsg`, `SHA256` hashed timestamp and signed with your validator cosmos account private key, encoded in bae64, for the server to verify you are actually the owner of the public key.

Here is the example request body (without the full public key & signed message):

```json
{
  "path": "/share-req",
  "httpMethod": "GET",
  "queryStringParameters": {
    "publicKey": "A8S5yG2QJE5nV2vCObdnbouIkooccDzAO1GHX9fSQ1x/",
    "msg": "1245752000",
    "signedMsg": "czM0MzA0amZkZGQwMzI0OTAzMjQyMzQ="
  }
}
```

### Request Response

```json
{
 "body": {
  "pk": "PUBLIC_KEY",
  "encShare": "ENCRYPTED_SHARE",
  "index": "SHARE_INDEX"
 }
}
```

- `pk` is the master public key of the current round. It can be used for encryption.
- `encShare` is the keyshare for the current round encrypted with your cosmos account public key, it can be decrypted using your cosmos account private key.
- `index` is your keyshare index, you will need this when submitting keyshares to `fairyring`.

## Last Share Request

```bash
GET https://7d3q6i0uk2.execute-api.us-east-1.amazonaws.com/share-req
```

Returns your keyshare for the last round.

### Request Body

```json
{
  "path": "/last-share-req",
  "httpMethod": "GET",
  "queryStringParameters": {
    "publicKey": "VALIDATOR_PUBLIC_KEY",
    "msg": "CURRENT_TIMESTAMP",
    "signedMsg": "CURRENT_TIMESTAMP_SIGNED_WITH_VALIDATOR_PRIVATE_KEY"
  }
}
```

- `path`, the path of your request, `/last-share-req` in this case.
- `httpMethod`, request method, `GET` in this case.
- `publicKey`, your validator cosmos account public key encoded in base64, for the server to know who is sending the request.
- `msg`, the timestamp of when the request is being made as a string.
- `signedMsg`, `SHA256` hashed timestamp and signed with your validator cosmos account private key, encoded in bae64, for the server to verify you are actually the owner of the public key.

Here is the example request body (without the full public key & signed message):

```json
{
  "path": "/last-share-req",
  "httpMethod": "GET",
  "queryStringParameters": {
    "publicKey": "A8S5yG2QJE5nV2vCObdnbouIkooccDzAO1GHX9fSQ1x/",
    "msg": "1245752000",
    "signedMsg": "czM0MzA0amZkZGQwMzI0OTAzMjQyMzQ="
  }
}
```

### Request Response

```json
{
 "body": {
  "pk": "PUBLIC_KEY",
  "encShare": "ENCRYPTED_SHARE",
  "index": "SHARE_INDEX"
 }
}
```

- `pk` is the master public key of the current round of key share, It can be used for encryption.
- `encShare` is the key share for the last round encrypted with your cosmos account public key, it can be decrypted with your cosmos account private key.
- `index` is you key share index, you will need this when submitting the key share to Fairyring.
