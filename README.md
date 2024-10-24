# Livy Contracts - Monorepo for Smart Contracts

**Livy Contracts** is an open-source repository designed to maintain all of our smart contracts across various use cases. This project is actively maintained as a **monorepo** and built using **Foundry** for compiling, testing, and deploying Solidity smart contracts. The repository serves as the foundation for multiple decentralized applications and blockchain projects, leveraging Solidity native unit testing for robust and scalable contract development.

## 🚀 Project Overview

Livy Contracts provides a unified workspace for smart contract development with reusable modules, ensuring that all contracts are kept in a single repository. While the long-term vision involves multiple projects and use cases, this repository currently focuses on validating off-chain purchase events via **Chainlink external adapters** before minting a **Stamp (Proof of Attendance)**, ensuring trust and verification of user actions before blockchain interaction.

This project is part of an active **Hackathon**, where we aim to deliver secure and scalable smart contract solutions with the community's feedback and contributions.

## ✨ Key Features

- **Monorepo Architecture**: Centralized repository for multiple smart contracts, reducing duplication and improving code reuse.
- **Solidity Native Unit Testing**: All contracts are rigorously tested using Foundry's built-in testing suite.
- **Chainlink Integration**: Seamless interaction with Chainlink oracles for off-chain data validation before minting on-chain assets like Stamps.
- **Stamp Minting**: Implements secure logic for Stamp token distribution after off-chain validation.
- **Open Source Principles**: Actively maintained with full transparency and community involvement.

## 💡 Use Case Example: Chainlink-Powered Stamp Validation

One of the primary use cases within this repository is a **Stamp minting system** that leverages a proxy contract to perform off-chain validation via Chainlink before minting a Stamp token on-chain.

### Flow:

1. A user initiates a transaction (e.g., an event participation or purchase).
2. The proxy smart contract interacts with a Chainlink oracle to validate the transaction off-chain.
3. After validation, the smart contract mints a Stamp token on the Ethereum blockchain for the user.

This approach ensures that only valid users (i.e., those who meet certain off-chain criteria) are able to mint Stamps, providing transparency and trust to both users and event organizers.

## 📦 Project Structure

The repository is structured as a monorepo using **Foundry**. Each contract resides in its own directory, and shared modules are placed under a common directory for reuse.

```bash
livy_contracts/
│
├── src/                   # Source code for all smart contracts
│   ├── Livy.sol  # Proxy contract for NFT validation using Chainlink
│   └── ...                 # More contracts to be added
│
├── lib/                    # Foundry libraries (e.g., Chainlink, OpenZeppelin)
│
├── test/                   # Solidity unit tests for each contract
│   ├── Livy.t.sol
│   └── ...                 # More tests to be added
│
└── README.md               # Project documentation
```

## 👥 Contributing

We encourage the community to contribute to this project! Whether it’s fixing bugs, proposing new features, or improving documentation, your input is valuable. Follow these steps to get started:

1. Fork the repository.
2. Create a new branch (`git checkout -b feature/my-feature`).
3. Make your changes and commit them (`git commit -am 'Add new feature'`).
4. Push the branch (`git push origin feature/my-feature`).
5. Open a Pull Request.

## 📄 License

This project is licensed under the **MIT License**.

## 🏆 Hackathon Goals

As part of this Hackathon, we aim to:

- Deliver a complete and secure NFT validation system using Chainlink oracles.
- Showcase the modular design of our smart contracts, enabling future expansion.
- Foster community engagement through contributions and open feedback.

Stay tuned for more updates as we continue to develop this repository during the Hackathon!

## 🙌 Acknowledgments

- **Chainlink** for enabling secure off-chain data validation.
- **Foundry** for providing a robust framework for Solidity development.
- **The OpenZeppelin team** for their libraries that power secure smart contracts.

If you have any questions or suggestions, feel free to open an issue or contact us directly. We look forward to your contributions!

## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

- **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
- **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
- **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
- **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```
