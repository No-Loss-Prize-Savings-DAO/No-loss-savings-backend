// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol"; // Import ERC721URIStorage
import "@openzeppelin/contracts/access/Ownable.sol";

contract NFTContract is ERC721URIStorage, Ownable { // Inherit from ERC721URIStorage
    uint256 private _tokenIdCounter;
    address savingsContractAddress;
    string _tokenURI = "https://aquamarine-famous-penguin-727.mypinata.cloud/ipfs/QmeeFQsJtzLtMBBNmcKhUmWdNr3ToEotdJmEs5YGpedYss";

    constructor() ERC721("DAO Membership NFT", "DAONFT") Ownable(msg.sender) {}

    function bindAddress(address _savingsContractAddress) external onlyOwner() {
        savingsContractAddress = _savingsContractAddress;
    }

    function mint(address to) public returns (uint256) {
        require(msg.sender == savingsContractAddress, "Only savings contract can call this function");
        uint256 newTokenId = _tokenIdCounter + 1; // Increment tokenId
        _mint(to, newTokenId);
        _setTokenURI(newTokenId, _tokenURI); // Set metadata URI for the token
        _tokenIdCounter = newTokenId; // Update tokenId counter
        return newTokenId;
    }

    function burn(uint256 tokenId) public {
        require(msg.sender == savingsContractAddress, "Only savings contract can call this function");
        _burn(tokenId);
    }
}