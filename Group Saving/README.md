# Chama Savings

A smart contract that automates **group savings (Chamas)** where members contribute funds regularly. Each cycle, one member receives a payout.

## Features
- Members can join the savings group.
- Members contribute a fixed amount each cycle.
- The contract automatically distributes payouts.

## Installation
1. Deploy the contract on Ethereum or an EVM-compatible blockchain.
2. Set the contribution amount upon deployment.

## Usage
- Call `joinChama()` to become a member.
- Call `contribute()` to deposit funds.
- Admin calls `distributePayout()` to release funds to the next recipient.
