// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol"; 

contract MyContract is ERC20 {
    struct Message {
        string operator_id;
        string message;
    }

    event SendTelegram(string operator_id, string message);

    constructor(address sender) ERC20("LayerToken", "ELYR") {
        _mint(sender, 10000000000000000000000000000);
    }

    function handleSignedData(bytes calldata data, bytes calldata) external {
        Message memory message = abi.decode(data, (Message));

        emit SendTelegram(message.operator_id, message.message);
    }
}