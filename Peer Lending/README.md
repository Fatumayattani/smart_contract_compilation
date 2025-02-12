# Peer-to-Peer Lending

A decentralized lending system where users borrow and repay directly using smart contracts.

## Features
- Lenders can issue loans to borrowers.
- Borrowers receive funds and must repay with interest.
- The smart contract ensures trustless repayment.

## Installation
1. Deploy the contract to an Ethereum testnet/mainnet.
2. Use a frontend dApp or script to interact with the contract.

## Usage
- Call `issueLoan(borrower, amount, interest, dueDate)` to lend funds.
- Call `repayLoan(loanId)` to repay a loan.
