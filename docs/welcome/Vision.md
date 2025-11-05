---
sidebar_position: 0
---
# Overview of Fairblock
Open finance cannot scale if every payment, trade, and treasury move is exposed onchain. Fairblock ships end-to-end applications that eliminate information leakage, reduce manipulation risk, and unlock outcomes for users, institutions, and businesses. 

Fairblock is a dynamic, decentralized cryptographic computer with its own execution layer. Native confidentinal apps (cApps) run on Fairblock's native chain, FairyRing, and are accessible from major ecosystems so users can enable confidentiality without bridges or switching stacks.

## Why Fairblock

- **Product-first:** cApps run natively on FairyRing for performance and security, then are made accessible from other ecosystems to meet users where they are. Distribution flows into Fairblock cApps.
 
- **Multimodal cryptography:** Dynamic confidentiality selects the right cryptographic schemes per use case (HE, MPC/IBE, lightweight ZK, etc.) to maximize performance and security without unnecessary overhead. 

- **Private by default. Verifiable on demand:** Sensitive values are encrypted by default. Authorized parties can receive selective, per-transaction access when required (audit, AML, disputes). No blanket surveillance of the entire transaction history. Designed for regulated flow and compatible with post-execution selective disclosure ([OFAC](https://www.govinfo.gov/app/details/CFR-2010-title31-vol3/CFR-2010-title31-vol3-sec500-314), [FinCEN](https://www.ecfr.gov/current/title-31/subtitle-B/chapter-X/part-1010/subpart-A/section-1010.100#p-1010.100), [MiCA](https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX%3A32023R1114#d1e4979-86) friendly)

- **Onchain verification, not black boxes:** Correctness and validity are verified onchain. Single-TEE or opaque off-chain coprocessor/relayer designs are intentionally avoided to minimize trust assumptions and security risks.

- **Performance for everyday payments and DeFi:** The lightest scheme that meets requirements is chosen to avoid overkill approaches. This results in no multi-minute proof wait times and low computation fees. Costs are incurred when confidentiality adds execution value, not for ordinary peer-to-peer transfers.


## What We Ship

#### **Stabletrust: Confidential Stablecoins**

Send and receive stablecoins with encrypted amounts and balances on public chains. Addresses remain transparent for DeFi composability and traceability. A specific transaction, and only that transaction, can be disclosed when required. It’s not a mixer or an isolated privacy chain. **Built for:** payroll & payouts, cross-border commerce, trading, treasury operations, OTC, M&A, and strategic buybacks.


#### **Protected Trading: Confidential Execution**

Eliminate information leakage around size and timing while keeping settlement on public chains. Encrypted orders, intents, and bids with conditional decryption enable better price discovery and manipulation-resistant trading, lending, intents, and token launches, all without reliance on centralized intermediaries.


## Where Users Access Fairblock cApps

Fairblock cApps run on FairyRing and are accessible from ecosystems where liquidity lives. This allows users keep their wallets and workflows while gaining confidentiality.

- Ethereum/EVM: Arbitrum, Hyperliquid, Base, Noble/M0, and more
- Solana
- Payment networks
- Additional trading platforms

Distribution is user-led. Ecosystems integrate into Fairblock cApps. 


[![Fairblock Macro Schematic](../assets/FairyRingMacroSchematic.png)](../assets/FairyRingMacroSchematic.png)
