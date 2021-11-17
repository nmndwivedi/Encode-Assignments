// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract VolcanoCoin3 is ERC20("Volcano Coin", "VLC"), Ownable {
    uint maxSupply = 10_000;
    
    struct TransferRecord {
        address to;
        uint256 amount;
    }
    
    mapping(address=>TransferRecord[]) public record;
    
    constructor() {
        _mint(msg.sender, maxSupply);
    }
    
    function mintNewTokens(uint256 amount) public onlyOwner {
        _mint(msg.sender, amount);
    }
    
    function transfer(address recipient, uint256 amount) public override returns (bool) {
        _createRecord(_msgSender(), recipient, amount);
        _transfer(_msgSender(), recipient, amount);
        return true;
    }
    
    function _createRecord(address fromAddr, address toAddr, uint256 amount) private {
        record[fromAddr].push(TransferRecord({to: toAddr, amount: amount}));
    }
}