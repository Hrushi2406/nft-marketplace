//FOR GQLQUERY START WITH qTHENQUERYNAME
const qCollection = r'''
    query collectionsQuery($first: Int) {
      collections (first:$first) {
        id
      }
    }
''';
