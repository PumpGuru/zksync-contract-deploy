/**
 *Submitted for verification at basescan.org on 2024-07-13
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

interface IERC20 {
    function transfer(address to, uint256 value) external returns (bool);
    function transferFrom(address from, address to, uint256 value) external returns (bool);
}

contract Disperse {
    function disperseEther(address[] memory recipients, uint256[] memory values) external payable {
        require(recipients.length == values.length, "Recipients and values length mismatch");

        uint256 totalValue = 0;
        for (uint256 i = 0; i < values.length; i++) {
            totalValue += values[i];
        }
        require(totalValue <= msg.value, "Insufficient ETH sent");

        for (uint256 i = 0; i < recipients.length; i++) {
            if(values[i] <= 0) continue;
            (bool success, ) = recipients[i].call{ value: values[i] }("");
            require(success, "Transfer failed");
        }

        // Return any remaining balance to the sender
        uint256 balance = address(this).balance;
        if (balance > 0) {
            (bool success, ) = msg.sender.call{ value: balance }("");
            require(success, "Transfer to sender failed");
        }
    }

    function disperseToken(IERC20 token, address[] memory recipients, uint256[] memory values) external {
        uint256 total = 0;
        uint256 i;
        for (i = 0; i < recipients.length; i++)
            total += values[i];
        require(token.transferFrom(msg.sender, address(this), total));
        for (i = 0; i < recipients.length; i++)
            require(token.transfer(recipients[i], values[i]));
    }

    function disperseTokenSimple(IERC20 token, address[] memory recipients, uint256[] memory values) external {
        for (uint256 i = 0; i < recipients.length; i++)
            require(token.transferFrom(msg.sender, recipients[i], values[i]));
    }
    
    receive() external payable {}
}