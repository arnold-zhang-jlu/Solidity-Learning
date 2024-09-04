// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract FundMe {

    AggregatorV3Interface internal priceFeed;
    uint public minimumUSD = 10 * 1e18;

    address[] public funders;
    mapping(address => uint) public addressToAmountFunded; 

    constructor() {
        priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
    }

    function fund() public payable  {
        require(getConversionRate(msg.value) >= minimumUSD, "Didn't send enough!");
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] = msg.value;
    }

    function getVersion() public view returns(uint) {
        return(priceFeed.version());
    }

    function getDecimals() public view returns(uint8) {
        return priceFeed.decimals();
    }

    function getPrice() public view returns(uint) {
        (,int256 answer,,,) = priceFeed.latestRoundData();
        return uint(answer * 1e10);
    }

    function getConversionRate(uint ethAmount) public view returns(uint) {
        uint price = getPrice();
        uint ethAmountInUSD = (ethAmount * price) / 1e18;
        return ethAmountInUSD;
    }

}

