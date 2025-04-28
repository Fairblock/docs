---
title: Custom Integration
sidebar_position: 2
---

# Custom Integration

Custom integration provides greater flexibility by allowing the appchain to directly communicate with Fairyring's `x/keyshare` module over IBC. 

This method requires the appchain to handle the logic for initiating IBC transactions to Fairyring and processing the corresponding responses. While it provides full control over encryption workflows, it demands more effort compared to direct `x/pep` integration.

---

## Overview

In the custom integration path:

- The appchain establishes direct IBC communication with Fairyring's `keyshare` module.
- The appchain must manage when to send IBC requests and how to handle IBC acknowledgments and responses.
- Responsibility for queueing, timeout handling, retries, and state management lies with the appchain.

This approach is suitable for advanced chains that want to implement their own confidential workflows or layer additional logic on top of Fairyring's capabilities.

---

## Available IBC Endpoints

Fairyring's `x/keyshare` module provides several IBC packet types that the appchain can interact with. Below is a summary of each available packet and its purpose.

### RequestDecryptionKeyPacketData

Used by the appchain to request an identity from Fairyring.  
This initiates the process of generating an encrypted identity and eventually obtaining its corresponding decryption key.

### GetDecryptionKeyPacketData

Used by the appchain to request a decryption key for an already existing identity from Fairyring.  
This packet is useful when the identity has already been requested previously, and only the key material is now needed.

### DecryptionKeyDataPacketData

Sent by Fairyring to the appchain when a decryption key has been generated.  
The appchain must be able to handle and consume this packet appropriately, such as by unlocking transactions encrypted under that identity.

### RequestPrivateDecryptionKeyPacketData

Used by the appchain to request the generation of a **private identity** on Fairyring.  
Private identities enable use cases where fine-grained access control is desired, such as user-specific confidential data.

### GetPrivateDecryptionKeyPacketData

Used by the appchain to request a **list of encrypted keyshares** for an existing private identity from Fairyring.  
This is part of enabling the private decryption workflow, where key material must be assembled in a privacy-preserving manner.

### PrivateDecryptionKeyDataPacketData

Sent by Fairyring to the appchain containing the list of encrypted keyshares corresponding to a private identity.  
The appchain must process this packet to reconstruct the private key securely when appropriate.

### CurrentKeysPacketData

Used by the appchain to fetch the latest active and queued Master Public Keys (MPKs) from Fairyring.  
This is critical to ensure that encryption operations on the appchain are always performed using the correct public key material.

---

## General Integration Approach

Custom integration requires the appchain to:

1. Establish an IBC connection with the Fairyring chain targeting the `keyshare` module.
2. Build and send IBC packets according to the desired workflow (e.g., requesting an identity, fetching decryption keys).
3. Handle incoming packets (e.g., decryption keys, keyshares) in the IBC packet handler logic.
4. Maintain local state, retries, timeouts, and re-request logic as necessary.

This is an advanced integration mode and assumes familiarity with Cosmos SDK's IBC application development.

---

## Example Code Snippets

### Sending a RequestDecryptionKeyPacket

```go
import keysharetypes "github.com/Fairblock/fairyring/x/keyshare/types"

packet := keysharetypes.KeysharePacketData{
    Packet: &keysharetypes.KeysharePacketData_RequestDecryptionKeyPacket{
        RequestDecryptionKeyPacket: &keysharetypes.RequestDecryptionKeyPacketData{
            Requester:      requesterAddress.String(),
            Identity:       identity,
            EstimatedDelay: durationpb.New(time.Minute * 5),
        },
    },
}

// Send the packet over IBC
err := app.KeyshareKeeper.TransmitKeysharePacket(
    ctx,
    packet,
    sourcePort,
    sourceChannel,
    timeoutHeight,
    timeoutTimestamp,
)
if err != nil {
    return sdkerrors.Wrap(err, "failed to send RequestDecryptionKeyPacketData")
}
```

### Handling a DecryptionKeyDataPacket

```go
func (am AppModule) OnRecvPacket(ctx sdk.Context, packet channeltypes.Packet, data keysharetypes.KeysharePacketData) exported.Acknowledgement {
    switch pkt := data.Packet.(type) {
    case *keysharetypes.KeysharePacketData_DecryptionKeyDataPacket:
        return handleDecryptionKeyData(ctx, pkt.DecryptionKeyDataPacket)
    // handle other packet types
    default:
        return channeltypes.NewErrorAcknowledgement(fmt.Sprintf("unrecognized keyshare packet type"))
    }
}

func handleDecryptionKeyData(ctx sdk.Context, packet *keysharetypes.DecryptionKeyDataPacketData) exported.Acknowledgement {
    // Example: store decryption key locally
    k.SetDecryptionKey(ctx, packet.Identity, packet.DecryptionKey)

    return channeltypes.NewResultAcknowledgement([]byte("decryption key stored"))
}
```

## Important Considerations

- IBC setup: Ensure a stable IBC connection exists with the Fairyring chain before sending any packets.
- Timeouts: Handle packet timeouts properly to avoid dangling requests.
- Retries: Implement retry logic where necessary, especially for long-lived decryption key generation processes.
- State management: Track pending identities and decryption keys cleanly in your appchain's state.

## Conclusion
Custom integration offers full flexibility and enables building highly specialized confidential workflows using Fairyring's infrastructure.
However, it demands careful IBC management, packet handling, and appchain-side orchestration.
