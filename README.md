# MasterEscrowAdvanced: An Advanced Ethereum Escrow Smart Contract

## Overview

`MasterEscrowAdvanced` is an Ethereum smart contract designed to facilitate escrow-based transactions between a buyer and a seller. The contract allows sellers to initiate transactions, buyers to confirm purchases by sending funds, and either party to cancel transactions under specific conditions. The contract also emits events for easy tracking of transaction states.

## Features

- **Transaction Creation**: Sellers can create new transactions specifying the buyer, price, and a descriptive name for the transaction.
- **Confirm Purchase**: Buyers can confirm a purchase by sending the exact amount of Ether to the contract.
- **Confirm Receipt**: Buyers can confirm receipt of goods or services, releasing the escrowed funds to the seller.
- **Cancel Transaction**: Either the buyer or the seller can cancel the transaction if it's still in the 'Created' state.
- **Event Logging**: Events are emitted at every crucial transaction state change for easier backend tracking.

## Functions

### `createTransaction(uint256 txId, address payable _buyer, uint256 _price, string memory _name)`

- Called by the seller to create a new transaction.
- Emits a `TransactionCreated` event.

### `confirmPurchase(uint256 txId)`

- Called by the buyer.
- The buyer must send the exact amount of Ether specified in the transaction.
- The transaction state changes to 'Locked'.
- Emits a `TransactionLocked` event.

### `confirmReceived(uint256 txId)`

- Called by the buyer to confirm receipt of the goods or services.
- Releases the escrowed funds to the seller.
- Emits a `TransactionReleased` event.

### `cancelTransaction(uint256 txId)`

- Can be called by either the buyer or the seller.
- Only cancellable if the transaction is in the 'Created' state.
- Emits a `TransactionCancelled` event.

## Events

- `TransactionCreated`
- `TransactionLocked`
- `TransactionReleased`
- `TransactionCancelled`

## How to Use

1. Sellers can create new transactions by calling `createTransaction`.
2. Buyers can confirm purchases by calling `confirmPurchase` and sending the required Ether.
3. Once the goods or services are received, buyers confirm by calling `confirmReceived`.
4. Transactions can be cancelled by calling `cancelTransaction` if they are still in the 'Created' state.

## Requirements

- Solidity ^0.8.0
