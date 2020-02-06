pragma solidity ^0.4.24;
  pragma experimental ABIEncoderV2;
/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {

  /**
  * @dev Multiplies two numbers, throws on overflow.
  */
  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
  // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
  // benefit is lost if 'b' is also tested.
  // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
  if (a == 0) {
    return 0;
  }

  c = a * b;
  assert(c / a == b);
  return c;
  }

  /**
  * @dev Integer division of two numbers, truncating the quotient.
  */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
  // assert(b > 0); // Solidity automatically throws when dividing by 0
  // uint256 c = a / b;
  // assert(a == b * c + a % b); // There is no case in which this doesn't hold
  return a / b;
  }

  /**
  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
  */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
  assert(b <= a);
  return a - b;
  }

  /**
  * @dev Adds two numbers, throws on overflow.
  */
  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
  c = a + b;
  assert(c >= a);
  return c;
  }
}

contract ReentrancyGuard {

/// @dev counter to allow mutex lock with only one SSTORE operation
uint256 private guardCounter = 1;

/**
* @dev Prevents a contract from calling itself, directly or indirectly.
* If you mark a function `nonReentrant`, you should also
* mark it `external`. Calling one `nonReentrant` function from
* another is not supported. Instead, you can implement a
* `private` function doing the actual work, and an `external`
* wrapper marked as `nonReentrant`.
*/
  modifier nonReentrant() {
    guardCounter += 1;
    uint256 localCounter = guardCounter;
    _;
    require(localCounter == guardCounter);
  }

}


/**
 * @title ERC165
 * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
 */
interface ERC165 {

  /**
   * @notice Query if a contract implements an interface
   * @param _interfaceId The interface identifier, as specified in ERC-165
   * @dev Interface identification is specified in ERC-165. This function
   * uses less than 30,000 gas.
   */
  function supportsInterface(bytes4 _interfaceId)
  external
  view
  returns (bool);
}

/**
 * @title ERC721 token receiver interface
 * @dev Interface for any contract that wants to support safeTransfers
 * from ERC721 asset contracts.
 */
contract ERC721Receiver {
  /**
   * @dev Magic value to be returned upon successful reception of an NFT
   *  Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`,
   *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
   */
  bytes4 internal constant ERC721_RECEIVED = 0x150b7a02;

  /**
   * @notice Handle the receipt of an NFT
   * @dev The ERC721 smart contract calls this function on the recipient
   * after a `safetransfer`. This function MAY throw to revert and reject the
   * transfer. Return of other than the magic value MUST result in the
   * transaction being reverted.
   * Note: the contract address is always the message sender.
   * @param _operator The address which called `safeTransferFrom` function
   * @param _from The address which previously owned the token
   * @param _tokenId The NFT identifier which is being transfered
   * @param _data Additional data with no specified format
   * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
   */
  function onERC721Received(
  address _operator,
  address _from,
  uint256 _tokenId,
  bytes _data
  )
  public
  returns(bytes4);
}

/**
 * Utility library of inline functions on addresses
 */
library AddressUtils {

  /**
   * Returns whether the target address is a contract
   * @dev This function will return false if invoked during the constructor of a contract,
   * as the code is not actually created until after the constructor finishes.
   * @param addr address to check
   * @return whether the target address is a contract
   */
  function isContract(address addr) internal view returns (bool) {
  uint256 size;
  // XXX Currently there is no better way to check if there is a contract in an address
  // than to check the size of the code at that address.
  // See https://ethereum.stackexchange.com/a/14016/36603
  // for more details about how this works.
  // TODO Check this again before the Serenity release, because all addresses will be
  // contracts then.
  // solium-disable-next-line security/no-inline-assembly
  assembly { size := extcodesize(addr) }
  return size > 0;
  }

}

/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
  address public owner;


  event OwnershipRenounced(address indexed previousOwner);
  event OwnershipTransferred(
  address indexed previousOwner,
  address indexed newOwner
  );


  /**
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */
  constructor() public {
  owner = msg.sender;
  }

  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
  require(msg.sender == owner);
  _;
  }

  /**
   * @dev Allows the current owner to relinquish control of the contract.
   * @notice Renouncing to ownership will leave the contract without an owner.
   * It will not be possible to call the functions with the `onlyOwner`
   * modifier anymore.
   */
  function renounceOwnership() public onlyOwner {
  emit OwnershipRenounced(owner);
  owner = address(0);
  }

  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param _newOwner The address to transfer ownership to.
   */
  function transferOwnership(address _newOwner) public onlyOwner {
  _transferOwnership(_newOwner);
  }

  /**
   * @dev Transfers control of the contract to a newOwner.
   * @param _newOwner The address to transfer ownership to.
   */
  function _transferOwnership(address _newOwner) internal {
  require(_newOwner != address(0));
  emit OwnershipTransferred(owner, _newOwner);
  owner = _newOwner;
  }
}

