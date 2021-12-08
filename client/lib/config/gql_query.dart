//FOR GQLQUERY START WITH qTHENQUERYNAME

// Home page

const qHome = r'''
    query homeQuery($first: Int) {
      collections(orderBy: volumeOfEth, orderDirection: desc, first: 3) {
        cAddress
        name
        image
        creator
        metadata
        nItems
        volumeOfEth
      }
      nfts(first: $first) {
        cAddress
        tokenId
        name
        image
        collectionName
        creator
        metadata
        owner
      }
    }
''';

// Collection page

const qCollection = r'''
    query collectionQuery($cAddress: String, $creator: String) {
      users(where: {uAddress: $creator}) {
        name
        uAddress
        image
        metadata
        nItems
        volumeOfEth
      }

      nfts(where: {cAddress: $cAddress}) {
        cAddress
        tokenId
        name
        image
        collectionName
        creator
        metadata
        owner
      }
    }
''';

// NFT page

const qNFT = r'''
    query nftQuery($cAddress: String, $tokenId: Int, $creator: String) {
      users(where: {uAddress: $creator}) {
        name
        image
        uAddress
        metadata
      }
      nfts(where: {cAddress: $cAddress, tokenId: $tokenId}) {
        name
        image
        collectionName
        properties
        metadata
        creator
        owner
      }
      nftevents(where: {cAddress: $cAddress, tokenId: $tokenId}) {
        id
        eventType
        from
        to 
        price
        timestamp
      }
      bids(where: {cAddress: $cAddress, tokenId: $tokenId}) {
        from
        price
      }
    }
''';

// Creator page

const qCreator = r'''
    query creatorQuery($uAddress: String) {
      users(where: {uAddress: $uAddress}) {
        name
        uAddress
        image
        metadata
      }
      collections(where: {creator: $uAddress}) {
        cAddress
        name
        image
        nItems
      }
      nfts(where: {owner: $uAddress,creator_not:$uAddress}) {
        cAddress
        tokenId
        name
        image
        collectionName
        creator
        metadata
        owner
      }
    }
''';
