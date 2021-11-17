// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract VolcanoCoin2 {
    uint totalSupply = 10_000;
    mapping(address=>uint256) balance;
    
    struct TransferRecord {
        address to;
        uint256 amount;
    }
    
    mapping(address=>TransferRecord[]) record;
    
    event TokenTransferExecuted(address from, address to, uint256 amount);
    
    constructor() {
        balance[msg.sender] = totalSupply;
    }
    
    function transfer(address to, uint256 amount) public {
        require(balance[msg.sender]>=amount, "Insufficient Balance");
        balance[msg.sender] -= amount;
        balance[to] += amount;
        
        record[msg.sender].push(TransferRecord({ to: to, amount: amount }));
        
        emit TokenTransferExecuted(msg.sender, to, amount);
    }
    
    function checkBalance(address checkAddress) public view returns (uint256) {
        return balance[checkAddress];
    }
    
    function getTransfers(address checkAddress) public view returns (TransferRecord[] memory) {
        return record[checkAddress];
    }
}