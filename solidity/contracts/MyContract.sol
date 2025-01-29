// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol"; 

contract MyContract is ERC20 {
    constructor() ERC20("LayerToken", "ELYR") {
    }

    function handleAddPayload(bytes calldata data, bytes calldata) external {
    }
}