// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import "forge-std/Script.sol";
import {Raffle} from "src/Raffle.sol";

// 假设Raffle合约的接口
interface IRaffle {
    function enterRaffle() external payable;
}

contract EnterRaffleScript is Script {
    // 设置目标合约的地址
    address constant RAFFLE_ADDRESS = 0x52d64aad6ca10b04EacA47EAf5DDc206BBDB0132;

    uint256 entranceFee = 0.045 ether;

    function run() external {
        // 从.env文件中加载SEPOLIA_RPC_URL和私钥
        string memory rpcUrl = vm.envString("SEPOLIA_RPC_URL");
        // uint256 privateKey = vm.envUint("PRIVATE_KEY"); // 你需要在.env中定义PRIVATE_KEY

        // 启动广播模式
        vm.startBroadcast();

        // 以0.045 ether的价格调用enterRaffle
        IRaffle(RAFFLE_ADDRESS).enterRaffle{value: entranceFee}();

        // 停止广播
        vm.stopBroadcast();
    }
}
