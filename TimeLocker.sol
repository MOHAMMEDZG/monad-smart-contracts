// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract TimeLocker {
    struct Deposit {
        uint amount;
        uint unlockTime;
    }

    mapping(address => Deposit) public deposits;

    event Deposited(address indexed user, uint amount, uint unlockTime);
    event Withdrawn(address indexed user, uint amount);

    function deposit(uint _lockTimeInSeconds) external payable {
        require(msg.value > 0, "Must send ETH");
        require(_lockTimeInSeconds > 0, "Lock time must be positive");

        deposits[msg.sender] = Deposit({
            amount: msg.value,
            unlockTime: block.timestamp + _lockTimeInSeconds
        });

        emit Deposited(msg.sender, msg.value, block.timestamp + _lockTimeInSeconds);
    }

    function withdraw() external {
        Deposit memory userDeposit = deposits[msg.sender];
        require(userDeposit.amount > 0, "No deposit");
        require(block.timestamp >= userDeposit.unlockTime, "Still locked");

        uint amount = userDeposit.amount;
        deposits[msg.sender].amount = 0;

        payable(msg.sender).transfer(amount);
        emit Withdrawn(msg.sender, amount);
    }

    function getTimeLeft() external view returns (uint) {
        if (block.timestamp >= deposits[msg.sender].unlockTime) return 0;
        return deposits[msg.sender].unlockTime - block.timestamp;
    }
}
