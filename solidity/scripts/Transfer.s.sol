// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.16;

import "forge-std/Script.sol";

// Minimal ERC20 interface for transfer
interface IERC20 {
    function transfer(address to, uint256 amount) external returns (bool);
}

contract Transfer is Script {
    /// @notice Transfers ERC20 tokens from a key derived via senderMnemonic to `recipient`.
    /// @param senderMnemonic The mnemonic used to derive the sender's private key
    /// @param tokenString The ERC20 token address in string form
    /// @param recipientString The recipient's address in string form
    /// @param amount The amount of tokens to transfer
    function run(
        string calldata senderMnemonic,
        string calldata tokenString,
        string calldata recipientString,
        uint256 amount
    ) external {
        // Derive sender address & private key from the mnemonic
        (address senderAddr, uint256 senderKey) = deriveRememberKey(senderMnemonic, 0);
        
        // Parse string arguments to address
        address tokenAddress = vm.parseAddress(tokenString);
        address recipientAddress = vm.parseAddress(recipientString);

        // Log for clarity
        console2.log("Sender Address:", senderAddr);
        console2.log("Token Address:", tokenAddress);
        console2.log("Recipient Address:", recipientAddress);
        console2.log("Amount:", amount);

        // Begin broadcasting (transactions will be signed with senderKey)
        vm.startBroadcast(senderKey);

        // Perform the transfer
        bool success = IERC20(tokenAddress).transfer(recipientAddress, amount);
        require(success, "ERC20 transfer failed.");

        vm.stopBroadcast();
    }
}
