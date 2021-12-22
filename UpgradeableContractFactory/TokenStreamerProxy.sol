pragma solidity ^0.8.10;

import './TokenStreamerFactory.sol';

contract TokenStreamerProxy {
    // Proxy Contract

        address public owner;
        address public constant factoryAddress = 0xd2a5bC10698FD955D1Fe6cb468a17809A08fd005; // Address of the deployed TokenStreamerFactory 

        
        fallback() external payable {
            address master = TokenStreamerFactory(factoryAddress).masterStreamer();
            assembly {
                let _impl := master
                let ptr := mload(0x40)

                // (1) copy incoming call data
                calldatacopy(ptr, 0, calldatasize())

                // (2) forward call to logic contract
                let result := delegatecall(gas(), _impl, ptr, calldatasize(), 0, 0)
                let size := returndatasize()

                // (3) retrieve return data
                returndatacopy(ptr, 0, size)

                // (4) forward return data back to caller
                switch result
                case 0 { revert(ptr, size) }
                default { return(ptr, size) }
            }
        }

}