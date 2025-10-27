---
sidebar_position: 4
---

# Confidential Stablecoins

Public blockchains leak sensitive information like payroll, vendor terms, treasury moves, and trading operations, compromising competitive intelligence and increasing attack surface. Enterprises can’t scale on public rails without confidentiality.

**Solution:** Fairblock enables confidential stablecoin transfers and balances with transparent addresses and per-transaction selective disclosure, aligning with regulatory requirements.

**Why now:** Stablecoins already process trillions annually. Capturing 10 bps on a tiny share is a sizable business. Confidentiality is the unlock for institutional adoption per SWIFT’s Chief Innovation Officer, Tom Zschach.

**Tech:** Twisted ElGamal (fast additive HE) + light ZK proofs + MPC/IBE for selective disclosure compliance. It’s performant, auditable, and composable.

Explore our [demo]( https://confidential-usdc-demo.vercel.app/) for confidential USDC.
![alt text](<demo.png>)


# Confidentiality is a requirement, not a nice-to-have

Money is already confidential in the real world. Your employer doesn’t publish payroll. Your treasury ops don’t broadcast vendor rates. Traders don’t reveal position sizes mid-trade. On fully transparent blockchains, all of that information is leaked onchain by default, turning basic business activity into free competitive intelligence and creating real security risk. We don’t accept this level of exposure in traditional finance. So why do we accept it as an inherent opportunity cost of doing business onchain?

Public chains create transparency problems at institutional scale: salaries, supplier terms, and treasury moves become trivially observable. [Researchers](https://www.researchgate.net/publication/387041111_Decoding_blockchain_data_for_research_in_marketing_New_insights_through_an_analysis_of_share_of_wallet) have shown that a block explorer can be abused as a surveillance tool, in which basic onchain data can be used to decode transaction patterns, customer behavior, peak sales times, and share-of-wallet. That’s not how modern commerce operates, and it’s why confidentiality is the unlock for stablecoins to become true enterprise payment rails.

The risks aren’t theoretical. Attackers and competitors mine public transaction metadata to profile operations, target high-value wallets, and frontrun strategies. Even security conscious institutions have had their treasury footprints mapped with accuracy. Without a confidentiality layer, many enterprises will stay off public rails or only use them at arm’s length.

**Our thesis**: Confidential by default is the only sustainable model for onchain payments and finance. Fairblock delivers confidentiality without sacrificing composability or compliance.

# Stablecoins are already massive. Just 10 basis points on flow is a thriving business.

Institutional capital is racing onchain. RWAs on public chains are [$24B+](https://www.chain-brain.xyz/p/the-great-onchain-migration), up 3x since 2023. Stablecoins processed [$27.6T](https://www.weforum.org/stories/2025/03/stablecoins-cryptocurrency-on-rise-financial-systems/) in transfer volume in 2024, more than Visa and Mastercard volume combined. This is not a future bet. It’s here. As the stablecoin market matures, both market cap and utility will continue to explode.

Even a small penetration of current stablecoin flows support outsized revenue. If stablecoin capitalization grows toward the multi-hundreds of billions and beyond over the next cycle, confidential rails capture disproportionate value because enterprises will not move serious money without confidentiality.

- 0.1% share of $27.6T = $27.6B in annual flow -> $27.6M revenue
- 1% share of $27.6T = $276B in annual flow -> $276M revenue

# Confidential Stablecoins powered by Fairblock

Institutions aren’t stalling on stablecoins because of scalability or volatility. Confidentiality is the blocker per SWIFT’s Chief Innovation Officer, Tom Zschach. Fairblock turns stablecoin payments and balances confidential by default. Amounts and account activities are encrypted while addresses can remain transparent to preserve composability and allow optional, policy-driven selective disclosure on a per-transaction level. This is not a mixer and not an anonymity pool. Instead, it’s a compliant, programmable confidentiality layer for real businesses and real finance.

What this enables

- Payroll: Employees get paid onchain without exposing salaries to coworkers or competitors. HR and auditors get the proofs they need.
- Vendor and Treasury: Businesses can pay supplies and rebalance cash without leaking negotiated rates or strategy.
- Trading Ops: Traders can handle margin calls confidentially, keeping position sizes and P&L out of public view.

![alt text](<Confidential Stablecoins.png>)
# Why Fairblock

Fairblock is fundamentally different from other solutions. Mixers and shielded pool systems optimize for anonymity. Fairblock optimizes for what CFOs, treasurers, and institutions actually require: confidentiality and compliance.

**Tornado Cash:** A mixing service designed to break address linkages by pooling deposits and withdrawals. Its core value prop is anonymity, not enterprise‑grade confidentiality or selective disclosure. It has been at the center of global [sanctions](https://home.treasury.gov/news/press-releases/jy0916) and [enforcements](https://apnews.com/article/cryptocurrency-treasury-crypto-sanctions-russia-north-korea-88115029d0a033b7b8b3e3a34dccf00c), illustrating the regulatory friction of mixer‑style tools.

- Fairblock is not a mixer. We keep addresses transparent by default for composability and allow encrypted amounts and balances with audit-ready, per-transaction selective disclosure. This model is designed for institutional finance, payroll, and payments.

**Railgun**: A zk‑based privacy system enabling users to interact with DeFi from shielded addresses. Within Railgun, senders, recipients, and amounts can be shielded. Confidentiality is anchored in a shielded pool model. This is closer to anonymity tooling.

- Fairblock takes the opposite architectural stance on identity: keep address-level transparency so wallets, compliance tools, and apps can see who, but encrypt amounts and balances so no one sees how much unless authorized. This preserves composability with the broader ecosystem and supports post-execution, selected disclosure to auditors (i.e. regulators) without forcing users into a separate private pool or a privacy chain.

# Technology Overview

** Most of our integration guides and tutorials focus on applications built using **MPC** and **IBE**, such as **frontrunning protection**, **auctions**, **prediction markets**, **limit orders**, **decentralized selective disclosure**, and **access control**.

For **confidential stablecoin transfers**, we use **Homomorphic Encryption (HE)**. This application **does not require special integrations or developer setup**. It works seamlessly across **all Fairblock-integrated chains**, including **EVM chains, Solana, Cosmos chains, and FairyRing itself**. Developers **do not need to deploy or install any precompiles, modules, or smart contracts**; everything is **handled automatically by Fairblock’s own contracts and partner deployments** on each supported chain.

High level:

1. Homomorphic Encryption (HE) (Twisted ElGamal): amounts and balances are encrypted so we can update balances without learning the value. We chose a simple scheme to optimize for performance, which is far lighter than fully homomorphic encryption (FHE) like TFHE/CKKS for transfer‑like operations. FHE schemes are general and orders of magnitude heavier–overkill–for this workload.
2. Lightweight ZK proofs: users prove “I’m allowed to transfer X” and “the math checks out” without revealing X. This prevents malformed inputs and preserves account integrity.
3. Selective Disclosure via multiparty computation (MPC) + identity-based encryption (IBE): after settlement, authorized auditor (i.e. regulator) can decrypt exactly what policy allows (e.g. “amount of transaction #123” or “balances over a period”) with keys via distributed keys generation (DKG) per‑account and per‑auditor. Outcome: auditor rotation and no persistent backdoor access.
4. No fully trusted centralized coprocessor or relayer.
5. Message complexity of IBE is linear compared to quadratic complexity of other MPC solutions

For developers:

1. Confidential Account setup: A user opts into confidentiality and links a wallet. Initial funding into the confidential pool is visible. Subsequent balances are encrypted.
2. Transfer: Client encrypts the amount and forms ZK proofs. Fairyring verifies and updates encrypted balances. The recipient gets a decryptable receipt.
3. Settlement: Underlying tokens remain fully reserved in a locking contract (escrow). Redemptions are 1:1.
4. Compliance window: Authorized parties can request targeted decryption keys via the MPC/IBE service for post‑trade audits on a per-transaction level.

# Compliance and Risks: Selective visibility without backdoors

Fairblock offers the compliance-first path for institutions: maintain confidentiality by default and disclosure is scoped to who needs to know and when with cryptographic assurance.

- **Per‑transaction, per‑auditor keys**: Decryption keys are generated with specific parameters (transaction, account, period) accessible by the select auditor. No “view‑all” master key.
- **Post‑execution model:** Disclosure happens after settlement and only what is needed is revealed policy requires. No full financial history.
- **Audit trails and attestations**: Every disclosure event is logged and provable.
- **Compatibility with existing tooling**: The model aligns with regulatory guidance emphasizing selective disclosure and auditability for digital assets ([OFAC](https://www.govinfo.gov/app/details/CFR-2010-title31-vol3/CFR-2010-title31-vol3-sec500-314),[FinCEN](https://www.ecfr.gov/current/title-31/subtitle-B/chapter-X/part-1010/subpart-A/section-1010.100#p-1010.100), [MiCA](https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX%3A32023R1114#d1e4979-86) friendly).

# Roadmap

- **v1:** Confidential transfers & balances on Fairyring
- **v2**: EVM, Solana, and Cosmos adapters
- **v3**: Confidential intents, crosschain transactions, and recurring payments. Programmable confidentiality for complex workflows (milestone payments, escrow, etc).

# FAQ

*Does Fairblock hide everything?*

No. Addresses can remain transparent for composability and policy. Amounts and balances are encrypted by default; *specific* details can be disclosed post‑settlement with scoped keys.

*Is this compliant?*

The design supports audit-ready per-transaction selective disclosure, which is aligned with emerging [guidance](https://www.federalreserve.gov/econres/feds/files/2023059pap.pdf) on selective visibility for digital assets. Enterprises get the privacy they need and the auditability regulators demand.

*Why not use an isolated privacy chain?*

Privacy chain models fragment liquidity, add operational complexity (bridging, long proofs), and still tend to leak metadata. Our focus is confidential payments that interoperate with the main liquidity venues, not isolating users into separate pools or networks.