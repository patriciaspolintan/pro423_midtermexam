# PoultryChain: Smart Contract for Egg Traceability

## Description
This project implements a transparent supply chain for poultry products. It tracks the lifecycle of egg batches from the moment they are packaged at the farm until they reach the distributor.

## Features
- **Immutable Ledger:** Uses Ethereum-based logic to prevent data tampering.
- **Role-Based Access:** Only the assigned Farmer can register stock; only the assigned Distributor can confirm receipt.
- **Traceability:** Full ownership history is stored in an array for every product ID.

## Sample Test Steps
1. Deploy contract with Farmer (Account A) and specify Distributor (Account B).
2. Farmer calls `registerProduct()`.
3. Farmer calls `transferToDistributor()`.
4. Switch to Account B, call `markAsDelivered()`.
5. Call `getProductHistory()` to see the audit trail.
