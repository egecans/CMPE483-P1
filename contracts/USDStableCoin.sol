// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract USDStableCoin is ERC20 {
    constructor() ERC20("USD Stable Coin", "USDSC") {
        
        // Mint initial supply to the contract deployer
         _mint(address(this), 10000); // Example: Mint 1,000 MYGOV tokens
    }

    function faucet() public {
        this.transfer(msg.sender, 1);
    }
    
}
