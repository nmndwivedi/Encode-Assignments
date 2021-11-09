// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract VolcanoCoin {
    uint totalSupply = 10_000;
    address owner;
    
    event SupplyChanged(uint);
    
    constructor() {
        owner = msg.sender;
    }
    
    modifier onlyOwner() {
        require(msg.sender==owner, "Not Authorized");
        _;
    }
    
    function getTotalSupply() public view returns (uint) {
        return totalSupply;
    }
    
    function increaseTotalSupply(uint _increaseAmount) public onlyOwner {
        totalSupply += _increaseAmount;
        
        emit SupplyChanged(totalSupply);
    }
}