contract SupportsInterfaceWithLookup is ERC165 {
  bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
  /**
   * 0x01ffc9a7 ===
   *   bytes4(keccak256('supportsInterface(bytes4)'))
   */

  /**
   * @dev a mapping of interface id to whether or not it's supported
   */
  mapping(bytes4 => bool) internal supportedInterfaces;

  /**
   * @dev A contract implementing SupportsInterfaceWithLookup
   * implement ERC165 itself
   */
  constructor()
  public
  {
  _registerInterface(InterfaceId_ERC165);
  }

  /**
   * @dev implement supportsInterface(bytes4) using a lookup table
   */
  function supportsInterface(bytes4 _interfaceId)
  external
  view
  returns (bool)
  {
  return supportedInterfaces[_interfaceId];
  }

  /**
   * @dev private method for registering an interface
   */
  function _registerInterface(bytes4 _interfaceId)
  internal
  {
  require(_interfaceId != 0xffffffff);
  supportedInterfaces[_interfaceId] = true;
  }
}

/**
 * @title ERC721 Non-Fungible Token Standard basic interface
 * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
 */
contract ERC721Basic is ERC165 {
  event Transfer(
  address indexed _from,
  address indexed _to,
  uint256 indexed _tokenId
  );
  event Approval(
  address indexed _owner,
  address indexed _approved,
  uint256 indexed _tokenId
  );
  event ApprovalForAll(
  address indexed _owner,
  address indexed _operator,
  bool _approved
  );

  function balanceOf(address _owner) public view returns (uint256 _balance);
  function ownerOf(uint256 _tokenId) public view returns (address _owner);
  function exists(uint256 _tokenId) public view returns (bool _exists);

  function approve(address _to, uint256 _tokenId) public;
  function getApproved(uint256 _tokenId)
  public view returns (address _operator);

  function setApprovalForAll(address _operator, bool _approved) public;
  function isApprovedForAll(address _owner, address _operator)
  public view returns (bool);

  function transferFrom(address _from, address _to, uint256 _tokenId) public;
  function safeTransferFrom(address _from, address _to, uint256 _tokenId)
  public;

  function safeTransferFrom(
  address _from,
  address _to,
  uint256 _tokenId,
  bytes _data
  )
  public;
}

/**
 * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
 * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
 */
contract ERC721Enumerable is ERC721Basic {
  function totalSupply() public view returns (uint256);
  function tokenOfOwnerByIndex(
  address _owner,
  uint256 _index
  )
  public
  view
  returns (uint256 _tokenId);

  function tokenByIndex(uint256 _index) public view returns (uint256);
}


/**
 * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
 * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
 */
contract ERC721Metadata is ERC721Basic {
  function name() external view returns (string _name);
  function symbol() external view returns (string _symbol);
  function tokenURI(uint256 _tokenId) public view returns (string);
}


/**
 * @title ERC-721 Non-Fungible Token Standard, full implementation interface
 * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
 */
contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
}

/**
 * @title ERC721 Non-Fungible Token Standard basic implementation
 * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
 */
