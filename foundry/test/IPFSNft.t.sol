// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "forge-std/Test.sol";
import "@chainlink/contracts/src/v0.8/mocks/VRFCoordinatorV2Mock.sol";
import "../src/IPFSNft.sol";

interface CheatCodes {
    function deal(address, uint256) external;
    function prank(address) external;
}

contract TestNFTMinter is DSTest {
    CheatCodes constant cheats = CheatCodes(HEVM_ADDRESS);

    address owner;
    address ZERO_ADDRESS = address(0);
    address spender = address(1);
    address user = address(2);


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
    uint256 public requestId;

    function setUp() public {
        BASE_FEE = 25 wei;
        GAS_PRICE_LINK = 30 wei;
        vrfCoordinatorV2Mock = new VRFCoordinatorV2Mock(BASE_FEE, GAS_PRICE_LINK);
        vrfCoordinatorV2Address = address(vrfCoordinatorV2Mock);
        transactionResponse = vrfCoordinatorV2Mock.createSubscription();
        vrfCoordinatorV2Mock.fundSubscription(transactionResponse, 5 wei);
        gasLane= 0x79d3d8832d904592c0bf9818b621522c988bb8b0c05cdc3b15aea1b6e8db0c15;
        callbackGasLimit = 1000 wei;
        mintCost = 10000 wei;
        artUris = [
            "ipfs://QmYgb3tawCnMGPMV4DGFawNznEBzoFNXsZNwvTPDB4mZxc",
            "ipfs://QmRAakxqsTJqGAhd5yd3iip4fEL7KMZanTaxLH9k2wHqND",
            "ipfs://Qmc6qfwny924kLWfoxKpA3VsauFKnBUecm8912RM1DfJbe"
        ];
        ipfsnftObj = new IPFSNft(vrfCoordinatorV2Address,transactionResponse,gasLane,callbackGasLimit,artUris, mintCost);
        vrfCoordinatorV2Mock.addConsumer(transactionResponse, address(ipfsnftObj));
    }

    function testRandomNumberGen() public {
        requestId = ipfsnftObj.requestNft{value: 100000 wei}();
        emit log_uint(requestId);
        assertTrue(true);
    }

}
