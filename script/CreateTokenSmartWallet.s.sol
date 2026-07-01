// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console} from "forge-std/Script.sol";

import {B20Constants} from "base-std/lib/B20Constants.sol";
import {B20FactoryLib} from "base-std/lib/B20FactoryLib.sol";
import {IB20Factory} from "base-std/interfaces/IB20Factory.sol";
import {StdPrecompiles} from "base-std/StdPrecompiles.sol";

contract CreateTokenSmartWallet is Script {
    function run() external returns (address token) {
        // Admin + minter is the Base Account smart wallet, not the deployer key.
        address account = 0xb9c12bcCC2838C7f46AEf0ba378Ec87ae546b157;
        bytes32 salt = keccak256("my-first-b20-smartwallet");

        bytes memory params = B20FactoryLib.encodeAssetCreateParams("My Token", "MYT", account, 18);

        bytes[] memory initCalls = new bytes[](2);
        initCalls[0] = B20FactoryLib.encodeGrantRole(B20Constants.MINT_ROLE, account);
        initCalls[1] = B20FactoryLib.encodeUpdateSupplyCap(1_000_000e18);

        vm.startBroadcast();
        token = StdPrecompiles.B20_FACTORY.createB20(IB20Factory.B20Variant.ASSET, salt, params, initCalls);
        vm.stopBroadcast();

        console.log("B20 token created at:", token);
        console.log("Admin/minter:", account);
    }
}
