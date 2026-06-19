// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "forge-std/Script.sol";
import "../src/TokenPaymaster.sol";
import "../src/NovaToken.sol";

contract DeployPaymaster is Script {
    function run() external {
        uint256 deployerKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerKey);

        // Deploy NovaToken (ERC-20 for gas payment)
        NovaToken novaToken = new NovaToken();
        console.log("NovaToken deployed at:", address(novaToken));

        // Deploy TokenPaymaster — accepts NovaToken for gas
        // For local Anvil chain, we deploy a mock EntryPoint
        TokenPaymaster paymaster = new TokenPaymaster(
            IEntryPoint(address(0x5FF137D4b0FDCD49DcA30c7CF57E578a026d2789)),
            address(novaToken)
        );
        console.log("TokenPaymaster deployed at:", address(paymaster));

        vm.stopBroadcast();
    }
}
