pragma solidity ^ 0.5.0;

import "github.com/OpenZeppelin/zeppelin-solidity/contracts/token/ERC20/IERC20.sol";
import "github.com/OpenZeppelin/zeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "github.com/OpenZeppelin/zeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol";

contract DSN is IERC20, ERC20Detailed, ERC20 {
    constructor(uint256 initialSupply) ERC20Detailed("Dissent Token", "DSNTEST", 2) public {
        _mint(msg.sender, initialSupply);
    }
}
