<!-- --- -->
<!-- sidebar_position: 1 -->
<!-- --- -->

# Fairyring

**Fairyring** is the Cosmos-SDK app chain responsible for the management of the decryption keys that power the Fairblock network. The chain is composed of two modules: **Keyshare** and **PEP** (pre-execution privacy).  
Currently, the sole purpose of the chain is to allow (registered) validators to submit keyshares. Upon reaching a threshold of shares submitted each block, the submitted shares are generated, aggregated, and emitted.

- Registration

  - Currently, we allow validators the option to participate in the threshold process. This requires a registration method so that they can onboard and be allowed to submit keyshares every block.

- Sending keyshares
  - The message for sending a validator's keyshare for the current block. Once a threshold of these have been received, the chain will aggregate and release a decryption key.
  - Keyshares also require a commitment and keyshare index. This is for verification of keyshares.

```proto
message MsgSendKeyshare {
  string creator       = 1;
  string message       = 2;
  string commitment    = 3;
  uint64 keyShareIndex = 4;
  uint64 blockHeight   = 5;
}
```
