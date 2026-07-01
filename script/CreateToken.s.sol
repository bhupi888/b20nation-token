// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import {Script, console} from "forge-std/Script.sol";
import {B20Constants} from "base-std/lib/B20Constants.sol";
import {B20FactoryLib} from "base-std/lib/B20FactoryLib.sol";
import {IB20Factory} from "base-std/interfaces/IB20Factory.sol";
import {StdPrecompiles} from "base-std/StdPrecompiles.sol";
contract CreateToken is Script {
    function run() external returns (address token) {
        // For the quickstart, one account is admin + minter.
        address account = vm.envAddress("ACCOUNT_ADDRESS");
        bytes32 salt = keccak256("baseanova-bnova-v1");
        // Name, symbol, initial DEFAULT_ADMIN_ROLE holder, decimals (6-18).
        bytes memory params = B20FactoryLib.encodeAssetCreateParams("Baseanova", "BNOVA", account, 18);
        // Configuration applied atomically at creation.
        bytes[] memory initCalls = new bytes[](2);
        initCalls[0] = B20FactoryLib.encodeGrantRole(B20Constants.MINT_ROLE, account);
        initCalls[1] = B20FactoryLib.encodeUpdateSupplyCap(1_000_000e18);
        vm.startBroadcast();
        token = StdPrecompiles.B20_FACTORY.createB20(IB20Factory.B20Variant.ASSET, salt, params, initCalls);
        vm.stopBroadcast();
        console.log("B20 token created at:", token);
    }
}
