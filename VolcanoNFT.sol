// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract VolcanoNFT is ERC721URIStorage, Ownable {
    uint maxSupply = 10_000;
    
    uint256 public currentTokenId = 0;
    
    struct TokenData {
        uint256 tokenId;
        uint256 createdTime;
        string tokenUri;
        bool explicit;
    }
    
    mapping(address=>TokenData[]) public holdings;
    
    constructor() ERC721("Volcano NFTs", "VOL") {}
    
    
    //----------------------------------------------------------
    
    
    function mint(string calldata ipfsCid) public {
        _addTokenData(_msgSender(), TokenData({
            tokenId: currentTokenId,
            createdTime: block.timestamp,
            tokenUri: ipfsCid,
            explicit: true
        }));
        
        _safeMint(_msgSender(), currentTokenId);
        
        _setTokenURI(currentTokenId, ipfsCid);
        
        currentTokenId += 1;
    }
    
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public override {
        super.safeTransferFrom(from, to, tokenId);
        TokenData memory td = getTokenData(from, tokenId);
        require(td.explicit==true, "Token data doesn't exist, this should never happen");
        _removeTokenData(tokenId, from);
        _addTokenData(to, td);
    }
    
    function burn(uint256 id) public {
        require(_msgSender()==ownerOf(id), "Sender not authorized to burn this token!");
        
        _removeTokenData(id, _msgSender());
        
        _burn(id);
    }
    
    
    //----------------------------------------------------------
    
    
    function _addTokenData(address owner, TokenData memory td) internal {
         holdings[owner].push(td);
    }
    
    function getTokenData(address owner, uint256 tokenId) public view returns (TokenData memory) {
        for(uint256 i = 0; i < holdings[owner].length; i++) {
            if(holdings[owner][i].tokenId==tokenId) {
                return holdings[owner][i];
            }
        }
        
        revert('Not found');
    }
    
    function _removeTokenData(uint256 tokenId, address owner) internal {
        for(uint256 i = 0; i < holdings[owner].length; i++) {
            if(holdings[owner][i].tokenId==tokenId) {
                if(holdings[owner].length > 1) {
                    holdings[owner][i] = holdings[owner][holdings[owner].length-1];
                }
                
                holdings[owner].pop();
                
                return;
            }
        }
    }
    
    
}