// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

// ERC
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

// Utils
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

// Dev
import "hardhat/console.sol";

contract SongStorage is ERC721URIStorage {
    struct Song {
        uint tokenId;
        string name;
    }

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    mapping(uint256 => Song) public tokenIdSongMap;

    event OnMinted(address sender, uint256 tokenId);

    constructor() ERC721("Song", "SONG") {
    }

    function createScore(string memory midi) internal pure returns (string memory) {
        return Base64.encode(abi.encodePacked(midi));
    }

    function mint(string memory name, string memory body) public returns (uint256) {
        uint256 newItemId = _tokenIds.current();

        _safeMint(msg.sender, newItemId);
    	_setTokenURI(newItemId, body);

        console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);

        _tokenIds.increment();

        tokenIdSongMap[newItemId] = Song( {tokenId: newItemId, name: name} );

        emit OnMinted(msg.sender, newItemId);

        return newItemId;
    }

    function getSongs() public view returns (Song[] memory) {
        return getSongsByAddress(msg.sender);
    }

    function getSongsByAddress(address ownerAddress) public view returns(Song[] memory) {
        uint256 tokenCount = balanceOf(ownerAddress);

        Song[] memory songs = new Song[](tokenCount);

        uint256 maxId = _tokenIds.current();
        uint256 resultIndex = 0;

        for (uint256 i = 0; i < maxId; i++) {
            if (ownerOf(i) == ownerAddress) {
                songs[resultIndex] = tokenIdSongMap[i];
                resultIndex++;
            }
        }

        return songs;
    }    
}
