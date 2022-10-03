/**
 *
 *                                   '||                   ||                   
 * ... ... ...  ....   .. ...      .. ||    ....  ... ..  ...  .. ...     ... . 
 *  ||  ||  |  '' .||   ||  ||   .'  '||  .|...||  ||' ''  ||   ||  ||   || ||  
 *   ||| |||   .|' ||   ||  ||   |.   ||  ||       ||      ||   ||  ||    |''   
 *    |   |    '|..'|' .||. ||.  '|..'||.  '|...' .||.    .||. .||. ||.  '||||. 
 *                                                                      .|....' 
 *                                                                             
 *                       ||    .           '||                                           
 *          ... ... ... ...  .||.    ....   || ..     ....   ....                        
 *           ||  ||  |   ||   ||   .|   ''  ||' ||  .|...|| ||. '                        
 *            ||| |||    ||   ||   ||       ||  ||  ||      . '|..                       
 *             |   |    .||.  '|.'  '|...' .||. ||.  '|...' |'..|'   
 *
 *
 *     dreams whisper shades of selves into realms where we may wander
 *
 *                        contract by: ens0.eth
 */
pragma solidity ^0.8.14;

import "@openzeppelin/contracts/access/Ownable.sol";
import "erc721a/contracts/ERC721A.sol";

error MaxQuantityExceeded();
error InsufficientEther();
error ExceedsMaximumSupply();
error FreeMintsNotRun();
error FreeMintsAlreadyRun();

contract WanderingWitches is ERC721A, Ownable {
    uint256 public mint1Price = 0.07 ether;
    uint256 public mint3Price = 0.2 ether;
    uint256 public mint5Price = 0.3 ether;

    uint16 public constant MAX_TOKENS = 5622;

    string public baseURI = "";

    constructor() ERC721A("Wandering Witches", "WANDWITCH") {}

    function mintWitch() public payable {
        unchecked {
            if(totalSupply() == 0) revert FreeMintsNotRun();
            if(mint1Price > msg.value) revert InsufficientEther();
            if(totalSupply() + 1 > MAX_TOKENS) revert ExceedsMaximumSupply();

            _mint(msg.sender, 1);
        }
    }

    function mint3Witches() public payable {
        unchecked {
            if(totalSupply() == 0) revert FreeMintsNotRun();
            if(mint3Price > msg.value) revert InsufficientEther();
            if(totalSupply() + 3 > MAX_TOKENS) revert ExceedsMaximumSupply();

            _mint(msg.sender, 3);
        }
    }

    function mint5Witches() public payable {
        unchecked {
            if(totalSupply() == 0) revert FreeMintsNotRun();
            if(mint5Price > msg.value) revert InsufficientEther();
            if(totalSupply() + 5 > MAX_TOKENS) revert ExceedsMaximumSupply();

            _mint(msg.sender, 5);
        }
    }

    // Can only be run when supply is zero
    function freeMints() external onlyOwner {
        unchecked {
            if(totalSupply() > 0) revert FreeMintsAlreadyRun();
            _mint(msg.sender, 22);
        }
    }

    function withdraw() external onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }

    function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }

    function setBaseURI(string memory newBaseURI) public onlyOwner {
        baseURI = newBaseURI;
    }

    function setMint1Price(uint256 newPrice) public onlyOwner {
        mint1Price = newPrice;
    }

    function setMint3Price(uint256 newPrice) public onlyOwner {
        mint3Price = newPrice;
    }

    function setMint5Price(uint256 newPrice) public onlyOwner {
        mint5Price = newPrice;
    }
}