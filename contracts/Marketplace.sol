// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

import "./CustomERC721Collection.sol";

contract Marketplace {
    // ** User ** //

    // Required user data in contract
    struct User {
        string name;
        string metadataURI;
    }

    // To store users (address => User)
    mapping(address => User) public users;

    // On user creation
    event UserCreated(
        address uAddress,
        string name,
        string image,
        string metadata
    );

    // Create/Update user profile
    function createUser(
        string memory name_,
        string memory image_,
        string memory metadata_
    ) public {
        // Map metadata to address
        users[msg.sender] = User(name_, metadata_);

        // Log event to subgraph
        emit UserCreated(msg.sender, name_, image_, metadata_);
    }

    // ** Custom Collection ** //

    // To store if collection is listed (address => bool)
    mapping(address => bool) listedCollections;

    // On collection creation
    event CollectionCreated(
        address cAddress,
        string name,
        string image,
        address creator,
        string metadata
    );

    // List collection on marketplace
    function listCollection(
        address cAddress_,
        string memory name_,
        string memory image_,
        string memory metadata_
    ) public {
        // Check if collection contract exists
        try CustomERC721Collection(cAddress_).creator() returns (
            address payable owner_
        ) {
            // Check if caller is collection
            require(
                msg.sender == owner_,
                "Marketplace : createCollection -> Caller is not collection owner"
            );
        } catch {
            revert(
                "Marketplace : createCollection -> Collection contract doesn't exist"
            );
        }

        // Stop if marketplace record exists i.e. prevent updates
        require(
            !listedCollections[cAddress_],
            "Marketplace : createCollection -> Collection already exists on marketplace"
        );

        // Store collection in marketplace
        listedCollections[cAddress_] = true;

        // Log event to subgraph
        emit CollectionCreated(cAddress_, name_, image_, msg.sender, metadata_);
    }

    // To buy fixed price nfts
    function marketPlaceTransferFrom(
        address cAddress,
        address nftOwner,
        address newOwner,
        uint256 tokenId
    ) public {
        // Check if caller is collection
        require(
            msg.sender == cAddress,
            "Marketplace : marketPlaceTransferFrom -> Caller is not contract"
        );

        CustomERC721Collection(cAddress).safeTransferFrom(
            nftOwner,
            newOwner,
            tokenId
        );
    }

    // To receive ether
    // Function to receive Ether. msg.data must be empty
    receive() external payable {}

    // TODO: Get Matic / USD
}
