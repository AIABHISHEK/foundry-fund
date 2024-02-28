// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/Fund.sol";
import {DeployFund} from "../../script/DeployFund.s.sol";
import {FundFundMe, WithdrawFundMe} from "../../script/Interactions.s.sol";

contract InteractionsTest is Test {
    FundMe fund;

    address USER = makeAddr("user");
    uint256 constant SEND_VALUE = 0.1 ether;
    uint256 constant STAGING_BALANCE = 10 ether;
    uint256 constant GAS_PRICE = 1;

    function setUp() external {
        DeployFund deployFund = new DeployFund();
        fund = deployFund.run();
        vm.deal(USER, STAGING_BALANCE);
    }

    function testUserCanFundInteractions() external {
        FundFundMe fundFundMe = new FundFundMe();
        // vm.prank(USER);
        // vm.deal(USER, STAGING_BALANCE);
        fundFundMe.fundFundMe(address(fund));

        WithdrawFundMe withdrawFundMe = new WithdrawFundMe();
        withdrawFundMe.withdrawFundMe(address(fund));

        // address funder = fund.getFunder(0);
        // console.log(funder);
        // console.log(USER);
        // assertEq(funder, USER);
        // assertEq(address(fund), fund.i_owner());
        assertEq(address(fund).balance , 0);
    }
}
