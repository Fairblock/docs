---
sidebar_position: 1 
---

# Integrating the `pep` module into your own app-chain

<!-- TODO - consider revamping this section to "Advanced Tutorials" or something. We want the docs clear, but since we will have a quickstart already for EVMs and AppChains, perhaps we don't want to clutter the docs with more tutorials. I have seen others try to have a cookbook, but eventually projects like LayerZero ended up just having a github repo full of patterns and other relevant tutorials. -->

In this tutorial, you will learn how to integrate the `pep` module in your own app chain to enable encrypted transactions.
To integrate, you will be modifying your `app.go` file.

Import pep module by adding the following lines to the import section in `app/app.go`

```go
pepmodule "github.com/Fairblock/fairyring/x/pep"
pepmodulekeeper "github.com/Fairblock/fairyring/x/pep/keeper"
pepmoduletypes "github.com/Fairblock/fairyring/x/pep/types"
```

- Add the module to `ModuleBasics`

```go
ModuleBasics = module.NewBasicManager(
  // ... 
  pepmodule.AppModuleBasic{},
 )
```

- Update module account permissions

```go
maccPerms = map[string][]string{
    // ...
    pepmoduletypes.ModuleName:  {authtypes.Minter, authtypes.Burner, authtypes.Staking},
 }
```

- Add keepers to app

```go
type App struct {
 // ...
 ScopedPepKeeper      capabilitykeeper.ScopedKeeper

 PepKeeper     pepmodulekeeper.Keeper
 // ...
 }
```

- update kv store keys

```go
 keys := sdk.NewKVStoreKeys(
    // ... 
  pepmoduletypes.StoreKey,
 )
```

- configure keepers and module

```go
 scopedPepKeeper := app.CapabilityKeeper.ScopeToModule(pepmoduletypes.ModuleName)
 app.PepKeeper = *pepmodulekeeper.NewKeeper(
  appCodec,
  keys[pepmoduletypes.StoreKey],
  keys[pepmoduletypes.MemStoreKey],
  app.GetSubspace(pepmoduletypes.ModuleName),
  app.IBCKeeper.ChannelKeeper,
  &app.IBCKeeper.PortKeeper,
  scopedPepKeeper,
  app.IBCKeeper.ConnectionKeeper,
  app.BankKeeper,
 )
 pepModule := pepmodule.NewAppModule(
  appCodec,
  app.PepKeeper,
  app.AccountKeeper,
  app.BankKeeper,
  app.MsgServiceRouter(),
  encodingConfig.TxConfig,
  app.SimCheck,
 )

 pepIBCModule := pepmodule.NewIBCModule(app.PepKeeper)
```

- Add IBC route

```go
ibcRouter.AddRoute(icahosttypes.SubModuleName, icaHostIBCModule).
  AddRoute(ibctransfertypes.ModuleName, transferIBCModule).
  AddRoute(pepmoduletypes.ModuleName, pepIBCModule)
```

- Add to module manager

```go
app.mm = module.NewManager(
 // ...  
  pepModule,
 // ... 
)
```

- Set begin and end blockers

```go
app.mm.SetOrderBeginBlockers(
  // ... 
  pepmoduletypes.ModuleName,
 )

app.mm.SetOrderEndBlockers(
  // ... 
  pepmoduletypes.ModuleName,
 )
```

- Modify genesis modules

```go
genesisModuleOrder := []string{
  // ...  
  pepmoduletypes.ModuleName,
 }
```

- Scoped keeper  

```go
app.ScopedPepKeeper = scopedPepKeeper
```

- Init params keeper

```go
func initParamsKeeper(appCodec codec.BinaryCodec, legacyAmino *codec.LegacyAmino, key, tkey storetypes.StoreKey) paramskeeper.Keeper {
 paramsKeeper := paramskeeper.NewKeeper(appCodec, legacyAmino, key, tkey)

 // ... 
 paramsKeeper.Subspace(pepmoduletypes.ModuleName)

 return paramsKeeper
}
```
