// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {IEntryPoint} from "@account-abstraction/contracts/interfaces/IEntryPoint.sol";
import {BasePaymaster} from "@account-abstraction/contracts/core/BasePaymaster.sol";
import {UserOperationLib} from "@account-abstraction/contracts/core/UserOperationLib.sol";

contract TokenPaymaster is BasePaymaster {
    using UserOperationLib for PackedUserOperation;

    address public immutable TOKEN;

    constructor(IEntryPoint _entryPoint, address _token) BasePaymaster(_entryPoint) {
        TOKEN = _token;
    }

    function _validatePaymasterUserOp(
        PackedUserOperation calldata userOp,
        bytes32 userOpHash,
        uint256 maxCost
    ) internal override returns (bytes memory context, uint256 validationData) {
        // Accept any UserOp - in production add token transfer logic
        return ("", 0);
    }
}