contract ERC721BasicToken is SupportsInterfaceWithLookup, ERC721Basic {

  bytes4 private constant InterfaceId_ERC721 = 0x80ac58cd;
  /*
   * 0x80ac58cd ===
   *   bytes4(keccak256('balanceOf(address)')) ^
   *   bytes4(keccak256('ownerOf(uint256)')) ^
   *   bytes4(keccak256('approve(address,uint256)')) ^
   *   bytes4(keccak256('getApproved(uint256)')) ^
   *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
   *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
   *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
   *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
   *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
   */

  bytes4 private constant InterfaceId_ERC721Exists = 0x4f558e79;
  /*
   * 0x4f558e79 ===
   *   bytes4(keccak256('exists(uint256)'))
   */

  using SafeMath for uint256;
  using AddressUtils for address;

  // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
  // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
  bytes4 private constant ERC721_RECEIVED = 0x150b7a02;

  // Mapping from token ID to owner
  mapping (uint256 => address) internal tokenOwner;

  // Mapping from token ID to approved address
  mapping (uint256 => address) internal tokenApprovals;

  // Mapping from owner to number of owned token
  mapping (address => uint256) internal ownedTokensCount;

  // Mapping from owner to operator approvals
  mapping (address => mapping (address => bool)) internal operatorApprovals;

  /**
   * @dev Guarantees msg.sender is owner of the given token
   * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
   */
  modifier onlyOwnerOf(uint256 _tokenId) {
  require(ownerOf(_tokenId) == msg.sender);
  _;
  }

  /**
   * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
   * @param _tokenId uint256 ID of the token to validate
   */
  modifier canTransfer(uint256 _tokenId) {
  require(isApprovedOrOwner(msg.sender, _tokenId));
  _;
  }

  constructor()
  public
  {
  // register the supported interfaces to conform to ERC721 via ERC165
  _registerInterface(InterfaceId_ERC721);
  _registerInterface(InterfaceId_ERC721Exists);
  }

  /**
   * @dev Gets the balance of the specified address
   * @param _owner address to query the balance of
   * @return uint256 representing the amount owned by the passed address
   */
  function balanceOf(address _owner) public view returns (uint256) {
  require(_owner != address(0));
  return ownedTokensCount[_owner];
  }

  /**
   * @dev Gets the owner of the specified token ID
   * @param _tokenId uint256 ID of the token to query the owner of
   * @return owner address currently marked as the owner of the given token ID
   */
  function ownerOf(uint256 _tokenId) public view returns (address) {
  address owner = tokenOwner[_tokenId];
  require(owner != address(0));
  return owner;
  }

  /**
   * @dev Returns whether the specified token exists
   * @param _tokenId uint256 ID of the token to query the existence of
   * @return whether the token exists
   */
  function exists(uint256 _tokenId) public view returns (bool) {
  address owner = tokenOwner[_tokenId];
  return owner != address(0);
  }

  /**
   * @dev Approves another address to transfer the given token ID
   * The zero address indicates there is no approved address.
   * There can only be one approved address per token at a given time.
   * Can only be called by the token owner or an approved operator.
   * @param _to address to be approved for the given token ID
   * @param _tokenId uint256 ID of the token to be approved
   */
  function approve(address _to, uint256 _tokenId) public {
  address owner = ownerOf(_tokenId);
  require(_to != owner);
  require(msg.sender == owner || isApprovedForAll(owner, msg.sender));

  tokenApprovals[_tokenId] = _to;
  emit Approval(owner, _to, _tokenId);
  }

  /**
   * @dev Gets the approved address for a token ID, or zero if no address set
   * @param _tokenId uint256 ID of the token to query the approval of
   * @return address currently approved for the given token ID
   */
  function getApproved(uint256 _tokenId) public view returns (address) {
  return tokenApprovals[_tokenId];
  }

  /**
   * @dev Sets or unsets the approval of a given operator
   * An operator is allowed to transfer all tokens of the sender on their behalf
   * @param _to operator address to set the approval
   * @param _approved representing the status of the approval to be set
   */
  function setApprovalForAll(address _to, bool _approved) public {
  require(_to != msg.sender);
  operatorApprovals[msg.sender][_to] = _approved;
  emit ApprovalForAll(msg.sender, _to, _approved);
  }

  /**
   * @dev Tells whether an operator is approved by a given owner
   * @param _owner owner address which you want to query the approval of
   * @param _operator operator address which you want to query the approval of
   * @return bool whether the given operator is approved by the given owner
   */
  function isApprovedForAll(
  address _owner,
  address _operator
  )
  public
  view
  returns (bool)
  {
  return operatorApprovals[_owner][_operator];
  }

  /**
   * @dev Transfers the ownership of a given token ID to another address
   * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
   * Requires the msg sender to be the owner, approved, or operator
   * @param _from current owner of the token
   * @param _to address to receive the ownership of the given token ID
   * @param _tokenId uint256 ID of the token to be transferred
  */
  function transferFrom(
  address _from,
  address _to,
  uint256 _tokenId
  )
  public
  canTransfer(_tokenId)
  {
  require(_from != address(0));
  require(_to != address(0));

  clearApproval(_from, _tokenId);
  removeTokenFrom(_from, _tokenId);
  addTokenTo(_to, _tokenId);

  emit Transfer(_from, _to, _tokenId);
  }

  /**
   * @dev Safely transfers the ownership of a given token ID to another address
   * If the target address is a contract, it must implement `onERC721Received`,
   * which is called upon a safe transfer, and return the magic value
   * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
   * the transfer is reverted.
   *
   * Requires the msg sender to be the owner, approved, or operator
   * @param _from current owner of the token
   * @param _to address to receive the ownership of the given token ID
   * @param _tokenId uint256 ID of the token to be transferred
  */
  function safeTransferFrom(
  address _from,
  address _to,
  uint256 _tokenId
  )
  public
  canTransfer(_tokenId)
  {
  // solium-disable-next-line arg-overflow
  safeTransferFrom(_from, _to, _tokenId, "");
  }

  /**
   * @dev Safely transfers the ownership of a given token ID to another address
   * If the target address is a contract, it must implement `onERC721Received`,
   * which is called upon a safe transfer, and return the magic value
   * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
   * the transfer is reverted.
   * Requires the msg sender to be the owner, approved, or operator
   * @param _from current owner of the token
   * @param _to address to receive the ownership of the given token ID
   * @param _tokenId uint256 ID of the token to be transferred
   * @param _data bytes data to send along with a safe transfer check
   */
  function safeTransferFrom(
  address _from,
  address _to,
  uint256 _tokenId,
  bytes _data
  )
  public
  canTransfer(_tokenId)
  {
  transferFrom(_from, _to, _tokenId);
  // solium-disable-next-line arg-overflow
  require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
  }

  /**
   * @dev Returns whether the given spender can transfer a given token ID
   * @param _spender address of the spender to query
   * @param _tokenId uint256 ID of the token to be transferred
   * @return bool whether the msg.sender is approved for the given token ID,
   *  is an operator of the owner, or is the owner of the token
   */
  function isApprovedOrOwner(
  address _spender,
  uint256 _tokenId
  )
  internal
  view
  returns (bool)
  {
  address owner = ownerOf(_tokenId);
  // Disable solium check because of
  // https://github.com/duaraghav8/Solium/issues/175
  // solium-disable-next-line operator-whitespace
  return (
    _spender == owner ||
    getApproved(_tokenId) == _spender ||
    isApprovedForAll(owner, _spender)
  );
  }

  /**
   * @dev Internal function to mint a new token
   * Reverts if the given token ID already exists
   * @param _to The address that will own the minted token
   * @param _tokenId uint256 ID of the token to be minted by the msg.sender
   */
  function _mint(address _to, uint256 _tokenId) internal {
  require(_to != address(0));
  addTokenTo(_to, _tokenId);
  emit Transfer(address(0), _to, _tokenId);
  }

  /**
   * @dev Internal function to burn a specific token
   * Reverts if the token does not exist
   * @param _tokenId uint256 ID of the token being burned by the msg.sender
   */
  function _burn(address _owner, uint256 _tokenId) internal {
  clearApproval(_owner, _tokenId);
  removeTokenFrom(_owner, _tokenId);
  emit Transfer(_owner, address(0), _tokenId);
  }

  /**
   * @dev Internal function to clear current approval of a given token ID
   * Reverts if the given address is not indeed the owner of the token
   * @param _owner owner of the token
   * @param _tokenId uint256 ID of the token to be transferred
   */
  function clearApproval(address _owner, uint256 _tokenId) internal {
  require(ownerOf(_tokenId) == _owner);
  if (tokenApprovals[_tokenId] != address(0)) {
    tokenApprovals[_tokenId] = address(0);
  }
  }

  /**
   * @dev Internal function to add a token ID to the list of a given address
   * @param _to address representing the new owner of the given token ID
   * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
   */
  function addTokenTo(address _to, uint256 _tokenId) internal {
  require(tokenOwner[_tokenId] == address(0));
  tokenOwner[_tokenId] = _to;
  ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
  }

  /**
   * @dev Internal function to remove a token ID from the list of a given address
   * @param _from address representing the previous owner of the given token ID
   * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
   */
  function removeTokenFrom(address _from, uint256 _tokenId) internal {
  require(ownerOf(_tokenId) == _from);
  ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
  tokenOwner[_tokenId] = address(0);
  }

  /**
   * @dev Internal function to invoke `onERC721Received` on a target address
   * The call is not executed if the target address is not a contract
   * @param _from address representing the previous owner of the given token ID
   * @param _to target address that will receive the tokens
   * @param _tokenId uint256 ID of the token to be transferred
   * @param _data bytes optional data to send along with the call
   * @return whether the call correctly returned the expected magic value
   */
  function checkAndCallSafeTransfer(
  address _from,
  address _to,
  uint256 _tokenId,
  bytes _data
  )
  internal
  returns (bool)
  {
  if (!_to.isContract()) {
    return true;
  }
  bytes4 retval = ERC721Receiver(_to).onERC721Received(
    msg.sender, _from, _tokenId, _data);
  return (retval == ERC721_RECEIVED);
  }
}

