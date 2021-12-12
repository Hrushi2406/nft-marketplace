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
      nfts(first: $first, orderBy: tokenId) {
        cAddress
        tokenId
        metadata
        name
        image
        cName
        cImage
        creator
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
        metadata
        name
        image
        cName
        cImage
        creator
        metadata
        owner
      }
    }
''';

const qUserCollection = r'''

    query collectionQuery($uAddress: String) {
      collections(where: {creator: $uAddress}) {
        cAddress
        name
        image
        creator
        metadata
        nItems
        volumeOfEth
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
        cAddress
        name
        image
        creator
        metadata
        nItems
        volumeOfEth
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
        creator
        metadata
        nItems
        volumeOfEth
      }
      nfts(where: {owner: $uAddress,creator_not:$uAddress}) {
        cAddress
        tokenId
        metadata
        name
        image
        cName
        cImage
        creator
        owner
      }

    }
''';

//  nfts(where: {cAddress: $cAddress, tokenId: $tokenId}) {
//       name
//       image
//       cName
//       properties
//       metadata
//       creator
//       owner
//     }

const qSearchName = r'''

 query searchName($name: String) {
    collections(where: {name_contains:$name}) {
        cAddress
        name
        image
        creator
        metadata
        nItems
        volumeOfEth
  }
      nfts(where:{name_contains:$name}, first:15) {
        cAddress
        tokenId
        metadata
        name
        image
        cName
        cImage
        creator
        owner
      }
      users(where: {name_contains: $name}) {
        name
        uAddress
        image
        twitterUrl
        websiteUrl
      }
    }

''';

const qSearchAddress = r'''
 query searchAddress($address: String) {
    collections(where: {cAddress_contains:$address}) {
        cAddress
        name
        image
        creator
        metadata
        nItems
        volumeOfEth
  }
      nfts(where:{cAddress_contains:$address}) {
        cAddress
        tokenId
        metadata
        name
        image
        cName
        cImage
        creator
        owner
      }
      users(where: {uAddress_contains: $address}) {
        name
        uAddress
        image
        twitterUrl
        websiteUrl
      }
    }
''';
