// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";



contract Nft is ERC721, Ownable {
    uint256 public mintPrice;
    uint256 public totalSupply;
    uint256 public maxSupply;
    uint256 public maxPerWallet;
    
    bool public isPublicMintEnabled;
    
    string internal baseTokenUri;
    
    address payable public withdrawWallet;

    mapping (address => uint256) public walletMints;    


    constructor() payable ERC721('NftName', 'NftSymb') {
        mintPrice = 0.02 ether;
        totalSupply = 0;
        maxSupply = 1000;
        maxPerWallet = 3;
        withdrawWallet = payable(0x59ABDFCc700DfB6fFf671B2198B26107f6AFE036);
    }


    function setIsPublicMintEnabled(bool isPublicMintEnabled_) external onlyOwner {
        isPublicMintEnabled = isPublicMintEnabled_;
    }


    function setBaseTokenUri(string calldata baseTokenUri_) external onlyOwner {
        baseTokenUri = baseTokenUri_;
    }


    function tokenURI(uint256 tokenId_) public view override returns(string memory) {
        require(_exists(tokenId_), "Token address does not exist");
        return string(abi.encodePacked(baseTokenUri, Strings.toString(tokenId_),".json"));
    }


    function withdraw() external onlyOwner {
        ( bool success, ) = withdrawWallet.call{ value: address(this).balance }('');
        require(success, "withdraw failed");
    }


    function mint(uint256 _quantity) public payable {
        require(isPublicMintEnabled, 'Minting not enabled');
        require(msg.value == _quantity * mintPrice, "Wrong mint value");
        require(totalSupply + _quantity <= maxSupply, "Sold out");
        require(walletMints[msg.sender] + _quantity <= maxPerWallet, "Exceed max wallet");


        for (uint i = 0; i < _quantity; i++) {
            uint256 newTokenId = totalSupply + 1;
            totalSupply++;
            _safeMint(msg.sender, newTokenId);
        }
    }
}
