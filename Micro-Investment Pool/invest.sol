// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MicroInvestmentPool {
    address public admin;
    uint public totalInvestment;

    mapping(address => uint) public investments;

    event Invested(address indexed investor, uint amount);
    event Withdrawn(address indexed investor, uint amount);
    event PoolClosed(uint totalAmount);

    constructor() {
        admin = msg.sender;
    }

    function invest() public payable {
        require(msg.value > 0, "Investment must be greater than zero");
        investments[msg.sender] += msg.value;
        totalInvestment += msg.value;
        emit Invested(msg.sender, msg.value);
    }

    function withdrawInvestment() public {
        uint amount = investments[msg.sender];
        require(amount > 0, "No funds to withdraw");
        investments[msg.sender] = 0;
        totalInvestment -= amount;
        payable(msg.sender).transfer(amount);
        emit Withdrawn(msg.sender, amount);
    }

    function closePool() public {
        require(msg.sender == admin, "Only admin can close the pool");
        emit PoolClosed(totalInvestment);
        selfdestruct(payable(admin));
    }
}
