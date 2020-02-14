pragma solidity ^0.5.0;

import "github.com/OpenZeppelin/zeppelin-solidity/contracts/token/ERC721/ERC721Full.sol";
import "./DSNERC20_Remix.sol";

contract owned {
    constructor() public { owner = msg.sender; }
    address owner;

    // This contract only defines a modifier but does not use
    // it: it will be used in derived contracts.
    // The function body is inserted where the special symbol
    // `_;` in the definition of a modifier appears.
    // This means that if the owner calls this function, the
    // function is executed and otherwise, an exception is
    // thrown.
    modifier onlyOwner {
        require(
            msg.sender == owner,
            "Only owner can call this function."
        );
        _;
    }
}

/**
 * @title ERC721MetadataMintable
 * @dev ERC721 minting logic with metadata.
 */
contract ERC721MetadataMintable is ERC721Full {
    /**
     * @dev Function to mint tokens.
     * @param to The address that will receive the minted tokens.
     * @param tokenId The token id to mint.
     * @param tokenURI The token URI of the minted token.
     * @return A boolean that indicates if the operation was successful.
     */
    function mintWithTokenURI(address to, uint256 tokenId, string memory tokenURI) internal returns (bool) {
        _mint(to, tokenId);
        _setTokenURI(tokenId, tokenURI);
        return true;
    }
}

contract Atlas is ERC721MetadataMintable, owned {
    constructor(address _accepted_token) ERC721Full("Atlas Token", "ATLAS") public { 
        acceptedToken = DSN(_accepted_token);
    }
    
    /*** EVENTS ***/
    /// The event emitted (useable by web3) when a token is purchased
    event BoughtToken(address indexed buyer, uint256 tokenId);
    
    /*** CONSTANTS ***/
    DSN acceptedToken;
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
    
    address ESCROW_ACCOUNT = 0xc801C9a6Cf88a77230A864c141c7fA58DCC308Cc;  
    
    
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
    
    function setBaseURI(string memory _baseURI) public onlyOwner {
        _setBaseURI(_baseURI);
    }
    
    // function setTokenURI(uint256 _tokenId, string memory _tokenURI) public onlyOwner {
    //     _setTokenURI(_tokenId, _tokenURI);
    // }
    
    /**
    * @dev Returns all of the tokens that the user owns
    * @return An array of token indices
    */
    function myTokens() external view returns (uint256[] memory) {
        return _tokensOfOwner(msg.sender);
    }
    
    function buyRocky(string memory _title) public payable {
        uint256 amount = msg.value;
        require(amount >= rockyPrice);
        require(amount <= rockyPrice + uint256(rockyPrice / 2));
        buyToken(1, _title, msg.sender);
        
    }
    
    function buyDesert(string memory _title) public payable {
        uint256 amount = msg.value;
        require(amount >= desertPrice);
        require(amount <= desertPrice + uint256(rockyPrice / 2));
        buyToken(2, _title, msg.sender);
    }
    
    function buyGaseous(string memory _title) public payable {
        uint256 amount = msg.value;
        require(amount >= gaseousPrice);
        require(amount <= gaseousPrice+ uint256(rockyPrice / 2));
        buyToken(3, _title, msg.sender);
    }
    
    function buyTerra(string memory _title) public payable {
        uint256 amount = msg.value;
        require(amount >= terraPrice);
        require(amount <= terraPrice+ uint256(rockyPrice / 2));
        buyToken(4, _title, msg.sender);
        
    }
    
    function buyMetal(string memory _title) public payable {
        uint256 amount = msg.value;
        require(amount >= metalPrice);
        require(amount <= metalPrice+ uint256(rockyPrice / 2));
        buyToken(5, _title, msg.sender);
    
    }
    /// Requires the amount of Ether be at least or more of the currentPrice
    /// @dev Creates an instance of an token and mints it to the purchaser
    /// @param _type The token type as an integer
    /// @param _title The short title of the token
    function buyToken(uint8 _type, string memory _title, address _sender) internal {
    bytes memory _titleBytes = bytes(_title);
    require(_titleBytes.length >= TITLE_MIN_LENGTH, "Title is too short");
    require(_titleBytes.length <= TITLE_MAX_LENGTH, "Title is too long");
    
    uint256 index = totalSupply() + 1;
    string memory uriIndex = _uint2str(index);
    string memory uriJson = ".json";
    
    mintWithTokenURI(_sender, index, joinStrings(uriIndex, uriJson));
    
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
    // function myTokens()
    // external
    // view
    // returns (
    // uint256[]
    // )
    // {
    // return ownedTokens[msg.sender];
    // }
    
    /// @notice Returns all the relevant information about a specific token
    /// @param _tokenId The ID of the token of interest
    function viewToken(uint256 _tokenId)
    external
    view
    returns (
    string memory tokenTitle_,
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
        //   require(tdelta >= 3600);
        //   uint periods = uint(tdelta / 3600);
            uint periods = 5;
    
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
        require(msg.sender == ownerOf(_tokenId));
        
        uint8 tokenType = tokenTypes[_tokenId];
        ResourceMultiplierLVL_1 memory multipliers = _getLvl1Multiplier(tokenType);
    
      lastMinedBlock[_tokenId] = block.timestamp;
      resourcesList[_tokenId] = Resources({
          population: pop + uint(uint(pop * multipliers.population) / 300),
          foodwater: foodwater + uint(uint(foodwater * multipliers.foodwater) / 300),
          electricity: elec + uint(uint(elec * multipliers.electricity) / 300),
          minerals: min + uint(uint(min * multipliers.minerals) / 300)
      });
    
      acceptedToken.transferFrom(ESCROW_ACCOUNT, ownerOf(_tokenId), currency + uint(currency * uint(multipliers.currency/100)));
    }
    
    function joinStrings(string memory a, string memory b) internal pure returns (string memory) {
    
        return string(abi.encodePacked(a, b));
    
    }
    
    function _uint2str(uint256 _i) internal pure returns (string memory _uintAsString) {
        if (_i == 0) {
          return "0";
        }
    
        uint256 j = _i;
        uint256 ii = _i;
        uint256 len;
    
        // Get number of bytes
        while (j != 0) {
          len++;
          j /= 10;
        }
    
        bytes memory bstr = new bytes(len);
        uint256 k = len - 1;
    
        // Get each individual ASCII
        while (ii != 0) {
          bstr[k--] = byte(uint8(48 + ii % 10));
          ii /= 10;
        }
    
        // Convert to string
        return string(bstr);
      }
    
    /// @notice allows the owner of this contract to destroy the contract
    // function kill() public {
    //     if(msg.sender == owner) selfdestruct(owner);
    // }
}