// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./interfaces/IDAOGovernance.sol";
import "./interfaces/IComplianceDatabase.sol";

contract RegulatoryCompliance is Ownable {
    IDAOGovernance public daoGovernance;
    address public savingsContractAddress;
    IComplianceDatabase public complianceDatabase;
    mapping(address => bool) public agreementStatus;

    event AgreementSent(address indexed user, string key);

    constructor(address _complianceDatabaseAddress) Ownable(msg.sender) {
        complianceDatabase = IComplianceDatabase(_complianceDatabaseAddress);
    }

    // Function to add the DAO Governance address
    function bindAddresses(address _daoGovernanceAddress, address _savingsContractAddress) external onlyOwner {
        daoGovernance = IDAOGovernance(_daoGovernanceAddress);
        savingsContractAddress = _savingsContractAddress;
    }

    function sendAgreements(string calldata key) external {
        require(msg.sender == savingsContractAddress, "Only savings contract can call this function");
        complianceDatabase.getDAORegulation(key);
        emit AgreementSent(msg.sender, key);
    }

    function acceptAgreement() external {
        require(!agreementStatus[msg.sender], "Agreement already accepted");
        agreementStatus[msg.sender] = true;
        daoGovernance.proposeMembership(msg.sender);
    }
}