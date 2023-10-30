import React from 'react';
import clsx from 'clsx';
import styles from './styles.module.css';
import FeatureEncryptSvg from '../../assets/FeatureEncryptSvg';
import FeatureProtectSvg from '../../assets/FeatureProtectSvg';
import FeatureShieldSvg from '../../assets/FeatureShieldSvg';

type FeatureItem = {
  title: string;
  Svg: React.ComponentType<React.ComponentProps<'svg'>>;
  description: JSX.Element;
};

const FeatureList: FeatureItem[] = [
  {
    title: 'Encrypt',
    Svg: FeatureEncryptSvg,
    description: (
      <>
        Encrypting votes and bids for private governance and sealed-bid auctions
      </>
    ),
  },
  {
    title: 'Protect',
    Svg: FeatureProtectSvg,
    description: <>Protecting DeFi users from bad-MEV bots</>,
  },
  {
    title: 'Private',
    Svg: FeatureShieldSvg,
    description: <>Storing encrypted limit orders and on-chain intents</>,
  },
];

function Feature({ title, Svg, description }: FeatureItem) {
  return (
    <div className={clsx('col col--4')}>
      <div className="text--center">
        <Svg className={styles.featureSvg} role="img" />
      </div>
      <div className="text--center padding-horiz--md">
        <h3>{title}</h3>
        <p>{description}</p>
      </div>
    </div>
  );
}

export default function HomepageFeatures(): JSX.Element {
  return (
    <section className={styles.features}>
      <div className="container">
        <div className="row">
          {FeatureList.map((props, idx) => (
            <Feature key={idx} {...props} />
          ))}
        </div>
      </div>
    </section>
  );
}
