---
title: Cosmos Appchain Integration
sidebar_position: 0
---

# Cosmos Appchain Integration

In this section, we briefly go over the different ways to integrate with Fairyring.  
You have two main options:

- [Direct PEP Integration](./direct_pep_integration.md) — Integrate the `x/pep` module directly into your app-chain for minimal implementation effort.
- [Custom Integration](./custom_integration.md) — Build a custom communication logic and interact with Fairyring via IBC.

Each approach has its advantages depending on the degree of control and flexibility you want.

> Explore both options to find what fits your architecture best!

---

## Integration Comparison

Depending on the requirements and complexity of your appchain, you can choose either a fast plug-and-play integration or a fully customizable confidential workflow.  
The table below outlines the key differences between the two methods.

| Feature | Direct PEP Integration | Custom Integration |
|:--------|:----------------------|:-------------------|
| Setup Complexity | Low | High |
| Communication Model | Internal automatic communication with Fairyring's `x/pep` module | Manual IBC messaging with Fairyring's `x/keyshare` module |
| Control over Encryption/Decryption Flows | Limited (abstracted away) | Full |
| Decryption Key Handling | Automatic | Appchain must handle key material manually |
| Recommended For | Fast and simple integration into Cosmos SDK chains | Advanced chains needing custom confidential workflows |
| Responsibility for Retry/Timeouts | Handled by Fairyring internally | Appchain must manage retries, timeouts, and state recovery |
| MPK Updates | Automatically managed | Must be fetched manually via `CurrentKeysPacketData` |

---

> **Note:** Direct PEP Integration abstracts the interaction with Fairyring and handles decryption flows automatically. Custom Integration offers full flexibility but requires the appchain to manage IBC communication directly with the keyshare module.
