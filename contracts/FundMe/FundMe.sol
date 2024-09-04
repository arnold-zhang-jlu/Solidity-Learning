// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

import "./PriceConverter.sol";

contract FundMe {
    using PriceConverter for uint;
    uint public minimumUSD = 10 * 1e18;

    address[] public funders;
    mapping(address => uint) public addressToAmountFunded; 

    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function fund() public payable  {
        require(msg.value.getConversionRate() >= minimumUSD, "Didn't send enough!");
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] = msg.value;
    }

    function withdraw() public onlyOwner{
        for(uint index = 0; index < funders.length; index++) {
            address funder = funders[index];
            addressToAmountFunded[funder] = 0;
        }
        funders = new address[](0);
        //transfer
        // payable(msg.sender).transfer(address(this).balance);
        //send
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "Send Failed!");
        //call
        // (bool callSuccess, bytes memory dataReturned )= payable(msg.sender).call{value: address(this).balance}("");
        (bool callSuccess,)= payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call Failed!");
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
    
}

