//SPDX-License-Identifier:MIT

pragma solidity ^0.8.18;

import {ERC721} from "lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";

contract BasicNft is ERC721 {
    uint256 private s_tokenCounter;

    mapping(uint256 => string) private s_tokenIdToUri;

    /**
     * 构造函数
     */
    constructor() ERC721("ME", "M") {
        s_tokenCounter = 0;
    }

    /**
     * 铸造函数
     */
    function mintNft(string memory tokenUri) public {
        s_tokenIdToUri[s_tokenCounter] = tokenUri;
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenCounter++;
    }

    /**
     * getter 函数
     */
    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        return s_tokenIdToUri[tokenId];
    }

    function getTokenId() external view returns (uint256) {
        return s_tokenCounter;
    }
}
