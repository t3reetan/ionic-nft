// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./IWhitelist.sol";

contract IonicNFT is ERC721Enumerable, Ownable {
    /**
     * @dev _baseTokenURI for computing {tokenURI}. If set, the resulting URI for each
     * token will be the concatenation of the `baseURI` and the `tokenId`.
     */
    string _baseTokenURI;

    //  _price is the price of one Ionic NFT during presale
    uint256 public _presalePrice = 0.01 ether;

    //  _price is the price of one Ionic NFT during public sale
    uint256 public _publicPrice = 0.03 ether;

    // _paused is used to pause the contract in case of an emergency
    bool public _paused;

    // max number of Ionic NFT
    uint256 public maxTokenIds = 5;

    // total number of tokenIds minted
    uint256 public tokenIds;

    // Whitelist contract instance
    IWhitelist whitelist;

    // boolean to keep track of whether presale started or not
    bool public presaleStarted;

    // timestamp for when presale would end
    uint256 public presaleEnded;

    // A modifier is just some code that runs before and/or after a function call
    // They are commonly used to restrict access to certain functions, validate iniput parameters,
    // protect against certain forms of attacks, etc.
    modifier onlyWhenNotPaused() {
        require(!_paused, "Contract currently paused");
        _; // the function body of the function using this modifer is inserted here e.g. presaleMint() below
    }

    /**
     * @dev ERC721 constructor takes in a `name` and a `symbol` to the token collection.
     * name in our case is `Ionic Elements` and symbol is `IE`.
     * Constructor for Ionic Elements takes in the baseURI to set _baseTokenURI for the collection.
     * It also initializes an instance of whitelist interface.
     */
    // A constructor is an optional function that is executed when a contract is first deployed
    constructor(string memory baseURI, address whitelistContract)
        ERC721("Ionic Elements", "IE")
    {
        _baseTokenURI = baseURI;
        whitelist = IWhitelist(whitelistContract);
    }

    /**
     * @dev startPresale starts a presale for the whitelisted addresses
     */
    // onlyOwner is a modifier inherited from the Ownable.sol contract from OpenZeppelin
    // block.timestamp is the timestamp of the current Ethereum block in seconds (unit)
    function startPresale() public onlyOwner {
        presaleStarted = true;
        // Set presaleEnded time as current timestamp + 5 minutes
        // Solidity has cool syntax for timestamps (seconds, minutes, hours, days, years)
        presaleEnded = block.timestamp + 5 minutes;
    }

    /**
     * @dev presaleMint allows a user to mint one NFT per transaction during the presale.
     */
    function presaleMint() public payable onlyWhenNotPaused {
        require(
            presaleStarted && block.timestamp < presaleEnded,
            "Presale is not running"
        );
        require(
            whitelist.whitelistedAddresses(msg.sender),
            "You are not whitelisted"
        );
        require(tokenIds < maxTokenIds, "Exceeded maximum Ionic NFT supply");
        require(msg.value >= _presalePrice, "Ether amount sent is not correct");
        tokenIds += 1;

        // _safeMint(ERC721 function) is a safer version of the _mint function as it ensures that
        // if the address being minted to is a contract, it is able receive/deal with ERC721 tokens, otherwise transfer is reverted
        // If the address being minted to is not a contract, it works the same way as _mint
        _safeMint(msg.sender, tokenIds);
    }

    /**
     * @dev mint allows a user to mint 1 NFT per transaction after the presale has ended.
     */
    function mint() public payable onlyWhenNotPaused {
        require(
            presaleStarted && block.timestamp >= presaleEnded,
            "Presale has not ended yet"
        );
        require(tokenIds < maxTokenIds, "Exceed maximum Ionic NFT supply");
        require(msg.value >= _publicPrice, "Ether amount sent is not correct");
        tokenIds += 1;

        _safeMint(msg.sender, tokenIds);
    }

    /**
     * @dev _baseURI overides the Openzeppelin's ERC721 implementation which by default
     * returned an empty string for the baseURI
     */
    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }

    /**
     * @dev setPaused makes the contract paused or unpaused
     */
    function setPaused(bool val) public onlyOwner {
        _paused = val;
    }

    /**
     * @dev withdraw sends all the ether in the contract
     * to the owner of the contract
     */
    function withdraw() public onlyOwner {
        address _owner = owner();
        uint256 amount = address(this).balance;
        (bool sent, ) = _owner.call{value: amount}("");
        require(sent, "Failed to send Ether");
    }

    // Function to receive Ether. if msg.data is empty, this function is called
    receive() external payable {}

    // Fallback function to receive Ether. If msg.data is not empty, this function is called instead.
    fallback() external payable {}
}
