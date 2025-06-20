---
sidebar_position: 5
---

# Using Fairyring’s Verifiable Randomness

This section outlines three possible approaches to integrate the Verifiable Randomness Function (VRF) from Fairyring with other chains, which include both Cosmos SDK and EVM-compatible execution environments.

## Verifiable Randomness on Fairyring

Fairyring can provide a Verifiable Random String via a functionality in its KEYSHARE module.

```proto
rpc VerifiableRandomness(QueryVerifiableRandomnessRequest) returns (QueryVerifiableRandomnessResponse) {
  option (google.api.http).get = "/fairyring/keyshare/verifiable_randomness";
}

message QueryVerifiableRandomnessRequest {}

message QueryVerifiableRandomnessResponse {
  string randomness = 1;
  uint64 round = 2;
}
```

## Approach 1: IBC Query

Use IBC to make a query on the Fairyring chain. This is the simplest way for other Cosmos chains to fetch Randomness from fairyring, since IBC is a core part of the Cosmos-SDK. However, it can work with other EVM chains as well if they have an IBC implementation.

### Requirements

- A working IBC channel between the Native chain and Fairyring.
- IBC Relayer for **Native Chain-Fairyring** communication
- Implementation of an IBC query logic in the native chain

### Code Sketch

```go
// IBC module in Native chain
func (k Keeper) RequestRandomnessFromFairyring(ctx sdk.Context) error {
    // Build IBC packet with QueryVerifiableRandomnessRequest
    packet := ibcPacket{
        Type: "VerifiableRandomness",
        Data: &keyshare.QueryVerifiableRandomnessRequest{},
    }
    return k.SendIBCPacket(ctx, packet, fairyringChannelID)
}
```

### Advantages

- Fully on-chain and decentralized process of transmission
- Default Merkel-Proof verification of date across chains

### Disadvantages

- Requires Native Chain to have IBC capabilities
- There may be some delay in the Request-Response cycle due to strict verifications enforced by IBC

## Approach 2: Use Fairyring Gateway Smart Contract

For EVM chains, the simplest way to fetch Randomness from Fairyring is to deploy the standard Fairyring Gateway Contract on the native chain. Then, Fairyport, a specialized cross-chain relayer for Fairyring, can be used to relay the VRF from Fairyring to this contract.

> NOTE: Fairyport is a relayer, custom-made for relaying information between Fairyring and other chains. (Currently supports EVM and Cosmos chains), However, the randomness can be locally verified on the Native chain through cryptography; the relayer doesn’t need to be blindly trusted.

### Setup

- Deploy FairyringGateway.sol on Native Chain.
- Configure Fairyport to relay VRF data from Fairyring to this contract.

The Gateway contract has the following functionalities:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

interface IGateway {
    function latestEncryptionKey() external view returns (bytes memory);
    function getRandomnessByHeight(uint256) external view returns (bytes32);
    function latestRandomnessHashOnly() external view returns (bytes32);
    function latestRandomness() external view returns (bytes32, uint256);
    function encryptionKeyExists(bytes memory) external view returns (bool);
}
```

### Advantages

- Works out of the box with minimal changes.

### Disadvantages

- Fixed interface; flexibility might be limited.

## Approach 3: Custom Smart Contract + Fairyport Integration

For EVM chains, a more flexible, but more involved, way of fetching randomness from Fairyring is to create a custom gateway contract tailored for the said Native chain. This would allow for custom processing of the randomness and application-specific logic to be applied on when to request Randomness and how to process it. Once the contract is deployed on the Native chain, the Fairyport relayer can be used to relay the Randomness to this custom contract, rather than the default gateway contract.

### Setup

- Write and deploy a new Solidity contract on the Native chain.
- Modify Fairyport to encode VRF data and send it to this new contract.

```solidity
contract EVMRandomness {
    bytes32 public latestRandomness;
    uint256 public latestRound;

    function updateRandomness(bytes32 randomness, uint256 round) external {
        // Add authentication for Fairyport
        latestRandomness = randomness;
        latestRound = round;
    }
}
```

### Advantages

- Maximum flexibility.
- Allows custom access control and business logic.


### Disadvantages

- Requires development effort on both the smart contract and Fairyport
- Slightly more complex setup
