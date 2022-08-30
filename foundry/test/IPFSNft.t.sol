// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "forge-std/Test.sol";
import "@chainlink/contracts/src/v0.8/mocks/VRFCoordinatorV2Mock.sol";
import "../src/IPFSNft.sol";

interface CheatCodes {
    function deal(address, uint256) external;
}

contract TestNFTMinter is DSTest {
    IPFSNft public ipfsnftObj;
    VRFCoordinatorV2Mock public vrfCoordinatorV2Mock;
    uint96 public BASE_FEE;
    uint96 public GAS_PRICE_LINK;
    address public vrfCoordinatorV2Address;
    uint64 public transactionResponse;
    bytes32 public gasLane;
    uint32 public callbackGasLimit;
    uint256 public mintCost;
    string[3] public artUris;

    function setUp() public {
        BASE_FEE = 250000000000000000;
        GAS_PRICE_LINK = 1e9;
        vrfCoordinatorV2Mock = new VRFCoordinatorV2Mock(BASE_FEE, GAS_PRICE_LINK);
        vrfCoordinatorV2Address = address(vrfCoordinatorV2Mock);
        transactionResponse = vrfCoordinatorV2Mock.createSubscription();
        gasLane= bytes32(0x79d3d8832d904592c0bf9818b621522c988bb8b0c05cdc3b15aea1b6e8db0c15);
        callbackGasLimit = 2500000;
        mintCost = 12e18;
        artUris = [
            "ipfs://QmYgb3tawCnMGPMV4DGFawNznEBzoFNXsZNwvTPDB4mZxc",
            "ipfs://QmRAakxqsTJqGAhd5yd3iip4fEL7KMZanTaxLH9k2wHqND",
            "ipfs://Qmc6qfwny924kLWfoxKpA3VsauFKnBUecm8912RM1DfJbe"
        ];
        ipfsnftObj = new IPFSNft(vrfCoordinatorV2Address,transactionResponse,gasLane,callbackGasLimit,artUris, mintCost);
    }

    function testRandomNumberGen() public {
        uint256 requestId = ipfsnftObj.requestNft();
        emit log_uint(requestId);
        assertTrue(true);
    }
}
