// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ILayerServiceManager} from "@layer/interfaces/ILayerServiceManager.sol";
import {ILayerServiceHandler} from "@layer/interfaces/ILayerServiceHandler.sol";

contract MyContract is ERC20,ILayerServiceHandler {
    struct Message {
        string operator_id;
        string message;
    }

    event SendTelegram(string operator_id, string message);

    ILayerServiceManager private _serviceManager;

    constructor(address sender, ILayerServiceManager serviceManager) ERC20("LayerToken", "ELYR") {
        _serviceManager = serviceManager;
        _mint(sender, 10000000000000000000000000000);
    }

    function handleSignedData(bytes calldata data, bytes calldata signature) external {
        _serviceManager.validate(data, signature);

        Message memory message = abi.decode(data, (Message));

        emit SendTelegram(message.operator_id, message.message);
    }
}