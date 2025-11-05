---
sidebar_position: 0
---
# Overview of Fairblock
Open finance cannot scale if every payment, trade, and treasury move is exposed. Fairblock provides applications and infrastructure that eliminate information leakage, reduce manipulation risk, and unlock outcomes for users, institutions, and businesses. 

Fairblock is a dynamic, decentralized cryptographic computer for fast, secure execution of cryptographic logic. It hosts low-cost, high-performance native confidential apps (cApps) and brings these capabilities to ecosystems where liquidity lives, including Arbitrum, Hyperliquid, Solana, Base, and Cosmos.

## Why Fairblock

- **Multimodal cryptography:** Dynamic confidentiality selects the right cryptographic schemes per use case to maximize performance and security without unnecessary overhead. 

- **Private by default. Verifiable on demand:** Sensitive values are encrypted by default. Authorized parties can receive selective, per-transaction access when required (audit, AML, disputes). No blanket surveillance of the entire transaction history. Designed for regulated flow, Fairblock is compatible with post-execution selective disclosure ([OFAC](https://www.govinfo.gov/app/details/CFR-2010-title31-vol3/CFR-2010-title31-vol3-sec500-314), [FinCEN](https://www.ecfr.gov/current/title-31/subtitle-B/chapter-X/part-1010/subpart-A/section-1010.100#p-1010.100), [MiCA](https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX%3A32023R1114#d1e4979-86) friendly)

- **On the chains and apps where liquidity lives:** Confidentiality is available in existing environments. Users do not need to bridge funds to fragmented privacy chains. Flexible, plug-in composability means devs don’t need to migrate their stack or learn new languages.

- **Open verification, not black boxes:** Correctness is verified onchain. Single-TEE or opaque off-chain coprocessor/relayer designs are intentionally avoided.

- **Performance for everyday payments and DeFi:** Lightest and least complex schemes are chosen to meet requirements and avoid overkill approaches. This results in no multi-minute proof wait time and low computation fees. Costs are incurred when confidentiality adds execution value, not for ordinary peer-to-peer transfers.


## What We Ship

#### **Stabletrust: Confidential Stablecoins**

Send and receive stablecoins with encrypted amounts and balances on public chains. Addresses remain transparent for DeFi composability and traceability. A specific transaction, and only that transaction, can be disclosed when required. It’s not a mixer or an isolated privacy chain. 
**Core applications:** payroll & payouts, cross-border commerce, trading, treasury operations, OTC, M&A, and strategic buybacks.


#### **Protected Trading: Confidential Execution**

Eliminate information leakage around size and timing while keeping settlement on public chains. Encrypted orders, intents, and bids with conditional decryption enable better price discovery and manipulation-resistant trading, lending, intents, and token launches, all without reliance on centralized intermediaries.


Fairblock's cApps work natively on FairyRing. By collaborating with leading networks and venues, confidentiality also works smoothly in existing ecosystems and workflows. Select ecosystem partners include: Arbitrum, Noble/M0, Hyperliquid, Solana, Base, Cosmos, payment networks, stablecoin issuers, and CowSwap. 


[![Fairblock Macro Schematic](../assets/FairyRingMacroSchematic.png)](../assets/FairyRingMacroSchematic.png)
