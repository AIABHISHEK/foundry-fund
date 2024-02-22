// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/Fund.sol";

contract DeployFund is Script {
    function run() external {
        vm.startBroadcast();
        new FundMe();
        vm.stopBroadcast(); 
    }
}