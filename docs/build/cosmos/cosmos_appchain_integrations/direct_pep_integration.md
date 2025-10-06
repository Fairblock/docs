---
title: Direct PEP Integration
sidebar_position: 1
---

# Direct PEP Integration

The `x/pep` module can be directly incorporated into any Cosmos SDK-based application chain to enable seamless privacy integration with Fairblock's FairyRing network.

This approach provides a minimal-overhead method for allowing encrypted transactions and automatic decryption/execution flows.

---

## Overview

By integrating the `x/pep` module into your chain:

- Your chain can **connect to the FairyRing chain**, constantly updating its Master Public Key (MPK) and automatically retrieving decryption keys as they are generated.
- **Users can submit encrypted transactions** on your chain, which will be **automatically decrypted and executed** once the appropriate decryption keys are available from FairyRing.

This enables Cosmos chains to easily unlock confidential compute flows without having to build custom encryption/decryption pipelines.

---

## How to Integrate

Integrating the `x/pep` module is similar to integrating a standard Cosmos SDK module, such as `bank` or `staking`.

You need to:

1. Import the `x/pep` module in your codebase.
2. Wire the module in your `app.go`.
3. Set the module parameters correctly (especially `is_source_chain = false`).

---

### 1. Import the PEP Module

In your `app.go`:

```go
import (
    // other imports
    pepmodule "github.com/Fairblock/fairyring/x/pep"
    pepkeeper "github.com/Fairblock/fairyring/x/pep/keeper"
    peptypes "github.com/Fairblock/fairyring/x/pep/types"
)
```

---

### 2. Add Keeper to Your App

Declare the PEP Keeper inside your `App` struct:

```go
type App struct {
    // other keepers...

    PepKeeper pepkeeper.Keeper
}
```

Then initialize it inside the `NewApp` function:

```go
app.PepKeeper = *pepkeeper.NewKeeper(
    appCodec,
    keys[peptypes.StoreKey],
    app.GetSubspace(peptypes.ModuleName),
    app.AccountKeeper,
    app.BankKeeper,
)
```

---

### 3. Register the Module

Add `pepmodule.NewAppModule` to your list of modules:

```go
app.mm.SetOrderBeginBlockers(
    // other modules...
    peptypes.ModuleName,
)

app.mm.SetOrderEndBlockers(
    // other modules...
    peptypes.ModuleName,
)

app.mm.RegisterModules(
    // other modules...
    pepmodule.NewAppModule(appCodec, app.PepKeeper, app.AccountKeeper),
)
```

And mount the store key:

```go
app.MountStores(
    keys[peptypes.StoreKey],
    // other keys...
)
```

---

### 4. Configure Genesis Parameters Carefully

One critical parameter is:

```proto
bool is_source_chain = 2 [(gogoproto.moretags) = "yaml:\"is_source_chain\""];
```

> **In your chain's `app_state` for the `pep module`, make sure that `is_source_chain` is set to `false`**

Example:

```yaml
pep:
  params:
    is_source_chain: false
```

Setting `is_source_chain: false` tells the `x/pep` module that this chain is a consumer of decryption keys from FairyRing, rather than producing its own.

If you leave this value `true` by mistake, your PEP module will not properly connect to FairyRing and decryption flows will fail.

---

## Final Notes

After completing these changes:

- Your appchain will automatically monitor FairyRing for new decryption keys.
- Encrypted transactions submitted by users will be automatically processed once decryption material is available.
- You have enabled native confidential compute workflows inside your chain with minimal custom effort.

🚀 This approach is ideal for chains that want to integrate Fairblock functionality without needing major architectural changes.
