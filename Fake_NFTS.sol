// SPDX-License-Identifier: MIT

pragma solidity ^0.8.3;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.0/contracts/token/ERC721/extensions/ERC721URIStorage.sol";


contract Fake_NFTS is ERC721URIStorage {


// 0) Variables Declaration:

string public Info = "All the NFTS in this contract are fake.";
                             
address public Owner_Address;
address public Contract_Address;   

uint TokenCount=0;


// 1) ERC721 Contract Creation:

constructor() ERC721("Fake NFTS", ":(") {
Owner_Address = msg.sender;
Contract_Address = address(this);
}


// 2) Custom Functions:

function Mint_New_Tokens(string memory URI_Fake) external payable{
require(msg.sender==Owner_Address, "This function is only for the owner of the contract");
TokenCount=TokenCount+1;
_mint(msg.sender, TokenCount);
_setTokenURI(TokenCount, URI_Fake);
}


}
