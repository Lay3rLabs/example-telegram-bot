// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {deriveRememberKey} from "forge-std/Utils.sol";
import "solidity/contracts/MyContract.sol";

contract Deploy is Script {
    function run(string calldata mnemonic) external {
        (address deployerAddr, uint256 deployerPrivateKey) = deriveRememberKey(mnemonic, 0);

        vm.startBroadcast(deployerAddr);

        console.log("%s", deployerAddr);
        // MyContract myContract = new MyContract();

        vm.stopBroadcast();
    }
}