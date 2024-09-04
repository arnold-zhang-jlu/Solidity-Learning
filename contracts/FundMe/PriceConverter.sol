// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
    function getVersion() internal view returns(uint) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        return(priceFeed.version());
    }

    function getDecimals() internal view returns(uint8) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        return priceFeed.decimals();
    }

    function getPrice() internal view returns(uint) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        (,int256 answer,,,) = priceFeed.latestRoundData();
        return uint(answer * 1e10);
    }

    function getConversionRate(uint ethAmount) internal view returns(uint) {
        uint price = getPrice();
        uint ethAmountInUSD = (ethAmount * price) / 1e18;
        return ethAmountInUSD;
    }

}