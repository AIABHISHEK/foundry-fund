// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/Fund.sol";
import {DeployFund} from "../../script/DeployFund.s.sol";

contract FundTest is Test {
    FundMe fund;
    
    uint256 constant SEND_VALUE = 5e18;
    address USER = makeAddr("user");
    function setUp() external {
        //deploy in our setup
        DeployFund fundme = new DeployFund();
        fund = fundme.run();
        vm.deal(USER, 100 ether);
    }

    function testMinimumAmount() public {
        assertEq(fund.MINIMUM_USD(), 5e18);
        console.log("Hello, World!");
    }

    function testOwnerMsgSender() public {
        console.log(fund.i_owner());
        console.log(msg.sender);
        assertEq(fund.i_owner(), msg.sender);
    }

    function testPriceFeedVersionIsAccurate() public {
        uint256 version = fund.getVersion();
        assertEq(version, 4);
    }

    function testFundFailsWithoutEnoughETH() public {
        vm.expectRevert(); // we expect the revert i.e next line should revert
        fund.fund(); //this will pass 
        //fund.fund{value: 3e18}(); //in this case will not
    }

    modifier FundUser() {
        vm.prank(USER); // prank make USER as sender of transaction
        fund.fund{value: SEND_VALUE}();
        _;
    }

    function testFundUpdatesFundedDataStructure() public FundUser {
        uint256 amountFunded = fund.getAddressToAmountFunded(USER); //fundtest is calling fund.fund()
        assertEq(amountFunded, SEND_VALUE);
    }

    function testAddsFundersToArrayOfUpdate() public FundUser {
        address funder = fund.getFunder(0);
        assertEq(funder, USER);
    }

    function testOnlyOwnerCanWithdraw() public {
        vm.expectRevert();
        fund.withdraw();
    }

    function testWithdrawWithSuccess() public {
        
        //arrange
        uint256 startingAmountOfOwner = fund.getOwner().balance;
        uint256 startingAmountOfFundme = address(fund).balance;
        //act
        vm.prank(fund.getOwner());
        fund.withdraw();
    
        //assert
        uint256 endingOwnerBalance = fund.getOwner().balance;
        uint256 endingFundmeBalance = address(fund).balance;

        assertEq(endingOwnerBalance, startingAmountOfOwner + startingAmountOfFundme);
        assertEq(endingFundmeBalance, 0);
    }

    function testWithdrawFromMultipleFunders() public FundUser {
        //arange
        uint256 numberofFunders = 5;
        uint160 startingIndex = 1;
        for(uint160 i = startingIndex; i<numberofFunders; i++){
            hoax(address(i), SEND_VALUE);
            fund.fund{value: SEND_VALUE}();
        }

        uint256 startingAmountOfOwner = fund.getOwner().balance;
        uint256 startingAmountOfFundme = address(fund).balance;

        //act
        vm.startPrank(fund.getOwner());
        fund.withdraw();
        vm.stopPrank();

        //assert
        uint256 endingOwnerBalance = fund.getOwner().balance;
        uint256 endingFundmeBalance = address(fund).balance;
        assertEq(endingOwnerBalance, startingAmountOfOwner + startingAmountOfFundme);
        assertEq(endingFundmeBalance, 0);
    }
    // testing
    // uint testing --> testing in specific part of the code
    //2. integration testing --> testing how our code works with other parts of the code
    // 3. forked testing --> testing how our code on a simulated real network
    //4. staging  --> testing our code in real enviornment that is not not prod
}