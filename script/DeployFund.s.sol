// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/Fund.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployFund is Script {
    function run() external returns (FundMe) {
        HelperConfig helperConfig = new HelperConfig();
        //anything before helper config is not considered as real transaction so no gas fees 
        address ethUSDPriceFeed = helperConfig.activeNetworkConfig();
        vm.startBroadcast();
        FundMe fundMe = new FundMe(ethUSDPriceFeed);
        vm.stopBroadcast(); 
        return fundMe;
    }
}