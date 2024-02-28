// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "../src/Fund.sol";

contract FundFundMe is Script {
    function fundFundMe(address mostRecentdeployed) public {
        uint256 SEND_VALUE = 0.1 ether;
        vm.startBroadcast();
        FundMe(payable(mostRecentdeployed)).fund{value: SEND_VALUE}();
        vm.stopBroadcast();
        console.log("Funded Fund Me");
    }
    function run() external {
        address mostrecntlyDeploed = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);
        fundFundMe(mostrecntlyDeploed);
    }
}

contract WithdrawFundMe is Script {
    function withdrawFundMe(address mostRecentdeployed) public {
        uint256 SEND_VALUE = 0.1 ether;
        vm.startBroadcast();
        FundMe(payable(mostRecentdeployed)).withdraw();
        vm.stopBroadcast();
        console.log("Funded Fund Me");
    }
    function run() external {
        address mostrecntlyDeploed = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);
        withdrawFundMe(mostrecntlyDeploed);
    }
}