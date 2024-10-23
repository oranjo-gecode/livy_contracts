// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./LivyStamp.sol";

contract LivyFactory {
    // Keep track of all deployed collections
    address[] public deployedCollections;

    event CollectionCreated(address collectionAddress, address owner);

    // Function to create a new POAP collection
    function createPOAPCollection(
        string memory name,
        string memory symbol
    ) public {
        // Create a new instance of the Livy contract
        LivyStamp newCollection = new LivyStamp(
            name,
            symbol,
            msg.sender,
            msg.sender,
            msg.sender
        );

        // Store the address of the deployed collection
        deployedCollections.push(address(newCollection));

        // Emit event
        emit CollectionCreated(address(newCollection), msg.sender);
    }

    // Function to retrieve all collections
    function getAllCollections() public view returns (address[] memory) {
        return deployedCollections;
    }
}
