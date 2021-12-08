// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "./Marketplace.sol";

enum SellType {
    FixedPrice,
    Bidding
}

contract CustomCollection is ReentrancyGuard, ERC721URIStorage {
    // Maintaining a counter of no of nfts in collection
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    // Store collection owner/creator
    address payable public creator;

    // Store collection Metadata
    string collectionMetadataURI;

    address payable marketPlaceAddress;

    // On Collection creation
    constructor(
        string memory name_,
        string memory symbol_,
        string memory collectionMetadata_,
        address creator_
    ) ERC721(name_, symbol_) {
        creator = payable(creator_);

        marketPlaceAddress = payable(msg.sender);

        collectionMetadataURI = collectionMetadata_;
    }

    // ** NFT ** //

    // Required NFT data in contract
    struct NFT {
        bool forSale;
        SellType sellType;
        uint256 price;
        uint256 royalty;
    }

    // To store nfts (tokenId => NFT)
    mapping(uint256 => NFT) public nfts;

    // To store bids (tokenId => (address => price))
    mapping(uint256 => mapping(address => uint256)) bids;

    // tokenId to secret
    mapping(uint256 => string) unlockableContent;

    // On minting of Nft
    event NFTCreated(
        address cAddress,
        uint256 tokenId,
        string name,
        string image,
        string properties,
        string metadata
    );

    // On mint/transfer/sale of nft
    event NFTEvent(
        address cAddress,
        uint256 tokenId,
        string eventType,
        address from,
        address to,
        uint256 price
    );

    // On bid placed
    event BidPlaced(
        address cAddress,
        uint256 tokenId,
        address from,
        uint256 price
    );

    // On bid canceled
    event BidCanceled(address cAddress, uint256 tokenId, address from);

    // Checks if tokenId exists
    modifier tokenExists(uint256 tokenId) {
        require(
            tokenId <= _tokenIds.current(),
            "CustomCollection -> tokenId doesn't correspond to any NFT"
        );
        _;
    }

    // Checks if owner of tokenId is caller
    modifier callerIsNftOwner(uint256 tokenId) {
        // Only owner of token can access secret
        require(
            msg.sender == ownerOf(tokenId),
            "CustomCollection -> Caller is not nft owner"
        );
        _;
    }

    // Checks if owner of tokenId is not caller
    modifier callerIsNotNftOwner(uint256 tokenId) {
        // Only owner of token can access secret
        require(
            msg.sender != ownerOf(tokenId),
            "CustomCollection -> Caller is nft owner"
        );
        _;
    }

    // Checks if NFT is listed for bids
    modifier isBiddable(uint256 tokenId) {
        require(
            nfts[tokenId].sellType == SellType.Bidding,
            "CustomCollection -> NFT doesn't allow bidding"
        );
        _;
    }

    // List NFT on Marketplace
    function mintNFT(
        string memory name_,
        string memory image_,
        string memory properties_,
        string memory metadata_,
        bool forSale_,
        bool isFixedPrice_,
        uint256 price_,
        uint256 royalty_,
        string memory unlockableString_
    ) public {
        require(
            msg.sender == creator,
            "CustomCollection : mintToken -> Not collection owner"
        );

        _tokenIds.increment();
        uint256 tokenId = _tokenIds.current();

        // ERC721 Mint
        _safeMint(msg.sender, tokenId);

        // ERC721 set Metadata
        _setTokenURI(tokenId, metadata_);

        // In case of bidding nft transfer is called by owner of nft
        // But for fixed price nft transfer can be only done by marketplace
        if (isFixedPrice_) {
            // ERC721 approve marketplace to manage owner's current token
            approve(marketPlaceAddress, tokenId);
        }

        // Set unlockableContent
        unlockableContent[tokenId] = unlockableString_;

        // Store nft in marketplace
        nfts[tokenId] = NFT({
            forSale: forSale_,
            sellType: isFixedPrice_ ? SellType.FixedPrice : SellType.Bidding,
            price: price_,
            royalty: royalty_
        });

        // Log events to subgraph
        emit NFTCreated(
            address(this),
            tokenId,
            name_,
            image_,
            properties_,
            metadata_
        );

        emit NFTEvent(
            address(this),
            tokenId,
            "Minted",
            address(0),
            msg.sender,
            0
        );
    }

    // Buy Fixed Price NFT
    function buyFixedPriceNFT(uint256 tokenId)
        public
        payable
        nonReentrant
        tokenExists(tokenId)
        callerIsNotNftOwner(tokenId)
    {
        NFT memory nft = nfts[tokenId];

        require(
            nft.sellType == SellType.FixedPrice,
            "CustomCollection : placeBid -> NFT is listed for bids only"
        );
        require(
            nft.forSale,
            "CustomCollection : buyFixedPriceNFT -> NFT is not for sale"
        );
        require(
            msg.value == nft.price,
            "CustomCollection : buyFixedPriceNFT -> Please send exact amount as price"
        );

        // Tranfer eth to creator as royalty
        creator.transfer(((nft.price * nft.royalty) / 100));

        // Marketplace gets 1% commission
        marketPlaceAddress.transfer(nft.price / 100);

        // Tranfer remaining eth to current owner
        payable(ownerOf(tokenId)).transfer(
            (nft.price * (100 - nft.royalty - 1)) / 100
        );

        // Transfer nft to msg.sender
        Marketplace(marketPlaceAddress).marketPlaceTransferFrom(
            address(this),
            ownerOf(tokenId),
            msg.sender,
            tokenId
        );

        // New owner has to approve marketplace to manage his token
        approve(marketPlaceAddress, tokenId);

        // Unlist item
        nfts[tokenId].forSale = false;

        // Log event to subgraph
        emit NFTEvent(
            address(this),
            tokenId,
            "Sold",
            ownerOf(tokenId),
            msg.sender,
            nft.price / 1e12
        );
    }

    // Places bid. Recieves eth from user which are held by the contract
    function placeBid(uint256 tokenId)
        public
        payable
        tokenExists(tokenId)
        callerIsNotNftOwner(tokenId)
        isBiddable(tokenId)
    {
        require(
            bids[tokenId][msg.sender] == 0,
            "CustomCollection : placeBid -> Can't bid twice. Cancel Previous bid"
        );
        require(
            msg.value >= nfts[tokenId].price,
            "CustomCollection : placeBid -> Can't bid lower than nft's minimum price"
        );

        // Add bid on chain
        bids[tokenId][msg.sender] = msg.value;

        // Log event to subgraph
        emit BidPlaced(address(this), tokenId, msg.sender, msg.value / 1e12);
    }

    // Cancels bid
    function cancelBid(uint256 tokenId)
        public
        tokenExists(tokenId)
        isBiddable(tokenId)
    {
        require(
            bids[tokenId][msg.sender] != 0,
            "CustomCollection -> No bid by caller"
        );

        uint256 bidAmount = bids[tokenId][msg.sender];

        // Remove bid on chain
        bids[tokenId][msg.sender] = 0;

        // Transfer bidder's eth back
        payable(msg.sender).transfer(bidAmount);

        // Log event to subgraph
        emit BidCanceled(address(this), tokenId, msg.sender);
    }

    // Sell NFT to a bidder
    function sellBiddingNFT(uint256 tokenId, address to_)
        public
        nonReentrant
        tokenExists(tokenId)
        callerIsNftOwner(tokenId)
        isBiddable(tokenId)
    {
        require(
            bids[tokenId][to_] != 0,
            "CustomCollection -> No bid by user 'to_'"
        );

        // Tranfer eth to creator as royalty
        creator.transfer(((bids[tokenId][to_] * nfts[tokenId].royalty) / 100));

        // Marketplace gets 1% commission
        marketPlaceAddress.transfer(bids[tokenId][to_] / 100);

        // Tranfer remaining eth to current owner
        payable(ownerOf(tokenId)).transfer(
            (bids[tokenId][to_] * (100 - nfts[tokenId].royalty - 1)) / 100
        );

        // Transfer nft to msg.sender
        safeTransferFrom(msg.sender, to_, tokenId);

        // Log event to subgraph
        emit NFTEvent(
            address(this),
            tokenId,
            "Sold",
            ownerOf(tokenId),
            to_,
            bids[tokenId][to_] / 1e12
        );

        emit BidCanceled(address(this), tokenId, to_);
    }

    // Get unlockable content to owner of nft
    function getUnlockableContent(uint256 tokenId)
        public
        view
        tokenExists(tokenId)
        callerIsNftOwner(tokenId)
        returns (string memory)
    {
        return unlockableContent[tokenId];
    }

    // Modify listing mechanism
    function modifyListingMechanism(
        uint256 tokenId,
        bool setFixPrice,
        bool forSale,
        uint256 newPrice
    )
        public
        // address[] memory bidders
        tokenExists(tokenId)
        callerIsNftOwner(tokenId)
    {
        // For fixed price tokens
        if (nfts[tokenId].sellType == SellType.FixedPrice) {
            if (!setFixPrice) {
                // Convert to bidding and change price
                nfts[tokenId].sellType = SellType.Bidding;
                nfts[tokenId].price = newPrice;
            } else {
                // Change price and forSale status
                nfts[tokenId].forSale = forSale;
                nfts[tokenId].price = newPrice;
            }
        }
        // For bidding tokens
        // else {
        //     if(setFixPrice) {
        //         // Convert to fixed price and change price, forSale
        //         nfts[tokenId].sellType = SellType.FixedPrice;
        //         nfts[tokenId].forSale = forSale;
        //         nfts[tokenId].price = newPrice;

        //         // Approve marketplace to trade this token
        //         approve(marketPlaceAddress, tokenId);

        //         // Cancel all bids, Return their money, emit events
        //         for(uint i=0; i<bidders.length; i++) {
        //             // Transfer bidder's eth back
        //             payable(bidders[i]).transfer(bids[tokenId][bidders[i]]);

        //             // Remove bid on chain
        //             bids[tokenId][bidders[i]] = 0;

        //             // Log event to subgraph
        //             emit BidCanceled(address(this), tokenId, bidders[i]);
        //         }

        //     } else {
        //         // Change minimum price
        //         nfts[tokenId].price = newPrice;
        //     }
        // }
    }

    // // struct for entire collection data
    // struct Collection {
    //     address cAddress;
    //     string name;
    //     string symbol;
    //     string metadataURI;
    //     address creator;
    // }

    // // Get collection overview
    // function getCollectionOverview() public view returns (Collection memory) {
    //     return
    //         Collection(
    //             address(this),
    //             name(),
    //             symbol(),
    //             collectionMetadataURI,
    //             creator
    //         );
    // }

    // // Get NFT Overview
    // function getNFTOverview(uint256 tokenId_)
    //     public
    //     view
    //     returns (
    //         address cAddress,
    //         uint256 tokenId,
    //         address owner,
    //         string memory metadataURI,
    //         NFT memory
    //     )
    // {
    //     require(
    //         tokenId_ <= _tokenIds.current(),
    //         "CustomCollection : sellBiddingNFT -> tokenId doesn't correspond to any NFT"
    //     );

    //     return (
    //         address(this),
    //         tokenId_,
    //         ownerOf(tokenId_),
    //         tokenURI(tokenId_),
    //         nfts[tokenId_]
    //     );
    // }
}
