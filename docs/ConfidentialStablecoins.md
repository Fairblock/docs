---
sidebar_position: 4
---

# Moving money on public blockchains leaks sensitive financial data

Your financial activity is private by default in the real world. You don’t broadcast what you pay a merchant or supplier. Employers don't publish salaries. Traders don’t reveal position size in the middle of a trade. Treasuries don’t expose how much cash is left. On public blockchains, all of that is transparent by design: payment amounts, wallet balances, timing, and even trading strategies are public for anyone to see. That’s exactly the kind of exposure banks, SWIFT, and policy bodies have been sounding alarm about. 

When financial data leaks, it creates problems:
- Competitors can see your volume, pricing, margins, and runway
- Traders and bots can frontrun and copy your strategy
- Attackers can map and target high-value wallets
- You can run into legal and regulatory trouble because you failed to protect sensitive information about employees, customers, and partners

[Researchers](https://www.researchgate.net/publication/387041111_Decoding_blockchain_data_for_research_in_marketing_New_insights_through_an_analysis_of_share_of_wallet) have shown that block explorers can be abused as a surveillance tool. Onchain data can be used to decode transaction patterns, customer behavior, peak sales times, and share-of-wallet. That is not how finance or commerce operates today, and it’s why enterprises and institutions still hesitate to run their businesses fully onchain.

Our **thesis**: Confidential by default is the only sustainable model for open finance.


# Stabletrust: Confidential stablecoins powered by Fairblock

Stabletrust turns stablecoin payments and transfers confidential by default. Amounts and balances are encrypted while addresses stay transparent. This combination lets you:
- Preserve DeFi composability 
- Stay traceable for audits
- Reveal only what’s needed on a transaction-level, only when it is required. 

It is not a mixer and not an anonymity pool. It is programmable confidentiality built for real businesses and real finance. This approach aligns with the model BIS, ECB, IMF, and others are describing for next-generation payment systems: private to the public and verifiable on demand. 

What this technology enables:

**Payments & Payroll**
- Confidential salaries for employees, contractors, and KOLs
- Private peer-to-peer, cross-border, and merchant payments
- Integration with payment networks for compliant, confidential settlements

No one wants comp, vendor rates, or partner payouts scraped and indexed. That’s HR liability, competitive intelligence leakage, and reputational risk.

**DeFi & Trading**
- Encrypted orderflow and resistant to manipulation (e.g. frontrunning)
- Confidential liquidity, collateral, and position management

If the market can see size and timing, you’re handing a competitive edge to competitors and bots. Confidential amounts stop your orders from working against you.

**Treasury & Institutional**
- Managing onchain VC liquid funds, corporate, DAO, and fund treasury operations
- Confidential inter-subsidiary and OTC settlements

Treasury activity is strategy. Get the benefits of moving funds onchain without broadcasting your strategy tothe entire market.

**M&A and Strategic Deals**
- Private acquisitions and token buyouts without market leaks
- Pre-announcement confidentiality and selective auditability

Onchain corporate actions that expose you to frontrunners. It also creates legal and regulatory questions if markets react before disclosure windows. 

**Compliance & Regulation**
- Selective disclosure and bad actor filtering
- Anti-money laundering (AML)-safe stablecoins and regulatory auditability
- Protection against GDPR/MiCA/CCPA/Clarity related data exposure risk for institutions

Regulators increasingly expect two things: don’t expose everything to everyone and do let authorized parties verify under lawful authority. Stabletrust follows this exact model. You can disclose a specific transaction – and only that transaction – to a tax authority, regulator, or auditor without revealing your entire financial history. This maps to how financial supervisors describe acceptable digital asset systems and how TradFi already handles sensitive trade and payments data.

**Infrastructure & Advanced Use**
- Privacy-preserving credit, lending, and agentic payments
- Selective-disclosure rails for payment networks, issuers, and banks

You can’t run credit or agent-to-agent payments if every invoice, fee, and settlement is globally visible. Confidential rails are the prerequisite. With selective disclosures, regulated parties settle onchain and can still produce per-transaction details for compliance.


# Why Stabletrust

**Confidentiality where the liquidity already lives**

One-click confidentially on the chains and apps you already use. No extra cost or added security risks from forcing you to bridge your assets or loss of privacy when moving funds in/out of privacy chains. That means lower cost, lower risk, and you stay close to existing liquidity.

**Lower fees**

We don’t charge a fee on every sender just because you want privacy. Fees are capped and designed to be practical for invoices, payroll, and treasury ops. Our monetization is split across integrations, partners, and float, to minimize fees on transactions.

Since the cryptography is lightweight, the gas required to verify and update confidential balances is significantly lower than systems that rely on heavy zero-knowledge (ZK) proofs or fully homomorphic encryption (FHE), which most payment use cases simply don’t need. 

**No black-box trust**

Users are not exposed to unnecessary security risks from single hardware setups (e.g. single-TEE), outsourced ZK provers, or centralized offchain coprocessors. 

With Stabletrust:
- Proofs are quickly generated client-side
- Verification happens onchain
- Key management is decentralized and secure
- Computation is verifiable – no blind trust

**Fast enough for real usage**

Other privacy systems fall apart because proofs take minutes on a phone or they require heavyweight off-chain computation. Stabletrust’s proofs are light enough to run in normal payment flow.

Throughput also scales: we can already handle significantly higher TPS than typical TFHE-style systems before hardware acceleration. We also work with specialized hardware teams (FPGA/GPU acceleration) for even more headroom, which keeps this system future-proof for high-volume partners like payment processors and trading venues.

![alt text](<Confidential Stablecoins.png>)


# Compliance Posture and Regulatory Alignment

**Confidential amounts, transparent addresses**

Stabletrust encrypts amounts and balances by default, but keeps sender and receiver addresses transparent. Why this matters: 
- This is not a mixer. Traceability done right means auditability, not surveillance. 
- Regulators, auditors, and banks can still see who interacted with who.
- You get confidentiality of sensitive financial data for business and commerce.
- Alignment with the limited transparency with selective access model central banks and supervisors are proposing for digital payments ([OFAC](https://www.govinfo.gov/app/details/CFR-2010-title31-vol3/CFR-2010-title31-vol3-sec500-314),[FinCEN](https://www.ecfr.gov/current/title-31/subtitle-B/chapter-X/part-1010/subpart-A/section-1010.100#p-1010.100), [MiCA](https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX%3A32023R1114#d1e4979-86) friendly).

This posture aligns with how TradFi and big-tech manage sensitive financial data. Apple Pay doesn’t broadcast your transactions to the world, and banks don’t leak order size in real-time. However, both can produce records for auditors and regulators when required. It’s the same principle.

**Selective disclosure**

Instead of giving one centralized auditor silent, persistent access to everyone’s transaction history, Stabletrust uses identity-based encryption and multiparty computation (IBE-MPC) to enable per-transaction disclosures. 

What this means:
- Nothing is automatically exposed
- If access is required, a scoped view-key can be issued for that specific transaction
- You stay compliant without handing permanent visibility to any single third party

**AML and sanctions controls**

We work with services like Chainalysis and Range Security to flag and block high-risk or sanctioned addresses. These are the same types of services institutions and regulators already recognize as credible for AML and OFAC filtering. Legitimate businesses, merchants, and financial institutions get confidentiality and bad actors get filtered out. 

**Confidentiality vs Anonymity**

Stabletrust is composable with DeFi and usable today by banks, issuers, payment networks, and trading desks because addresses stay transparent. 

For users that need obfuscated addresses, we support fully address privacy in controlled conditions: 
- Opt-in, KYB/KYC-scoped environments (merchants, trading desks, banks, etc.)
- With sanctions screening and risk controls
- With selective disclosure still available

Stabletrust is designed to go beyond confidential amounts. It’s done responsibly to ensure users are not at risk of triggering regulatory flags.


# Technology Overview

Most of our guides and tutorials focus on applications built using MPC and IBE, such as frontrunning protection, auctions, prediction markets, limit orders, and access control. 

For confidential stablecoin payments and transfers, we use a purpose-built path that stays light, secure, and performant. Developers **do not need to deploy or install extra precompiles, modules, or smart contracts**. Everything is managed by Fairblock’s smart contracts on each supported chain, and FairyRing abstracts the cryptographic computation, all without bridging user funds.

Key design choices:

1. Homomorphic Encryption (HE): amounts and balances are encrypted so we can update balances without learning the value. We intentionally use a simple scheme that is orders of magnitude lighter and cheaper than general FHE (TFHE/CKKS), which is overkill and expensive for payment-like workloads. 
2. Lightweight ZK proofs: the user proves “I’m allowed to transfer X” and “the math is valid” without revealing X. This prevents malformed inputs and preserves account integrity.
3. Selective disclosure via MPC and IBE: after settlement, an authorized party can decrypt exactly what policy allows (e.g. “amount of transaction #123” or “balances over this period”) with keys from distributed keys generation (DKG), per‑account and per‑auditor. Result: auditor rotation and no persistent backdoor access.
4. No fully trusted centralized coprocessor or relayer: the work is verifiable onchain so you don’t have to trust a single offchain black-box.
5. Efficient message complexity: IBE is kept linear, avoiding the quadratic complexities in some other multi-party schemes.

For developers:

1. Confidential account setup: user opts into confidentiality and links a wallet. Initial funding into the confidential pool is visible. Subsequent balances are encrypted.
2. Transfer: client encrypts the amount and generates the ZK proof. Fairyring verifies and updates encrypted balances. The recipient gets a decryptable receipt.
3. Settlement: underlying tokens remain fully reserved in a locking contract (escrow). Redemptions are 1:1.
4. Compliance window: authorized parties can request targeted decryption keys through MPC/IBE service for post‑trade or post-payment audits on a per-transaction basis.


Explore [Stabletrust]( [https://confidential-usdc-demo.vercel.app/](https://stabletrust.fairblock.network/)).
