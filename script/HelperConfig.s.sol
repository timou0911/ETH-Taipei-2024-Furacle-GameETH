// SPDX-Licnese-Identifier: MIT

pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {PriceGuess} from "../src/PriceGuess.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {
    struct NetworkConfig {
        address dataFeed;
    }

    NetworkConfig public activeNetworkConfig;
    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_PRICE = 2000e8;

    constructor() {
        if (block.chainid == 11155420) {
            activeNetworkConfig = getOPSepoliaConfig();
        } else {
            activeNetworkConfig = getOrCreateAnvilConfig();
        }
    }

    function getOPSepoliaConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory OPSepoliaConfig = NetworkConfig({
            dataFeed: 0x61Ec26aA57019C486B10502285c5A3D4A4750AD7
        });
        return OPSepoliaConfig;
    }

    function getOrCreateAnvilConfig() public returns (NetworkConfig memory) {
        if (activeNetworkConfig.dataFeed != address(0)) {
            return activeNetworkConfig;
        }
        // 1. Deploy the mocks
        // 2. Return the mock address
        vm.startBroadcast();
        // Deploy mock on the Anvil
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(
            DECIMALS,
            INITIAL_PRICE
        );
        vm.stopBroadcast();

        NetworkConfig memory anvilConfig = NetworkConfig({
            dataFeed: address(mockPriceFeed)
        });

        return anvilConfig;
    }
}
