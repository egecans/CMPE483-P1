// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MyGovToken is ERC20 {
    // Constructor to initialize the token with a name and symbol
    constructor(uint tokensupply) ERC20("MyGov Token", "MYGOV") {
        // Mint initial supply to the contract deployer
        _mint(address(this), tokensupply); // Example: Mint 1,000 MYGOV tokens
    }

    uint surveyCreationUSDFee =  5; //0.04 ethers in wei
    uint surveyCreationMyGovFee =  2; 
    uint projectCreationUSDFee =  50; //0.1 ethers in wei
    uint ProjectCreationMyGovFee = 5; // in MyGov TOKEN 
}

