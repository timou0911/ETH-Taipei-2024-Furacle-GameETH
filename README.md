# Furacle GamETH

## Introduction
Gather crypto enthusiasts on Optimism together!
Furacle GameETH is a derivative financial product designed to allow people to bet on the future price of ETH/USD. Participants can join a daily bet with 0.01 ether, deciding whether the price of ETH will rise or fall that day, and then wait until noon to see if they've bet on the correct outcome.

## What We've Built
We have built a game based on betting on the ETH/USD price. Every new day (after 12 a.m.), users can predict whether the price of ETH will go up or down. The outcome is determined by comparing the price at noon on the following day with the price at midnight. For instance, if the price at 12 p.m. on the following day is higher than the price at 12 a.m., the result is considered "higher," and vice versa.

Each participant enters the game with 0.01 ether locked in. Once the result is announced, the contract performs the settlement, calculating the amount of money that participants who guessed correctly can reclaim. Winners will receive their locked ethers plus a share of the money lost by the losers. We take a 5% fee from the latter.

## How it’s Made
For the price feed, we utilize the Chainlink Data Feed (AggregatorV3Interface) to retrieve the current price of ETH/USD. To retrieve the price at 12 p.m. and at 12 a.m. every day, as well as to perform settlements, Chainlink Automation fulfills our requirements.

With the high level of speculation in the crypto and blockchain world, such a game provides users the incentive to win money from others and the dopamine to stay excited. Just like the futures we trade on centralized exchanges (CEX), we've moved this characteristic into a smart contract, expecting to witness such madness occur on-chain too.

## Team Members
- Canfly: Based in Taipei, Taiwan. Interested in Blockchain, Enneagram & Pokémon.

    - Telegram: https://t.me/canfly1019

    - Gmail: 2017xiao06@gmail.com

- Tim (歐冠亭): CS student in NCKU focusing on smart contract programming and Web3Sec.

    - Telegram: https://t.me/gtimou

    - Gmail: x0928048316@gmail.com



## Links
Optimism Sepolia Scan: https://sepolia-optimism.etherscan.io/address/0x51d448a64a016843d0db72fea8945ac7a7e04851#code
