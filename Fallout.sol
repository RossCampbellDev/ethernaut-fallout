// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "openzeppelin-contracts-06/math/SafeMath.sol";

contract Fallout {  
  using SafeMath for uint256;
  mapping (address => uint) allocations;
  address payable public owner;


  /* constructor */
  // this is an old format of constructor from < v7.  since then there is a keyword "Constructor"
  // ... for a very good reason.
  // IF the function name is NOT the same as the contract name, we can call this function just like any other.
  // since there is no access control or other validation on this function, we can simply send a transaction to it
  // and it will make us into the contract owner, giving us access to the collectAllocations() function
  function Fal1out() public payable {
    owner = payable(msg.sender);
    allocations[owner] = msg.value;
  }

  modifier onlyOwner {
    require(
        msg.sender == owner,
        "caller is not the owner"
    );
    _;
	}

  function allocate() public payable {
    allocations[msg.sender] = allocations[msg.sender].add(msg.value);
  }

  function sendAllocation(address payable allocator) public {
    require(allocations[allocator] > 0);
    allocator.transfer(allocations[allocator]);
  }

  function collectAllocations() public onlyOwner {
    payable(msg.sender).transfer(address(this).balance);
  }

  function allocatorBalance(address allocator) public view returns (uint) {
    return allocations[allocator];
  }
}
