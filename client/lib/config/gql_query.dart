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
        cName
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
      }
      nfts(where: {cAddress: $cAddress}) {
        cAddress
        tokenId
        name
        image
        cName
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
      }
      collections(where: {cAddress: $cAddress}) {
        name
        image
      }
      nfts(where: {cAddress: $cAddress, tokenId: $tokenId}) {
        name
        image
        cName
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
        twitterUrl
        websiteUrl
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
        cName
        creator
        metadata
        owner
      }
    }
''';
