---
sidebar_position: 3
---

# IBE

In this tutorial, you will learn about the IBE typescript module.

### 1. Input Parameters

To encrypt voting data, you will receive the following input parameters:
`identity`, `publicKey`, and `votingOption` data as bytes.

### 2. Create Timelock Encrypter

And then, create `timelock encrypter` from `identity` and `publicKey`.

```typescript
function createTimelockEncrypter(identity: string, pubKey: string) {
  return async (fileKey: Uint8Array): Promise<Array<Stanza>> => {
    const idByte = new TextEncoder().encode(identity);
    const point = PointG1.fromHex(pubKey);
    const ciphertext = await ibe.encryptOnG1(point, idByte, fileKey);
    return [
      {
        type: "distIBE",
        args: [`${identity}`],
        body: serialisedCiphertext(ciphertext),
      },
    ];
  };
}
```

`identity` is a string, so convert it to bytes.
Then, encrypt `identity` and `publicKey` with random `fileKey` by using [@noble/bls12-381](https://www.npmjs.com/package/@noble/bls12-381), and return this encrypter function.

### 3. Encrypt Age

Now, you can encrypt `votingOption` data using `timelock encrypter` and `fileKey`. `fileKey` is just random 32 bytes.

```typescript
export async function encryptAge(
  plaintext: Uint8Array,
  wrapFileKey: EncryptionWrapper = NoOpEncDec.wrap
): Promise<string> {
  const fileKey = await random(fileKeyLengthBytes);
  const recipients = await wrapFileKey(fileKey);
  const body = await encryptedPayload(fileKey, plaintext);

  return writeAge({
    fileKey,
    version: ageVersion,
    recipients,
    headerMacMessage,
    body,
  });
}
```

### 4. Convert to Hex

Finally, convert the encrypted data to a hex string and then return it.

```typescript
return Buffer.from(agePayload, "binary").toString("hex");
```

## Example

Original voting data:

```json
{
  "identity": "1/rq",
  "publicKey": "99d54aeb64f6d91ed1ab668448cfffe9217e3d3ed24861856ef070eb075df6149e6a1d0a7d7594e5b0cdfc8f44db5e8d",
  "voteOption": {
      "option": 1, // 1: yes, 2: no, etc
      "randomNo": 1698938287829
  }
}
```

Converted voting data:

```json
{
    "identity": "1/rq",
    "publicKey": "99d54aeb64f6d91ed1ab668448cfffe9217e3d3ed24861856ef070eb075df6149e6a1d0a7d7594e5b0cdfc8f44db5e8d",
    "voteOptionBytes": {
        "0": 8,
        "1": 1,
        "2": 16,
        "3": 213,
        "4": 237,
        "5": 243,
        "6": 132,
        "7": 185,
        "8": 49
    }
}
```

Encrypted voting data:

```
6167652d656e6372797074696f6e2e6f72672f76310a2d3e20646973744942450a7279516b31304c47444c694b4e35394933427851614e4d66306662726a716f6b7957443354467836376d4476526d4971434f63617a6e366d7077587a663374780a7348644833736437707061696a2b50683763354e58394351384b4c4665556d55675436464c4d467473726c6247305a39514e6d6c3469536f3644577a2b3055500a69757778306e6776583538744166743679354a5951410a2d2d2d20394778323845546439726775577a78643131546f746b6171596c64643176704d4a42564c594e68414d55550a009f72364d582c6364bf7e9d2a325db41a8621cb712b80eae001823f061a0565959c50ed4cea5827b1
```

