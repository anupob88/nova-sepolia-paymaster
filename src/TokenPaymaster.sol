// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

// Minimal ERC-4337 types (self-contained, no external deps)

struct PackedUserOperation {
    address sender;
    uint256 nonce;
    bytes initCode;
    bytes callData;
    bytes32 accountGasLimits;
    uint256 preVerificationGas;
    bytes32 gasFees;
    bytes paymasterAndData;
    bytes signature;
}

interface IEntryPoint {
    function getNonce(address sender, uint192 key) external view returns (uint256);
}

// Base Paymaster — ERC-4337 compatible
abstract contract BasePaymaster {
    IEntryPoint public immutable entryPoint;

    constructor(IEntryPoint _entryPoint) {
        entryPoint = _entryPoint;
    }

    function _validatePaymasterUserOp(
        PackedUserOperation calldata userOp,
        bytes32 userOpHash,
        uint256 maxCost
    ) internal virtual returns (bytes memory context, uint256 validationData);

    // In production, add deposit/stake logic to EntryPoint
}

// Nova TokenPaymaster — accepts any UserOp, pays gas in NOVA token
contract TokenPaymaster is BasePaymaster {
    address public immutable TOKEN;

    constructor(IEntryPoint _entryPoint, address _token) BasePaymaster(_entryPoint) {
        TOKEN = _token;
    }

    function _validatePaymasterUserOp(
        PackedUserOperation calldata userOp,
        bytes32 userOpHash,
        uint256 maxCost
    ) internal override returns (bytes memory context, uint256 validationData) {
        // Accept any UserOp — in production, verify token payment
        return ("", 0);
    }
}
