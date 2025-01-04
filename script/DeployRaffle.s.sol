//SPDX-License-Identifier: MIT

pragma solidity 0.8.28;

import {Script} from "lib/forge-std/src/Script.sol";
import {Raffle} from "src/Raffle.sol";

contract DeployRaffle is Script {
    uint256 constant SUBSCRIPTION_ID = 74933923848412446286631760312937529805422951266888367328677380741686525675597;
    uint256 constant INTERVAL = 30;
    uint256 constant ENTERANCE_FEE = 0.01 ether;

    function run() external {
        vm.startBroadcast();
        Raffle raffle = new Raffle(ENTERANCE_FEE, INTERVAL, SUBSCRIPTION_ID);
        vm.stopBroadcast();
    }
}