/**
 * @title Full ERC721 Token
 * This implementation includes all the required and some optional functionality of the ERC721 standard
 * Moreover, it includes approve all functionality using operator terminology
 * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
 */
contract ERC721Token is SupportsInterfaceWithLookup, ERC721BasicToken, ERC721 {

  bytes4 private constant InterfaceId_ERC721Enumerable = 0x780e9d63;
  /**
   * 0x780e9d63 ===
   *   bytes4(keccak256('totalSupply()')) ^
   *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
   *   bytes4(keccak256('tokenByIndex(uint256)'))
   */

  bytes4 private constant InterfaceId_ERC721Metadata = 0x5b5e139f;
  /**
   * 0x5b5e139f ===
   *   bytes4(keccak256('name()')) ^
   *   bytes4(keccak256('symbol()')) ^
   *   bytes4(keccak256('tokenURI(uint256)'))
   */

  // Token name
  string internal name_;

  // Token symbol
  string internal symbol_;

  // Mapping from owner to list of owned token IDs
  mapping(address => uint256[]) internal ownedTokens;

  // Mapping from token ID to index of the owner tokens list
  mapping(uint256 => uint256) internal ownedTokensIndex;

  // Array with all token ids, used for enumeration
  uint256[] internal allTokens;

  // Mapping from token id to position in the allTokens array
  mapping(uint256 => uint256) internal allTokensIndex;

  // Optional mapping for token URIs
  mapping(uint256 => string) internal tokenURIs;

  /**
   * @dev Constructor function
   */
  constructor(string _name, string _symbol) public {
  name_ = _name;
  symbol_ = _symbol;

  // register the supported interfaces to conform to ERC721 via ERC165
  _registerInterface(InterfaceId_ERC721Enumerable);
  _registerInterface(InterfaceId_ERC721Metadata);
  }

  /**
   * @dev Gets the token name
   * @return string representing the token name
   */
  function name() external view returns (string) {
  return name_;
  }

  /**
   * @dev Gets the token symbol
   * @return string representing the token symbol
   */
  function symbol() external view returns (string) {
  return symbol_;
  }

  /**
   * @dev Returns an URI for a given token ID
   * Throws if the token ID does not exist. May return an empty string.
   * @param _tokenId uint256 ID of the token to query
   */
  function tokenURI(uint256 _tokenId) public view returns (string) {
  require(exists(_tokenId));
  return tokenURIs[_tokenId];
  }

  /**
   * @dev Gets the token ID at a given index of the tokens list of the requested owner
   * @param _owner address owning the tokens list to be accessed
   * @param _index uint256 representing the index to be accessed of the requested tokens list
   * @return uint256 token ID at the given index of the tokens list owned by the requested address
   */
  function tokenOfOwnerByIndex(
  address _owner,
  uint256 _index
  )
  public
  view
  returns (uint256)
  {
  require(_index < balanceOf(_owner));
  return ownedTokens[_owner][_index];
  }

  /**
   * @dev Gets the total amount of tokens stored by the contract
   * @return uint256 representing the total amount of tokens
   */
  function totalSupply() public view returns (uint256) {
  return allTokens.length;
  }

  /**
   * @dev Gets the token ID at a given index of all the tokens in this contract
   * Reverts if the index is greater or equal to the total number of tokens
   * @param _index uint256 representing the index to be accessed of the tokens list
   * @return uint256 token ID at the given index of the tokens list
   */
  function tokenByIndex(uint256 _index) public view returns (uint256) {
  require(_index < totalSupply());
  return allTokens[_index];
  }

  /**
   * @dev Internal function to set the token URI for a given token
   * Reverts if the token ID does not exist
   * @param _tokenId uint256 ID of the token to set its URI
   * @param _uri string URI to assign
   */
  function _setTokenURI(uint256 _tokenId, string _uri) internal {
  require(exists(_tokenId));
  tokenURIs[_tokenId] = _uri;
  }

  /**
   * @dev Internal function to add a token ID to the list of a given address
   * @param _to address representing the new owner of the given token ID
   * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
   */
  function addTokenTo(address _to, uint256 _tokenId) internal {
  super.addTokenTo(_to, _tokenId);
  uint256 length = ownedTokens[_to].length;
  ownedTokens[_to].push(_tokenId);
  ownedTokensIndex[_tokenId] = length;
  }

  /**
   * @dev Internal function to remove a token ID from the list of a given address
   * @param _from address representing the previous owner of the given token ID
   * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
   */
  function removeTokenFrom(address _from, uint256 _tokenId) internal {
  super.removeTokenFrom(_from, _tokenId);

  uint256 tokenIndex = ownedTokensIndex[_tokenId];
  uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
  uint256 lastToken = ownedTokens[_from][lastTokenIndex];

  ownedTokens[_from][tokenIndex] = lastToken;
  ownedTokens[_from][lastTokenIndex] = 0;
  // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
  // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
  // the lastToken to the first position, and then dropping the element placed in the last position of the list

  ownedTokens[_from].length--;
  ownedTokensIndex[_tokenId] = 0;
  ownedTokensIndex[lastToken] = tokenIndex;
  }

  /**
   * @dev Internal function to mint a new token
   * Reverts if the given token ID already exists
   * @param _to address the beneficiary that will own the minted token
   * @param _tokenId uint256 ID of the token to be minted by the msg.sender
   */
  function _mint(address _to, uint256 _tokenId) internal {
  super._mint(_to, _tokenId);

  allTokensIndex[_tokenId] = allTokens.length;
  allTokens.push(_tokenId);
  }

  /**
   * @dev Internal function to burn a specific token
   * Reverts if the token does not exist
   * @param _owner owner of the token to burn
   * @param _tokenId uint256 ID of the token being burned by the msg.sender
   */
  function _burn(address _owner, uint256 _tokenId) internal {
  super._burn(_owner, _tokenId);

  // Clear metadata (if any)
  if (bytes(tokenURIs[_tokenId]).length != 0) {
    delete tokenURIs[_tokenId];
  }

  // Reorg all tokens array
  uint256 tokenIndex = allTokensIndex[_tokenId];
  uint256 lastTokenIndex = allTokens.length.sub(1);
  uint256 lastToken = allTokens[lastTokenIndex];

  allTokens[tokenIndex] = lastToken;
  allTokens[lastTokenIndex] = 0;

  allTokens.length--;
  allTokensIndex[_tokenId] = 0;
  allTokensIndex[lastToken] = tokenIndex;
  }

}

