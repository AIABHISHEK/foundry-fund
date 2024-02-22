// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/Fund.sol";

contract FundTest is Test {
    FundMe fund;
    function setUp() external {
        //deploy in our setup
        fund = new FundMe();
    }

    function testMinimumAmount() public {
        assertEq(fund.MINIMUM_USD(), 5e18);
        console.log("Hello, World!");
    }

    function testOwnerMsgSender() public {
        console.log(fund.i_owner());
        console.log(msg.sender);
        assertEq(fund.i_owner(), address(this));
    }
}
