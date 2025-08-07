// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CertificateIssuer {

    address public owner;

    struct Certificate {
        string recipientName;
        string courseName;
        uint256 dateIssued;
        bool isIssued;
    }

    mapping(address => Certificate) public certificates;

    event CertificateIssued(address indexed recipient, string recipientName, string courseName, uint256 dateIssued);

    modifier onlyOwner() {
        require(msg.sender == owner, "You are not authorized.");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function issueCertificate(address recipient, string memory recipientName, string memory courseName) public onlyOwner {
        certificates[recipient] = Certificate({
            recipientName: recipientName,
            courseName: courseName,
            dateIssued: block.timestamp,
            isIssued: true
        });

        emit CertificateIssued(recipient, recipientName, courseName, block.timestamp);
    }

    function verifyCertificate(address recipient) public view returns (bool) {
        return certificates[recipient].isIssued;
    }

    function getCertificate(address recipient) public view returns (string memory, string memory, uint256) {
        require(certificates[recipient].isIssued, "No certificate found for this address.");
        Certificate memory cert = certificates[recipient];
        return (cert.recipientName, cert.courseName, cert.dateIssued);
    }
}
