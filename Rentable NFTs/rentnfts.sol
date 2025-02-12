// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract RentableNFT is ERC721Enumerable, Ownable {
    struct Rental {
        address renter;
        uint256 expiry;
    }

    mapping(uint256 => Rental) public rentals;
    mapping(uint256 => uint256) public rentalPrices;

    event NFTListedForRent(uint256 indexed tokenId, uint256 price);
    event NFTRented(uint256 indexed tokenId, address indexed renter, uint256 expiry);
    event NFTUnlisted(uint256 indexed tokenId);
    event FundsWithdrawn(address owner, uint256 amount);

    constructor() ERC721("RentableNFT", "RNFT") {}

    function mintNFT(address to, uint256 tokenId) external onlyOwner {
        _safeMint(to, tokenId);
    }

    function listForRent(uint256 tokenId, uint256 price) external {
        require(ownerOf(tokenId) == msg.sender, "Not the NFT owner");
        require(rentals[tokenId].expiry < block.timestamp, "NFT is currently rented");

        rentalPrices[tokenId] = price;
        emit NFTListedForRent(tokenId, price);
    }

    function rentNFT(uint256 tokenId, uint256 rentalPeriod) external payable {
        require(rentalPrices[tokenId] > 0, "NFT not listed for rent");
        require(rentals[tokenId].expiry < block.timestamp, "NFT is currently rented");
        require(msg.value >= rentalPrices[tokenId], "Insufficient funds");

        // Transfer rental fee to the NFT owner
        address nftOwner = ownerOf(tokenId);
        payable(nftOwner).transfer(msg.value);

        rentals[tokenId] = Rental({
            renter: msg.sender,
            expiry: block.timestamp + rentalPeriod
        });

        emit NFTRented(tokenId, msg.sender, rentals[tokenId].expiry);
    }

    function unlistFromRent(uint256 tokenId) external {
        require(ownerOf(tokenId) == msg.sender, "Not the NFT owner");
        delete rentalPrices[tokenId];

        emit NFTUnlisted(tokenId);
    }

    function getRenter(uint256 tokenId) external view returns (address) {
        if (rentals[tokenId].expiry > block.timestamp) {
            return rentals[tokenId].renter;
        }
        return address(0);
    }

    function withdrawFunds() external onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No funds available");

        payable(owner()).transfer(balance);
        emit FundsWithdrawn(owner(), balance);
    }
}
