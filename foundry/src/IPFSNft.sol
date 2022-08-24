// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract IPFSNft is ERC721URIStorage{
    uint256 private nft_tokencounter;
    string public constant TOKEN_URI = "ipfs://QmPT14g8u2BrsZnLU2eQp7jy5Dwb3LZ2Wfvj53Ti4dX573/astronaut.json"; 

    constructor() ERC721("IPFS NFT","IN"){
        
    }

    function mintUpCountNft() public returns (uint256){
        _mintSafe(msg.sender, nft_tokencounter);
        nft_tokencounter = nft_tokencounter+1;
        return nft_tokencounter;
    }

    function tokenCounterGet() public view returns (uint256){
        return nft_tokencounter;
    }

    function tokenURI(uint256) public pure override returns (string memory){
        return TOKEN_URI;
    }

    function requestTicket() public returns (uint256 requestID){

    }

    function _mintSafe(address, uint256) private{

    }
}
