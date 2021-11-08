// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Score {
    address owner;
    mapping(address => uint256) scores;

    event ScoreSet(address, uint256);
    event ResetScore(address);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Sender not authorized.");
        _;
    }

    function getScoreFor(address _address) public view returns (uint256) {
        return scores[_address];
    }

    function setScore(uint256 _score) public {
        scores[msg.sender] = _score;

        emit ScoreSet(msg.sender, _score);
    }

    function resetScoreFor(address _address) public onlyOwner {
        scores[_address] = 0;

        emit ResetScore(_address);
    }
}
