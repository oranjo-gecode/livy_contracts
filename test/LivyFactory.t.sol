// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {LivyFactory} from "../src/LivyFactory.sol";
import {LivyStamp} from "../src/LivyStamp.sol";

contract LivyFactoryTest is Test {
    LivyFactory public livyFactory;
    address public user;

    function setUp() public {
        livyFactory = new LivyFactory();
        user = address(1);
    }

    function testCreateLivyStampCollection() public {
        vm.prank(user);
        livyFactory.createLivyStampCollection("TestCollection", "TEST");

        address[] memory collections = livyFactory.getAllCollections();
        assertEq(collections.length, 1);

        LivyStamp createdCollection = LivyStamp(collections[0]);
        assertEq(createdCollection.name(), "TestCollection");
        assertEq(createdCollection.symbol(), "TEST");
        assertTrue(
            createdCollection.hasRole(
                createdCollection.DEFAULT_ADMIN_ROLE(),
                user
            )
        );
        assertTrue(
            createdCollection.hasRole(createdCollection.PAUSER_ROLE(), user)
        );
        assertTrue(
            createdCollection.hasRole(createdCollection.MINTER_ROLE(), user)
        );
    }

    function testGetAllCollections() public {
        vm.startPrank(user);
        livyFactory.createLivyStampCollection("Collection1", "COL1");
        livyFactory.createLivyStampCollection("Collection2", "COL2");
        vm.stopPrank();

        address[] memory collections = livyFactory.getAllCollections();
        assertEq(collections.length, 2);
    }

    function testEmitCollectionCreatedEvent() public {
        vm.prank(user);

        // Capture the next contract address
        address expectedAddress = computeCreateAddress(
            address(livyFactory),
            vm.getNonce(address(livyFactory))
        );

        vm.expectEmit(true, true, false, true);
        emit LivyFactory.CollectionCreated(expectedAddress, user);

        livyFactory.createLivyStampCollection("EventTest", "EVT");

        address[] memory collections = livyFactory.getAllCollections();
        assertEq(collections.length, 1);
        assertEq(collections[0], expectedAddress);
    }

    function testMultipleCollectionCreation() public {
        for (uint i = 0; i < 5; i++) {
            vm.prank(user);
            livyFactory.createLivyStampCollection(
                string(abi.encodePacked("Collection", vm.toString(i))),
                string(abi.encodePacked("COL", vm.toString(i)))
            );
        }

        address[] memory collections = livyFactory.getAllCollections();
        assertEq(collections.length, 5);

        for (uint i = 0; i < 5; i++) {
            LivyStamp createdCollection = LivyStamp(collections[i]);
            assertEq(
                createdCollection.name(),
                string(abi.encodePacked("Collection", vm.toString(i)))
            );
            assertEq(
                createdCollection.symbol(),
                string(abi.encodePacked("COL", vm.toString(i)))
            );
        }
    }
}
