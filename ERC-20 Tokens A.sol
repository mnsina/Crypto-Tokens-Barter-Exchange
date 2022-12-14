// SPDX-License-Identifier: MIT

pragma solidity ^0.8.3;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";

contract Crypto_Coins_CLP is ERC20 {


// 0) Variables Declaration:

string public Info = "Tokens represent ethereum coins "
                     "that can be use in The Barter Palace Inc'. Each coin can be "
                     "cashback at any moment for the same amount of ethereum it was originally "
                     "bought.";

address public Owner_Address;
address public Contract_Address;  
uint public Initial_Supply;  
uint public Token_Price;
bool private Price_Aux;


// 1) ERC20 Contract Creation:

constructor() ERC20("Crypto Coins [CLP]", "CC_CLP") {
Owner_Address = msg.sender;
Contract_Address = address(this);
Initial_Supply = 0;
Price_Aux = false;
_mint(Owner_Address, Initial_Supply);
}

function decimals() public view override returns (uint8) {
return 0;
}


// 3) Custom Functions:

function Set_Token_Price(uint _Token_Price) public{
require(msg.sender==Owner_Address, "This function is only for the owner of the contract");
Token_Price = _Token_Price;
Price_Aux = true;
}

function Mint_New_Tokens(uint Quantity) external payable{
require(msg.value==Quantity*Token_Price, "The message value is not equal to the token price");
require(Price_Aux==true, "The token price has not been set yet");
_mint(msg.sender, Quantity);
}

function Cashback_Tokens(uint Quantity) external payable{
require(ERC20(Contract_Address).balanceOf(msg.sender)>=Quantity, "The account has not enough tokens");
require(ERC20(Contract_Address).allowance(msg.sender, Contract_Address)>=Quantity, "The contract has not enough tokens allowance");
payable(msg.sender).transfer(Contract_Address.balance*Quantity/(ERC20(Contract_Address).totalSupply()-ERC20(Contract_Address).balanceOf(Contract_Address)));
ERC20(Contract_Address).transferFrom(msg.sender, Contract_Address, Quantity);
}


function Contract_Funds() public view returns(uint){
    return(Contract_Address.balance);
}


}
