// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@chainlink/contracts/v0.8/ChainlinkClient.sol";

interface ILivyMintable is IERC721 {
    function mint(address to, uint256 tokenId) external;
}

contract LivyPassport is ChainlinkClient, Ownable {
    using Chainlink for Chainlink.Request;
    ILivyMintable public poapContract;
    address public oracle;
    bytes32 public jobId;
    uint256 public fee;
    uint64 private s_subscriptionId;

    mapping(bytes32 => address) public requestIdToUser;

    event MintingFailed(address user, uint256 tokenId, string reason);

    constructor(
        address _owner,
        address _oracle,
        address _poapContract,
        address _link,
        bytes32 _jobId,
        uint256 _fee
    ) ChainlinkClient() Ownable(_owner) {
        _setChainlinkToken(_link);
        _setChainlinkOracle(_oracle);
        poapContract = ILivyMintable(_poapContract);
        oracle = _oracle;
        jobId = _jobId;
        fee = _fee;
    }

    function requestValidation(
        string memory transactionId,
        address user
    ) public onlyOwner returns (bytes32) {
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
            try poapContract.mint(user, tokenId) {
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
