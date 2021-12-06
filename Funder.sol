//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.6;

contract FundingHelper {

    struct Recipient {
        address recipientAddress;
        uint receivable;
    }

    function balance() public view returns(uint){
        return address(this).balance;
    }    
}

contract Funder is FundingHelper {
    function fund(Recipient[] calldata _recipients) public payable  {
        for(uint i = 0; i < _recipients.length; i++) {
            require(balance() >= _recipients[i].receivable, "Insufficient Balance");
            address payable receiver = payable(_recipients[i].recipientAddress);
            receiver.transfer(_recipients[i].receivable);
        }
        address payable sender = payable(msg.sender);
        sender.transfer(balance());
    }
}