---
sidebar_position: 2
---

# FairyRing cApp

It's time to run your first cApp with FairyRing! This demo is expanded on more in detail within the [fairyring tutorial inside of the build section](../build/fairyring/fairyring_encrypted_msg.md), and is especially useful for those interested in building their own unique apps using confidential computation on FairyRing.

By the end, you'll understand how to send encrypted messages and token transfers using FairyRing and its inherit functionalities. More specifically:
   - Create and sign transactions on Fairblock
   - Encrypt transactions for deferred execution
   - Retrieve transaction status and results

<!-- A walk through of this quick demo is show in the video below. Feel free to watch it and follow along with the rest of this page.

<div style={{ textAlign: "center" }}>
  <iframe
    width="100%"
    height="315"
    src="https://www.youtube.com/embed/79pSFHolMuI?si=dubh8pPQKypHThBp"
    title="FairyRing Demo #1 - Encrypted Transactions"
    frameBorder="0"
    allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
    referrerPolicy="strict-origin-when-cross-origin"
    allowFullScreen
    style={{ maxWidth: "560px" }}
  ></iframe>
</div> -->

To run this demo, simply download this repo, and switch to this specific feature branch, `feat-auction`.

```bash
git clone https://github.com/Fairblock/fairyring.git
gco feat-auction
```

Now, simply run:

```bash
make devnet-up
./bankMsgWithMemoAndDecryption.sh
```

Upon running the `./bankMsgWithMemoAndDecryption.sh` script, you will be prompted for the following basic inputs required to:

1. Specify the recipient of said bank message,
2. Encrypt the message with a target block height,
3. Submit the encrypted transaction to the blockchain,
4. Monitor the network for transaction processing, and show the decrypted result

Once you have gone through the prompts, you will have successfully ran your first cApp where you've sent a simple message, encrypted it, and awaited the condition (block height in this case) for it be decrypted!

Using this simple concept, many interesting apps can be built. Make sure to join our [discord](https://discord.gg/jhNBCCAMPK) to discuss new ideas. A list of interesting ideas, currently worked on and to be worked on, will be available soon.
