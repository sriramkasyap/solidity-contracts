pragma solidity ^0.8.10;

import './TokenStreamerProxy.sol';
import './TokenStreamer.sol';
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts/proxy/Clones.sol";

contract TokenStreamerFactory is Ownable, Initializable {
    // Factory Contract

        // Inherits
            // Ownable

        // Storage
        // List of Child Streamer Contracts (Proxy)
        TokenStreamer[] childContracts;
        // Address of Master Streamer Contract Proxy;
        address public masterStreamerProxy;
        // Address of the target Contract code
        address public masterStreamer;


        // Functions
        // Initialize (MasterContractAddress, TargetContractAddress) - Set - OnlyOwner
        function setupFactory(address _masterContract, address _masterContractProxy) external onlyOwner initializer {
            masterStreamer = _masterContract;
            masterStreamerProxy = _masterContractProxy;
        }

        // UpdateMasterContract (MasterContractAddress) - Set - OnlyOwner
        function updateMasterContract(address _masterContract) external  onlyOwner{
            masterStreamer = _masterContract;
        }

        // UpdateMasterContractProxy (MasterProxyContractAddress) - Set - OnlyOwner
        function updateMasterProxy(address _masterContractProxy) external  onlyOwner{
            masterStreamerProxy = _masterContractProxy;
        }
        
        // Deploy (...StreamerContractVars) - Create child and update List - Anyone - Payable
        function deployStreamer(address _recipient,uint _total,uint  _startTime,uint _endTime) external payable returns(uint) {
            address cloned = Clones.clone(masterStreamerProxy);
            TokenStreamer streamer = TokenStreamer(cloned);
            streamer.initialize{value: msg.value}(_recipient, _total, _startTime, _endTime);
            childContracts.push(streamer);
            return childContracts.length - 1;
        }

        // Get all Child Contracts
        function getContracts() external view returns(TokenStreamer[] memory) {
            return childContracts;
        }

        function claim(uint _contractIndex, uint _amount) external {
            childContracts[_contractIndex].claim(_amount);
        }
        
        function getClaimable(uint _contractIndex) external view returns(uint256) {
            return childContracts[_contractIndex].getClaimable();
        }

        function claimAll(uint _contractIndex) external {
            childContracts[_contractIndex].claimAll();
        }

        function getBalance(uint _contractIndex) external view returns(uint) {
            return childContracts[_contractIndex].getBalance();
        }
        
        function whoami(uint _contractIndex) external view returns(address) {
            return childContracts[_contractIndex].whoami();
        }
        
}

