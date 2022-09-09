// SPDX-License-Identifier: MIT

pragma solidity ^0.8.3;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/utils/ERC721Holder.sol";


contract Crypto_Tokens_A is ERC721, ERC721Holder {


// 0) Variables Declaration:

string public Info = "Tokens represent physical assets "
                     "that can be use in The Barter Palace Inc'. Each token can be "
                     "cashback at any moment for the same amount of ethereum it was originally "
                     "bought.";
                             
address public Owner_Address;
address public Contract_Address;  
uint public Initial_Supply;  
uint public Token_Price;
bool private Price_Aux;

uint TokenCount=0;


// 1) ERC721 Contract Creation:

constructor() ERC721("Crypto Tokens [CARS]", "CT_CARS") {
Owner_Address = msg.sender;
Contract_Address = address(this);
Initial_Supply = 0;
Price_Aux = false;
}


// 2) Custom Functions:

function Set_Token_Price(uint _Token_Price) public{
require(msg.sender==Owner_Address, "This function is only for the owner of the contract");
Token_Price = _Token_Price;
Price_Aux = true;
}

function Mint_New_Tokens() external payable{
require(msg.value==1*Token_Price, "The message value is not equal to the token price");
require(Price_Aux==true, "The token price has not been set yet");
TokenCount=TokenCount+1;
_mint(msg.sender, TokenCount);
}

function Cashback_Tokens(uint Id) external payable{
require(ERC721(Contract_Address).ownerOf(Id)==msg.sender, "The account is not the owner of the token");
payable(msg.sender).transfer(Contract_Address.balance*1/(TokenCount-ERC721(Contract_Address).balanceOf(Contract_Address)));
ERC721(Contract_Address).safeTransferFrom(msg.sender, Contract_Address, Id);
}


function Contract_Funds() public view returns(uint){
    return(Contract_Address.balance);
}


}
