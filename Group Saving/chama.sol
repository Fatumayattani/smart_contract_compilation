// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ChamaSavings {
    address public admin;
    uint public cycleTime = 30 days;
    uint public contributionAmount;
    uint public nextPayoutTime;
    address[] public members;
    uint public nextMemberIndex;

    mapping(address => uint) public contributions;

    event MemberJoined(address indexed member);
    event ContributionMade(address indexed member, uint amount);
    event PayoutReleased(address indexed member, uint amount);

    constructor(uint _contributionAmount) {
        admin = msg.sender;
        contributionAmount = _contributionAmount;
        nextPayoutTime = block.timestamp + cycleTime;
    }

    function joinChama() public {
        require(contributions[msg.sender] == 0, "Already a member");
        members.push(msg.sender);
        contributions[msg.sender] = 0;
        emit MemberJoined(msg.sender);
    }

    function contribute() public payable {
        require(msg.value == contributionAmount, "Incorrect contribution amount");
        contributions[msg.sender] += msg.value;
        emit ContributionMade(msg.sender, msg.value);
    }

    function distributePayout() public {
        require(block.timestamp >= nextPayoutTime, "Not yet time for payout");
        require(members.length > 0, "No members in Chama");

        address recipient = members[nextMemberIndex];
        uint amount = address(this).balance;
        payable(recipient).transfer(amount);

        emit PayoutReleased(recipient, amount);

        nextMemberIndex = (nextMemberIndex + 1) % members.length;
        nextPayoutTime = block.timestamp + cycleTime;
    }
}
