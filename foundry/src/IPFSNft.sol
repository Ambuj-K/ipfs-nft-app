// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

//Error Types
error IPFSNft__RangeOutOFBounds(); 
error IPFSNft__LowETHSent();
error IPFSNft__TransferFailed();

contract IPFSNft is ERC721URIStorage, VRFConsumerBaseV2, Ownable{
    //Chainlink Variables
    VRFCoordinatorV2Interface private immutable i_vrfCoordinatorV2;
    uint64 private immutable i_subscriptionId;
    bytes32 private immutable i_gasLane;
    uint32 private immutable i_callbackGasLimit;
    uint16 private constant REQUEST_CONFIRMATIONS = 3;
    uint32 private constant NUM_WORDS =1;

    //Additionals
    mapping (uint256=> address) internal requestIDToCaller;
    string[] internal i_artUris;
    uint256 internal i_mintCost;
    
    //NFT
    uint256 private nft_tokencounter;
    uint256 internal constant MAX_PERCENTAGE_VALUE = 100;

    //ENUM BASED ON DECREASING ARTISTIC VALUE INCREASING PROBABILITY
    enum ArtVal{
        Astronaut,
        Flowers,
        Wings
    }

    //Event Handling
    event requestedNFT(uint256 indexed requestId, address requester);
    event mintedNFT(ArtVal artVal, address minter);

    constructor(
        address vrfCoordinatorV2, 
        uint64 subscriptionId, 
        bytes32 gasLane, 
        uint32 callbackGasLimit,
        string[3] memory artUris,
        uint256 mintCost
        ) 
    ERC721("IPFS NFT","IN") 
    VRFConsumerBaseV2(vrfCoordinatorV2){
        i_vrfCoordinatorV2 = VRFCoordinatorV2Interface(vrfCoordinatorV2);
        i_subscriptionId = subscriptionId;
        i_gasLane = gasLane;
        i_callbackGasLimit = callbackGasLimit;
        i_artUris = artUris;
        i_mintCost = mintCost;
    }

    function withdraw() public onlyOwner {
        uint256 amount = address(this).balance;
        (bool success,) = payable(msg.sender).call{value: amount}("");
        if(!success) { revert IPFSNft__TransferFailed();}
    }

    function requestNft() public payable returns (uint256 requestID) {
        if (msg.value < i_mintCost) {
            revert IPFSNft__LowETHSent();
        }
        requestID = i_vrfCoordinatorV2.requestRandomWords(
            i_gasLane,
            i_subscriptionId,
            REQUEST_CONFIRMATIONS,
            i_callbackGasLimit,
            NUM_WORDS
        );
        requestIDToCaller[requestID] = msg.sender;
        emit requestedNFT(requestID, msg.sender);
    }

    function fulfillRandomWords(uint256 requestID, uint256[] memory randomWords) internal override {
        address nftOwner = requestIDToCaller[requestID];
        uint256 tokenId = nft_tokencounter;
        nft_tokencounter = nft_tokencounter+1;

        uint256 rangeValue = randomWords[0] % MAX_PERCENTAGE_VALUE;
        ArtVal artVal = getArtValuedName(rangeValue);
        _safeMint(nftOwner, tokenId);  
        _setTokenURI(tokenId, i_artUris[uint256(artVal)]);

        emit mintedNFT(artVal, nftOwner);
    }

    function getArtValuedName(uint256 rangeValue) public pure returns (ArtVal){
        uint256 summation = 0;
        uint256[3] memory rangeChanceArray = rangesArrayGetter();
        for(uint256 i=0; i<rangeChanceArray.length; i++){
            if (rangeValue >= summation && rangeValue < summation+rangeChanceArray[i]){
                return ArtVal(i);
            }
            summation += rangeChanceArray[i]; 
        }
        revert IPFSNft__RangeOutOFBounds();
    }

    function rangesArrayGetter() public pure returns (uint256[3] memory){
        return [10,30,MAX_PERCENTAGE_VALUE];
    }

    function mintFreeGetter() public view returns(uint256){
        return i_mintCost;
    }

    function artURIsGetter(uint256 index) public view returns(string memory){
        return i_artUris[index];
    }

    function tokenCounterGetter() public view returns (uint256){
        return nft_tokencounter;
    }
}
