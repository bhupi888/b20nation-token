// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import {Script, console} from "forge-std/Script.sol";
import {NAT20Claim} from "../src/NAT20Claim.sol";

contract DeployClaim is Script {
    function run() external returns (address claimContract) {
        address token = vm.envAddress("TOKEN_ADDRESS");
        address treasury = vm.envAddress("ACCOUNT_ADDRESS");
        vm.startBroadcast();
        NAT20Claim c = new NAT20Claim(token, treasury);
        vm.stopBroadcast();
        claimContract = address(c);
        console.log("NAT20Claim deployed at:", claimContract);
    }
}
