// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import "solidity/contracts/MyContract.sol";

import {ILayerServiceManager} from "@layer/interfaces/ILayerServiceManager.sol";

contract Deploy is Script {
    function run(string calldata mnemonic, string calldata serviceManagerAddr) external {
        (address deployerAddr, ) = deriveRememberKey(mnemonic, 0);

        vm.startBroadcast(deployerAddr);

        new MyContract(deployerAddr, ILayerServiceManager(vm.parseAddress(serviceManagerAddr)));

        vm.stopBroadcast();
    }
}