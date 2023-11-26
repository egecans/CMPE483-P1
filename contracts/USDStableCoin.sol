// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract USDStableCoin is ERC20, Ownable {

    constructor() ERC20("USD Stable Coin", "USDS") {
        _mint(msg.sender, 1000000 * 10 ** decimals()); // Mint initial supply (1,000,000 USDS)
    }
    
}
