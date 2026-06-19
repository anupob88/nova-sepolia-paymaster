// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "forge-std/Script.sol";
import "../src/TokenPaymaster.sol";

contract DeployPaymaster is Script {
    function run() external {
        uint256 deployerKey = vm.envUint("PRIVATE_KEY");
        address entryPoint = vm.envAddress("ENTRY_POINT");
        
        vm.startBroadcast(deployerKey);
        new TokenPaymaster(IEntryPoint(entryPoint), address(0));
        vm.stopBroadcast();
    }
}
