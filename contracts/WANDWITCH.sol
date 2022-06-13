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
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/access/Ownable.sol";
import "erc721a/contracts/ERC721A.sol";

error MaxQuantityExceeded();
error InsufficientEther();
error ExceedsMaximumSupply();
error FreeMintsNotRun();
error FreeMintsAlreadyRun();

contract WanderingWitch is ERC721A, Ownable {
    uint256 public constant MINT_PRICE = 0.02;
    uint16 public constant MAX_TOKENS = 10000;

    string public baseURI = "ipfs://QmQEYuMUB6TAJMstMjdYK8m9jTniQPio28PzMWCz7tuf8r/";

    constructor() ERC721A("Wandering Witch", "WANDWITCH") {}

    function summonWitch() public payable {
        unchecked {
            if(totalSupply() == 0) revert FreeMintsNotRun();
            if(MINT_PRICE > msg.value) revert InsufficientEther();
            if(totalSupply() + 1 > MAX_TOKENS) revert ExceedsMaximumSupply();

            _mint(msg.sender, 1);
        }
    }

    // Can only be run when supply is zero
    function freeMints() external onlyOwner {
        unchecked {
            if(totalSupply() > 0) revert FreeMintsAlreadyRun();
            _mint(msg.sender, 50);
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
}