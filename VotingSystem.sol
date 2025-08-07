// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VotingSystem {

    struct Candidate {
        string name;
        uint voteCount;
    }

    address public admin;
    Candidate[] public candidates;
    mapping(address => bool) public hasVoted;

    constructor() {
        admin = msg.sender; 
    }

    //Add candidate
    function addCandidate(string memory _name) public {
        require(msg.sender == admin, "Only admin can add candidates");
        candidates.push(Candidate(_name, 0));
    }

    // التصويت لمرشح
    function vote(uint _index) public {
        require(!hasVoted[msg.sender], "You have already voted");
        require(_index < candidates.length, "Invalid candidate");

        candidates[_index].voteCount += 1;
        hasVoted[msg.sender] = true;
    }

    
    function getCandidatesCount() public view returns (uint) {
        return candidates.length;
    }

    
    function getCandidate(uint _index) public view returns (string memory, uint) {
        require(_index < candidates.length, "Invalid candidate");
        Candidate memory c = candidates[_index];
        return (c.name, c.voteCount);
    }
}