//
//
//

/**
Contract address: https://ropsten.etherscan.io/address/0x9fbb86758fee1d2C04B86bFd678a7A8893D3FC10#code
Token address   : https://ropsten.etherscan.io/token/0x9fbb86758fee1d2C04B86bFd678a7A8893D3FC10
Deployed at     : 0x9fbb86758fee1d2C04B86bFd678a7A8893D3FC10
Symbol          : DSN
Name            : Dissent Token
Total supply    : 1000000000
Decimals        : 0

@ MIT license
*/

// ---------------------------------------------------------------------
// ERC-20 Token Standard Interface
// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
// ---------------------------------------------------------------------
contract ERC20Interface {
/**
Returns the name of the token - e.g. "Dissent"
 */
string public name;
/**
Returns the symbol of the token. E.g. "DSN".
 */
string public symbol;
/**
Returns the number of decimals the token uses - e. g. 8
 */
uint8 public decimals;
/**
Returns the total token supply.
 */
uint256 public totalSupply;
/**
Returns the account balance of another account with address _owner.
 */
function balanceOf(address _owner) public view returns (uint256 balance);
/**
Transfers _value amount of tokens to address _to, and MUST fire the Transfer event.
The function SHOULD throw if the _from account balance does not have enough tokens to spend.
 */
function transfer(address _to, uint256 _value) public returns (bool success);
/**
Transfers _value amount of tokens from address _from to address _to, and MUST fire the Transfer event.
 */
function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
/**
Allows _spender to withdraw from your account multiple times, up to the _value amount.
If this function is called again it overwrites the current allowance with _value.
 */
function approve(address _spender, uint256 _value) public returns (bool success);
/**
Returns the amount which _spender is still allowed to withdraw from _owner.
 */
function allowance(address _owner, address _spender) public view returns (uint256 remaining);
/**
MUST trigger when tokens are transferred, including zero value transfers.
 */
event Transfer(address indexed _from, address indexed _to, uint256 _value);
/**
MUST trigger on any successful call to approve(address _spender, uint256 _value).
  */
event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}

