import 'package:flutter/material.dart';
import 'package:gql/language.dart';
import 'package:graphql/client.dart';

class GraphqlService {
  late final GraphQLClient client;

  final String url =
      'https://api.thegraph.com/subgraphs/name/sumit-mahajan/nft-marketplace';

  GraphqlService() {
    final _httpLink = HttpLink(url);

    client = GraphQLClient(
      link: _httpLink,
      cache: GraphQLCache(),
    );
  }

  ///GET METHOD FOR GRAPHQL TO FETCH DATA
  Future<Map<String, dynamic>?> get(
    String query, [
    Map<String, dynamic>? variables,
  ]) async {
    //BUILD QUERY
    final options = QueryOptions(
      document: parseString(query),
      variables: variables ?? {},
    );

    final result = await client.query(options);

    //IF ERRORS THROW ERROR MESSAGE

    if (result.hasException) {
      debugPrint(result.exception.toString());

      final errMessage = result.exception!.graphqlErrors[0].message;

      throw errMessage;
    }

    //RETURN DATA
    return result.data;
  }
}
