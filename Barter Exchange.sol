// SPDX-License-Identifier: MIT

pragma solidity ^0.8.3;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/utils/ERC721Holder.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/interfaces/IERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";

contract Crypto_Corp is ERC721, ERC721Holder {


// 0) Variables Declaration:

string public Info = "Tokens give access to a public "
                     "barter exchange for crypto assets. Initially there is "
                     "an unlimited ammount of tokens with a unit price of "
                     "0.0001 ethers.";
                             
address public Contract_Owner;
address public Enterprise;

struct NFT_ERC20_Public{
    ERC721 NFT;
    uint NFT_Id;
    ERC20 Tokens;
    uint Tokens_Quantity;
    bool Active;
    string Comments;
    address Seller_Account;
}

struct NFT_ERC20_Private{
    ERC721 NFT;
    uint NFT_Id;
    ERC20 Tokens;
    uint Tokens_Quantity;
    bool Active;
    string Comments;
    address Seller_Account;
    address Buyer_Account;
}

NFT_ERC20_Public[] public NFT_ERC20_Public_Offers;
NFT_ERC20_Private[] public NFT_ERC20_Private_Offers;


struct NFT_NFT_Public{
    ERC721 NFT_Seller;
    uint NFT_Id1;
    ERC721 NFT_Buyer;
    uint NFT_Id2;
    bool Active;
    string Comments;
    address Seller_Account;
}

struct NFT_NFT_Private{
    ERC721 NFT_Seller;
    uint NFT_Id1;
    ERC721 NFT_Buyer;
    uint NFT_Id2;
    bool Active;
    string Comments;
    address Seller_Account;
    address Buyer_Account;
}

NFT_NFT_Public[] public NFT_NFT_Public_Offers;
NFT_NFT_Private[] public NFT_NFT_Private_Offers;


struct ERC20_ERC20_Public{
    ERC20 Tokens_Seller;
    uint Tokens_Quantity1;
    ERC20 Tokens_Buyer;
    uint Tokens_Quantity2;
    bool Active;
    string Comments;
    address Seller_Account;
}

struct ERC20_ERC20_Private{
    ERC20 Tokens_Seller;
    uint Tokens_Quantity1;
    ERC20 Tokens_Buyer;
    uint Tokens_Quantity2;
    bool Active;
    string Comments;
    address Seller_Account;
    address Buyer_Account;
}

ERC20_ERC20_Public[] public ERC20_ERC20_Public_Offers;
ERC20_ERC20_Private[] public ERC20_ERC20_Private_Offers;

mapping(ERC721 => mapping(uint => uint)) public NFT_Inventory;
mapping(ERC20 => uint) public ERC20_Inventory;
uint TokenCount=0;


// 1) Exchange Construction:

constructor() ERC721("The Barter Crypto Palace", "<($_$)>") {

Contract_Owner = msg.sender;
Enterprise = address(this);  

}


// 2) Contract Functions:

event New_Transaction(string _Debit, uint _Amount1, string _Credit, uint _Amount2);

// 2.0) Buy exchange membership:

function Buy_Membership() external payable {
require(msg.value == 0.0001 ether, "Membership value is 0.0001 ethers");
TokenCount=TokenCount+1;
_mint(msg.sender, TokenCount); 
emit New_Transaction("[Asset|Cash]", 0.0001 ether, 
                     "[Equity|Capital]", 0.0001 ether);
} 

// 2.1) Pay Dividends:

function Dividends_Pay(uint Amount) external {
require(Amount <= address(this).balance, "There are not enough funds");
require(msg.sender==Contract_Owner, "This function is only for the owner of the contract");
payable(Contract_Owner).transfer(Amount);
emit New_Transaction("[Equity|Capital]", Amount,
                     "[Asset|Cash]", Amount);
}

// 2.2) Cash Balance:

function Cash_Firm() external view returns(uint) {
    return(address(this).balance);
}

// 2.3) Buy/Sell NFT for ERC20 (Public):

function NFT_ERC20_Public_Offer(ERC721 Contract_NFT, uint Id, ERC20 Token, uint Quantity) public {
    require(Contract_NFT.ownerOf(Id)==msg.sender, "Not the owner of the NFT Token");
    NFT_ERC20_Public_Offers.push(NFT_ERC20_Public(Contract_NFT, Id, Token, Quantity, true, "Public offer", msg.sender));
    Contract_NFT.safeTransferFrom(msg.sender, Enterprise, Id);
     NFT_Inventory[Contract_NFT][Id]=1;
}

function NFT_ERC20_Public_Buy(uint Offer_Id) external payable {
     ERC20 Aux_ERC20 = NFT_ERC20_Public_Offers[Offer_Id].Tokens;
     ERC721 Aux_NFT = NFT_ERC20_Public_Offers[Offer_Id].NFT;
     uint Aux_NFT_Id = NFT_ERC20_Public_Offers[Offer_Id].NFT_Id;
     uint Aux_Quantity = NFT_ERC20_Public_Offers[Offer_Id].Tokens_Quantity;
     address Aux_Seller = NFT_ERC20_Public_Offers[Offer_Id].Seller_Account;

     require(Aux_ERC20.balanceOf(msg.sender)>=Aux_Quantity, "Not enough tokens");
     require(NFT_ERC20_Public_Offers[Offer_Id].Active==true, "The offer is not active");
     
     Aux_NFT.safeTransferFrom(Enterprise, msg.sender, Aux_NFT_Id);
     Aux_ERC20.transferFrom(msg.sender, 
           Aux_Seller,  
           Aux_Quantity);

     NFT_ERC20_Public_Offers[Offer_Id].Active=false;
     NFT_Inventory[Aux_NFT][Aux_NFT_Id]=0;                
}

// 2.4) Buy/Sell NFT for ERC20 (Private):

function NFT_ERC20_Private_Offer(ERC721 Contract_NFT, uint Id, ERC20 Token, uint Quantity, address Buyer) public {
    require(Contract_NFT.ownerOf(Id)==msg.sender, "Not the owner of the NFT Token");
    NFT_ERC20_Private_Offers.push(NFT_ERC20_Private(Contract_NFT, Id, Token, Quantity, true, "Private offer", msg.sender, Buyer));
    Contract_NFT.safeTransferFrom(msg.sender, Enterprise, Id);
     NFT_Inventory[Contract_NFT][Id]=1;
}

function NFT_ERC20_Private_Buy(uint Offer_Id) external payable {
     ERC20 Aux_ERC20 = NFT_ERC20_Private_Offers[Offer_Id].Tokens;
     ERC721 Aux_NFT = NFT_ERC20_Private_Offers[Offer_Id].NFT;
     uint Aux_NFT_Id = NFT_ERC20_Private_Offers[Offer_Id].NFT_Id;
     uint Aux_Quantity = NFT_ERC20_Private_Offers[Offer_Id].Tokens_Quantity;
     address Aux_Seller = NFT_ERC20_Private_Offers[Offer_Id].Seller_Account;

     require(Aux_ERC20.balanceOf(msg.sender)>=Aux_Quantity, "Not enough tokens");
     require(NFT_ERC20_Private_Offers[Offer_Id].Active==true, "The offer is not active");
     require(NFT_ERC20_Private_Offers[Offer_Id].Buyer_Account==msg.sender, "Unauthorized buyer");
     
     Aux_NFT.safeTransferFrom(Enterprise, msg.sender, Aux_NFT_Id);
     Aux_ERC20.transferFrom(msg.sender, 
           Aux_Seller,  
           Aux_Quantity);

     NFT_ERC20_Private_Offers[Offer_Id].Active=false;
     NFT_Inventory[Aux_NFT][Aux_NFT_Id]=0;                
}

// 2.5) Buy/Sell NFT for NFT (Public):

function NFT_NFT_Public_Offer(ERC721 Contract_NFT1, uint Id1, ERC721 Contract_NFT2, uint Id2) public {
    require(Contract_NFT1.ownerOf(Id1)==msg.sender, "Not the owner of the NFT Token");
    NFT_NFT_Public_Offers.push(NFT_NFT_Public(Contract_NFT1, Id1, Contract_NFT2, Id2, true, "Public offer", msg.sender));
    Contract_NFT1.safeTransferFrom(msg.sender, Enterprise, Id1);
     NFT_Inventory[Contract_NFT1][Id1]=1;
}

function NFT_NFT_Public_Buy(uint Offer_Id) external payable {
     ERC721 Aux_NFT1 = NFT_NFT_Public_Offers[Offer_Id].NFT_Seller;
     ERC721 Aux_NFT2 = NFT_NFT_Public_Offers[Offer_Id].NFT_Buyer;
     uint Aux_NFT_Id1 = NFT_NFT_Public_Offers[Offer_Id].NFT_Id1;
     uint Aux_NFT_Id2 = NFT_NFT_Public_Offers[Offer_Id].NFT_Id2;
     address Aux_Seller = NFT_NFT_Public_Offers[Offer_Id].Seller_Account;

     require(Aux_NFT2.ownerOf(Aux_NFT_Id2)==msg.sender, "Not the owner of the NFT Token");
     require(NFT_NFT_Public_Offers[Offer_Id].Active==true, "The offer is not active");
     
     Aux_NFT1.safeTransferFrom(Enterprise, msg.sender, Aux_NFT_Id1);
     Aux_NFT2.safeTransferFrom(msg.sender, Aux_Seller, Aux_NFT_Id2);

     NFT_NFT_Public_Offers[Offer_Id].Active=false;
     NFT_Inventory[Aux_NFT1][Aux_NFT_Id1]=0;                
}

// 2.6) Buy/Sell NFT for NFT (Private):

function NFT_NFT_Private_Offer(ERC721 Contract_NFT1, uint Id1, ERC721 Contract_NFT2, uint Id2, address Buyer) public {
    require(Contract_NFT1.ownerOf(Id1)==msg.sender, "Not the owner of the NFT Token");
    NFT_NFT_Private_Offers.push(NFT_NFT_Private(Contract_NFT1, Id1, Contract_NFT2, Id2, true, "Private offer", msg.sender, Buyer));
    Contract_NFT1.safeTransferFrom(msg.sender, Enterprise, Id1);
     NFT_Inventory[Contract_NFT1][Id1]=1;
}

function NFT_NFT_Private_Buy(uint Offer_Id) external payable {
     ERC721 Aux_NFT1 = NFT_NFT_Private_Offers[Offer_Id].NFT_Seller;
     ERC721 Aux_NFT2 = NFT_NFT_Private_Offers[Offer_Id].NFT_Buyer;
     uint Aux_NFT_Id1 = NFT_NFT_Private_Offers[Offer_Id].NFT_Id1;
     uint Aux_NFT_Id2 = NFT_NFT_Private_Offers[Offer_Id].NFT_Id2;
     address Aux_Seller = NFT_NFT_Private_Offers[Offer_Id].Seller_Account;

     require(Aux_NFT2.ownerOf(Aux_NFT_Id2)==msg.sender, "Not the owner of the NFT Token");
     require(NFT_NFT_Private_Offers[Offer_Id].Active==true, "The offer is not active");
     require(NFT_NFT_Private_Offers[Offer_Id].Buyer_Account==msg.sender, "Unauthorized buyer");
     
     Aux_NFT1.safeTransferFrom(Enterprise, msg.sender, Aux_NFT_Id1);
     Aux_NFT2.safeTransferFrom(msg.sender, Aux_Seller, Aux_NFT_Id2);

     NFT_NFT_Private_Offers[Offer_Id].Active=false;
     NFT_Inventory[Aux_NFT1][Aux_NFT_Id1]=0;                
}

// 2.7) Buy/Sell ERC20 for ERC20 (Public):

// 2.8) Buy/Sell ERC20 for ERC20 (Private):

// 2.9) Cancel offer:


// 3) End Contract:

function End_Enterprise() external payable{
     require(msg.sender==Contract_Owner, "This function is only for the founder of the firm");   
     selfdestruct(payable(Contract_Owner));
}




}
