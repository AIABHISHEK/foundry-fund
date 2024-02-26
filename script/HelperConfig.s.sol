// SPDX-License-Identifier: MIT

//deploy the mocks when we are on a local anvil chain
// keep track of contract address across different chains
// Seploia ETH/USD
//Mainnet ETH/USD

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {

    uint8 public constant DECIMALS = 8;
    uint256 public constant INITIAL_ANSWER = 2000e8;
    // we are on anvil we deploy the mocks
    // otherwise, grab the existing address from the live network
    NetworkConfig public activeNetworkConfig;
    struct NetworkConfig {
        address priceFeed; //ETH/USD pricefeed
    }

    constructor() {
        if (block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaConfig();
        } else if (block.chainid == 1) {
            activeNetworkConfig = getAnvilConfig();
        } else {
            activeNetworkConfig = getAnvilConfig();
        }
    }

    function getSepoliaConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory config = NetworkConfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
        return config;
    }

    function getAnvilConfig() public returns (NetworkConfig memory) {
        //price feed address

        //1. Deploy the mocks
        //2. Return the mock address

        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(8, 2000e8);
        vm.stopBroadcast();
        NetworkConfig memory config = NetworkConfig({
            priceFeed: address(mockPriceFeed)
        });
        return config;
    }
}