/**
Owned contract
*/
contract Owned {
address public owner;
address public newOwner;

event OwnershipTransferred(address indexed _from, address indexed _to);

function Owned() public {
  owner = msg.sender;
}

modifier onlyOwner {
  require(msg.sender == owner);
  _;
}

function transferOwnership(address _newOwner) public onlyOwner {
  newOwner = _newOwner;
}

function acceptOwnership() public {
  require(msg.sender == newOwner);
  emit OwnershipTransferred(owner, newOwner);
  owner = newOwner;
  newOwner = address(0);
}
}

/**
Function to receive approval and execute function in one call.
*/
contract TokenRecipient {
function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public;
}

/**
Token implement
*/
contract Token is ERC20Interface, Owned {

mapping (address => uint256) public balances;
mapping (address => mapping (address => uint256)) public allowed;

// This notifies clients about the amount burnt
event Burn(address indexed from, uint256 value);

function balanceOf(address _owner) public view returns (uint256 balance) {
  return balances[_owner];
}

function transfer(address _to, uint256 _value) public returns (bool success) {
  _transfer(msg.sender, _to, _value);
  return true;
}

function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
  require(_value <= allowed[_from][msg.sender]);
  allowed[_from][msg.sender] -= _value;
  _transfer(_from, _to, _value);
  return true;
}

function approve(address _spender, uint256 _value) public returns (bool success) {
  allowed[msg.sender][_spender] = _value;
  emit Approval(msg.sender, _spender, _value);
  return true;
}

function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
  return allowed[_owner][_spender];
}

/**
Owner can transfer out any accidentally sent ERC20 tokens
 */
function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
  return ERC20Interface(tokenAddress).transfer(owner, tokens);
}

/**
Approves and then calls the receiving contract
 */
function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
  TokenRecipient spender = TokenRecipient(_spender);
  approve(_spender, _value);
  spender.receiveApproval(msg.sender, _value, this, _extraData);
  return true;
}

/**
Destroy tokens.
Remove `_value` tokens from the system irreversibly
  */
function burn(uint256 _value) public returns (bool success) {
  require(balances[msg.sender] >= _value);
  balances[msg.sender] -= _value;
  totalSupply -= _value;
  emit Burn(msg.sender, _value);
  return true;
}

/**
Destroy tokens from other account.
Remove `_value` tokens from the system irreversibly on behalf of `_from`.
  */
function burnFrom(address _from, uint256 _value) public returns (bool success) {
  require(balances[_from] >= _value);
  require(_value <= allowed[_from][msg.sender]);
  balances[_from] -= _value;
  allowed[_from][msg.sender] -= _value;
  totalSupply -= _value;
  emit Burn(_from, _value);
  return true;
}

/**
Internal transfer, only can be called by this contract
  */
function _transfer(address _from, address _to, uint _value) internal {
  // Prevent transfer to 0x0 address. Use burn() instead
  require(_to != 0x0);
  // Check if the sender has enough
  require(balances[_from] >= _value);
  // Check for overflows
  require(balances[_to] + _value > balances[_to]);
  // Save this for an assertion in the future
  uint previousBalances = balances[_from] + balances[_to];
  // Subtract from the sender
  balances[_from] -= _value;
  // Add the same to the recipient
  balances[_to] += _value;
  emit Transfer(_from, _to, _value);
  // Asserts are used to use static analysis to find bugs in your code. They should never fail
  assert(balances[_from] + balances[_to] == previousBalances);
}

}

contract DSN is Token {

function DSN() public {
  name = "Dissent Token";
  symbol = "DSN";
  decimals = 0;
  totalSupply = 1000000000;
  balances[msg.sender] = totalSupply;
}

/**
If ether is sent to this address, send it back.
 */
function () public payable {
  revert();
}

}

// 	contract ERC20Interface {
//       function transfer(address to, uint tokens) public returns (bool success);
//       function approve(address)
//     }

