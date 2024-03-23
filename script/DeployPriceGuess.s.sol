// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {HelperConfig} from "./HelperConfig.s.sol";
import {PriceGuess} from "../src/PriceGuess.sol";

contract DeployPriceGuess is Script {
    PriceGuess public priceGuess;

    function run() public returns (PriceGuess) {
        HelperConfig helperConfig = new HelperConfig();
        address priceFeed = helperConfig.activeNetworkConfig();

        vm.startBroadcast();
        priceGuess = new PriceGuess(priceFeed);
        vm.stopBroadcast();
        return priceGuess;
    }
}
