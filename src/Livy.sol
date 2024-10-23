// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@chainlink/contracts/v0.8/ChainlinkClient.sol";
import "@openzeppelin/contracts/utils/Pausable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

interface ILivyStampMintable is IERC721 {
    function mint(address to, uint256 tokenId) external;
}

contract Livy is ChainlinkClient, Pausable, AccessControl {
    using Chainlink for Chainlink.Request;
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    ILivyStampMintable public stampContract;
    address public oracle;
    bytes32 public jobId;
    uint256 public fee;

    mapping(bytes32 => address) public requestIdToUser;

    event MintingFailed(address user, uint256 tokenId, string reason);

    constructor(
        address _defaultAdmin,
        address _pauser,
        address _minter,
        address _oracle,
        address _stampContract,
        address _link,
        bytes32 _jobId,
        uint256 _fee
    ) ChainlinkClient() {
        _grantRole(DEFAULT_ADMIN_ROLE, _defaultAdmin);
        _grantRole(PAUSER_ROLE, _pauser);
        _grantRole(MINTER_ROLE, _minter);
        _setChainlinkToken(_link);
        _setChainlinkOracle(_oracle);
        stampContract = ILivyStampMintable(_stampContract);
        oracle = _oracle;
        jobId = _jobId;
        fee = _fee;
    }

    function pause() public onlyRole(PAUSER_ROLE) {
        _pause();
    }

    function unpause() public onlyRole(PAUSER_ROLE) {
        _unpause();
    }

    function requestValidation(
        string memory transactionId,
        address user
    ) public onlyRole(MINTER_ROLE) returns (bytes32) {
        Chainlink.Request memory req = _buildChainlinkRequest(
            jobId,
            address(this),
            this.fulfillValidation.selector
        );
        req._add("get", transactionId);
        bytes32 requestId = _sendChainlinkRequest(req, fee);
        requestIdToUser[requestId] = user;
        return requestId;
    }

    function fulfillValidation(
        bytes32 _requestId,
        uint256 validationSuccess
    ) public recordChainlinkFulfillment(_requestId) {
        address user = requestIdToUser[_requestId];
        require(user != address(0), "Invalid request ID");

        if (validationSuccess == 1) {
            uint256 tokenId = _generateTokenId(user);
            try stampContract.mint(user, tokenId) {
                // Minting successful
            } catch Error(string memory reason) {
                // Log the error or handle it appropriately
                emit MintingFailed(user, tokenId, reason);
            } catch (bytes memory /*lowLevelData*/) {
                // Log the error or handle it appropriately
                emit MintingFailed(user, tokenId, "Unknown error");
            }
        }
    }

    function _generateTokenId(address user) internal view returns (uint256) {
        return uint256(keccak256(abi.encodePacked(user, block.timestamp)));
    }

    function getOracle() public view returns (address) {
        return oracle;
    }
}