contract Atlas is ERC721Token, Ownable {

    /*** EVENTS ***/
    /// The event emitted (useable by web3) when a token is purchased
    event BoughtToken(address indexed buyer, uint256 tokenId);
    
    /*** CONSTANTS ***/
    uint8 constant TITLE_MIN_LENGTH = 1;
    uint8 constant TITLE_MAX_LENGTH = 64;
    
    uint8 constant ROCKY_PLANET = 0;
    uint8 constant EARTHLIKE_PLANET = 1;
    uint8 constant METAL_PLANET = 2;
    uint8 constant DESERT_PLANET = 3;
    uint8 constant GAS_PLANET = 4;
    
    uint256 public rockyPrice =  25000000000000000;
    uint256 public desertPrice = 50000000000000000;
    uint256 public gaseousPrice = 75000000000000000;
    uint256 public terraPrice = 150000000000000000;
    uint256 public metalPrice = 200000000000000000;
    uint256 public randomPrice = 42000000000000000;

    /*** RESOURCE MAPS ***/
    struct Resources {
      uint256 population;
      uint256 foodwater;
      uint256 electricity;
      uint256 minerals;
    }
    
    struct Allocations {
      uint256 currency;
      uint256 foodwater;
      uint256 electricity;
      uint256 minerals;
    }
    
    struct ResourceMultiplierLVL_1 {
      uint8 population;
      uint8 foodwater;
      uint8 currency;
      uint8 electricity;
      uint8 defense;
      uint8 minerals;
    }
    
    struct Structures {
      uint256 stations;
      uint256 sats;
      uint256 nukes;
      uint256 factories;
      uint256 scanners;
    }

    
    mapping(uint256 => Resources) public resourcesList;
    mapping(uint256 => Allocations) public allocationsList;
    mapping(uint256 => Structures) public structuresList;
    
    /*** LAST BLOCK TOKEN MINED ***/
    mapping(uint256 => uint) public lastMinedBlock;
    
    DSN acceptedToken = DSN(0xc28746cfd6bc6705e9b884759f8d7923a63a56f4);
    address ESCROW_ACCOUNT = 0x51DF563E9EAC6a59C8f1Ebb4CFeF27c68f6B9967;    
    /*** DATA TYPES ***/
    
    /// Price set by contract owner for each token in Wei.
    /// @dev If you'd like a different price for each token type, you will
    ///   need to use a mapping like: `mapping(uint256 => uint256) tokenTypePrices;`
    
    /// The title of the token
    mapping(uint256 => string) tokenTitles;
    
    /// Planet type
    mapping(uint256 => uint8) tokenTypes;
    
    /// Planet type multiplier
    mapping(uint256 => uint8) typeMultiplier;
    
    constructor() ERC721Token("Atlas", "ATLAS") public {
    // any init code when you deploy the contract would run here
    }
    
    function buyRocky(string _title) public payable {
        uint256 amount = msg.value;
        require(amount >= rockyPrice);
        require(amount <= rockyPrice + 10000);
        buyToken(1, _title, msg.sender);
        
    }
    
    function buyDesert(string _title) public payable {
        uint256 amount = msg.value;
        require(amount >= desertPrice);
        require(amount <= desertPrice + 10000);
        buyToken(2, _title, msg.sender);
    }
    
    function buyGaseous(string _title) public payable {
        uint256 amount = msg.value;
        require(amount >= gaseousPrice);
        require(amount <= gaseousPrice+ 10000);
        buyToken(3, _title, msg.sender);
    }
    
    function buyTerra(string _title) public payable {
        uint256 amount = msg.value;
        require(amount >= terraPrice);
        require(amount <= terraPrice+ 10000);
        buyToken(4, _title, msg.sender);
        
    }
    
    function buyMetal(string _title) public payable {
        uint256 amount = msg.value;
        require(amount >= metalPrice);
        require(amount <= metalPrice+ 10000);
        buyToken(5, _title, msg.sender);
    
    }
    /// Requires the amount of Ether be at least or more of the currentPrice
    /// @dev Creates an instance of an token and mints it to the purchaser
    /// @param _type The token type as an integer
    /// @param _title The short title of the token
    function buyToken(uint8 _type, string _title, address _sender) internal {
    bytes memory _titleBytes = bytes(_title);
    require(_titleBytes.length >= TITLE_MIN_LENGTH, "Title is too short");
    require(_titleBytes.length <= TITLE_MAX_LENGTH, "Title is too long");
    
    uint256 index = allTokens.length + 1;
    
    _mint(_sender, index);
    
    tokenTitles[index] = _title;
    tokenTypes[index] = _type;
      resourcesList[index] = Resources({
          population: 100,
          foodwater: 50,
          electricity: 20,
          minerals: 20
      });
    
      allocationsList[index] = Allocations({
          foodwater: 20,
          electricity: 20,
          minerals: 20,
          currency: 20
      });
    
      structuresList[index] = Structures({
          stations: 0,
          sats: 0,
          nukes: 0,
          factories: 0,
          scanners: 0
      });
    
      lastMinedBlock[index] = block.timestamp;
    
    emit BoughtToken(msg.sender, index);
    }
    
    /**
    * @dev Returns all of the tokens that the user owns
    * @return An array of token indices
    */
    function myTokens()
    external
    view
    returns (
    uint256[]
    )
    {
    return ownedTokens[msg.sender];
    }
    
    /// @notice Returns all the relevant information about a specific token
    /// @param _tokenId The ID of the token of interest
    function viewToken(uint256 _tokenId)
    external
    view
    returns (
    string tokenTitle_,
    uint8 tokenType_,
    uint256 pop_,
    uint256 foodwater_,
    uint256 electricity_,
    uint256 minerals_
    ) {
      Resources memory resources = resourcesList[_tokenId];
    tokenTitle_ = tokenTitles[_tokenId];
    tokenType_ = tokenTypes[_tokenId];
    pop_ = resources.population;
    foodwater_ = resources.foodwater;
    electricity_ = resources.electricity;
    minerals_ = resources.minerals;
    
    }
    
    function viewTokenStructures(uint256 _tokenId)
    external
    view
    returns (
      uint256 stations_,
    uint256 nukes_,
    uint256 sats_,
    uint256 factories_,
    uint256 scanners_
      ) {
          Structures memory structures = structuresList[_tokenId];
          stations_ = structures.stations;
      nukes_ = structures.nukes;
          sats_ = structures.sats;
          factories_ = structures.factories;
          scanners_ = structures.scanners;
      }
    
    function viewTokenAllocations(uint256 _tokenId)
    external
    view
    returns (
    uint256 afoodwater_,
    uint256 aelectricity_,
    uint256 aminerals_,
    uint256 acurrency_
    ) {
    Allocations memory allocations = allocationsList[_tokenId];
    afoodwater_ = allocations.foodwater;
    aelectricity_ = allocations.electricity;
    aminerals_ = allocations.minerals;
    acurrency_ = allocations.currency;
    }
    
    function viewMiningEstimation(uint256 _tokenId) external view returns (uint lastMinedBlock_, uint currentBLock_) {
      lastMinedBlock_ = lastMinedBlock[_tokenId];
      currentBLock_ = block.number;
    }
    
    function setAllocation(uint256 _tokenId, uint256 _curP, uint256 _foodwaterP, uint256 _elecP, uint256 _minP)
    external
    {
        require(msg.sender == ownerOf(_tokenId));
          require(_curP + _foodwaterP + _elecP + _minP <= 100);
          allocationsList[_tokenId] = Allocations({
              foodwater: _foodwaterP,
              electricity: _elecP,
              minerals: _minP,
              currency: _curP
          });
      }
    
      function buySpaceStation(uint256 _tokenId) external {
          Structures memory structures = structuresList[_tokenId];
          structuresList[_tokenId].stations += 1;
          require(acceptedToken.transferFrom(msg.sender, address(this), 50000));
      }
    
      // For LVL upgrades, add another param for lvl and set a multiplier for each item
    
      function _getLvl1Multiplier(uint8 _ptype) internal view returns (ResourceMultiplierLVL_1 memory) {
          if (_ptype == 0) {
              return ResourceMultiplierLVL_1({
                 population: 2,
                 foodwater: 2,
                 currency: 10,
                 electricity: 15,
                 defense: 25,
                 minerals: 25
              });
          } else if (_ptype == 1) {
              return ResourceMultiplierLVL_1({
                 population: 15,
                 foodwater: 20,
                 currency: 10,
                 electricity: 5,
                 defense: 10,
                 minerals: 15
              });
          } else if (_ptype == 2) {
              return ResourceMultiplierLVL_1({
                 population: 5,
                 foodwater: 2,
                 currency: 25,
                 electricity: 25,
                 defense: 15,
                 minerals: 10
              });
          } else if (_ptype == 3) {
              return ResourceMultiplierLVL_1({
                 population: 5,
                 foodwater: 2,
                 currency: 5,
                 electricity: 25,
                 defense: 40,
                 minerals: 25
              });
          } else if (_ptype == 4) {
              return ResourceMultiplierLVL_1({
                 population: 10,
                 foodwater: 15,
                 currency: 10,
                 electricity: 25,
                 defense: 15,
                 minerals: 10
              });
          }
      }
    
    function mineResources(uint256 _tokenId) external {
          require(msg.sender == ownerOf(_tokenId));
          uint tdelta = block.timestamp - lastMinedBlock[_tokenId];
          require(tdelta >= 3600);
          uint periods = uint(tdelta / 3600);
    
          if (periods > 99) {
              periods = 99;
          }
    
          Resources storage resources = resourcesList[_tokenId];
          Allocations memory allocations = allocationsList[_tokenId];
    
          // uint defense = uint((resources.population * allocations.defense)/100) + resources.defense;
          uint currency = uint((resources.population * allocations.currency)/500) * periods;
          uint minerals = uint((resources.population * allocations.minerals)/500) * periods;
          uint foodwater = uint(uint(uint(resources.population * allocations.foodwater)/500) / 2) * periods;
          uint electricity = _calculateResourceGeneration(resources.population, resources.electricity, periods);
          uint newpop = _calculateResourceGeneration(resources.foodwater, resources.population, periods);
    
          _setResources(_tokenId, newpop, foodwater + resources.foodwater, electricity, minerals + resources.minerals, currency * periods);
    }
    
      function _calculateResourceGeneration(uint static_resource, uint modifier_resource, uint periods) public returns (uint) {
          uint new_resource;
    
          if (static_resource > modifier_resource) {
              new_resource = uint((uint((static_resource - modifier_resource) / 100) * 20) * periods) + modifier_resource;
          } else if (static_resource < modifier_resource + uint(modifier_resource / 80)) {
              new_resource = uint(modifier_resource * uint(99 - periods)) / 100;
          } else {
               new_resource = modifier_resource;
          }
    
          return new_resource;
      }
    
    function _setResources(uint256 _tokenId, uint256 pop, uint256 foodwater, uint256 elec, uint256 min, uint256 currency) public {
        uint8 tokenType = tokenTypes[_tokenId];
        ResourceMultiplierLVL_1 memory multipliers = _getLvl1Multiplier(tokenType);
    
      lastMinedBlock[_tokenId] = block.timestamp;
      resourcesList[_tokenId] = Resources({
          population: pop + uint(uint(pop * multipliers.population) / 300),
          foodwater: foodwater + uint(uint(foodwater * multipliers.foodwater) / 300),
          electricity: elec + uint(uint(elec * multipliers.electricity) / 300),
          minerals: min + uint(uint(min * multipliers.minerals) / 300)
      });
    
      acceptedToken.transfer(msg.sender, currency + uint(currency * uint(multipliers.currency/100)));
    }
    
    
    
    
    /// @notice allows the owner of this contract to destroy the contract
    function kill() public {
    if(msg.sender == owner) selfdestruct(owner);
    }
    }
