// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import {LivyStamp} from "../src/LivyStamp.sol";

contract LivyStampTest is Test {
    LivyStamp public livyStamp;
    address public defaultAdmin;
    address public pauser;
    address public minter;
    address public user;

    function setUp() public {
        defaultAdmin = address(1);
        pauser = address(2);
        minter = address(3);
        user = address(4);

        livyStamp = new LivyStamp(
            "LivyStamp",
            "LIVY",
            "ipfs://example",
            defaultAdmin,
            pauser,
            minter
        );
    }

    function testInitialState() public view {
        assertEq(livyStamp.name(), "LivyStamp");
        assertEq(livyStamp.symbol(), "LIVY");
        assertTrue(
            livyStamp.hasRole(livyStamp.DEFAULT_ADMIN_ROLE(), defaultAdmin)
        );
        assertTrue(livyStamp.hasRole(livyStamp.PAUSER_ROLE(), pauser));
        assertTrue(livyStamp.hasRole(livyStamp.MINTER_ROLE(), minter));
    }

    function testPause() public {
        vm.prank(pauser);
        livyStamp.pause();
        assertTrue(livyStamp.paused());
    }

    function testUnpause() public {
        vm.startPrank(pauser);
        livyStamp.pause();
        livyStamp.unpause();
        vm.stopPrank();
        assertFalse(livyStamp.paused());
    }

    function testSafeMint() public {
        vm.prank(minter);
        livyStamp.safeMint(user);
        assertEq(livyStamp.balanceOf(user), 1);
        assertEq(livyStamp.tokenURI(0), "ipfs://example");
    }

    function testFailPauseUnauthorized() public {
        vm.prank(user);
        livyStamp.pause();
    }

    function testFailUnpauseUnauthorized() public {
        vm.prank(user);
        livyStamp.unpause();
    }

    function testFailMintUnauthorized() public {
        vm.prank(user);
        livyStamp.safeMint(user);
    }

    function testFailMintWhenPaused() public {
        vm.prank(pauser);
        livyStamp.pause();

        vm.prank(minter);
        livyStamp.safeMint(user);
    }

    function testSupportsInterface() public view {
        assertTrue(livyStamp.supportsInterface(type(IERC721).interfaceId));
        assertTrue(
            livyStamp.supportsInterface(type(IERC721Enumerable).interfaceId)
        );
        assertTrue(
            livyStamp.supportsInterface(type(IERC721Metadata).interfaceId)
        );
        assertTrue(
            livyStamp.supportsInterface(type(IAccessControl).interfaceId)
        );
    }
}
