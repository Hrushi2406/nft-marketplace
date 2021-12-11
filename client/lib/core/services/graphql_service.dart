import 'package:flutter/material.dart';
import 'package:gql/language.dart';
import 'package:graphql/client.dart';

class GraphqlService {
  final GraphQLClient client;

  GraphqlService(this.client);

  ///GET METHOD FOR GRAPHQL TO FETCH DATA
  Future<Map<String, dynamic>> get(
    String query, [
    Map<String, dynamic>? variables,
  ]) async {
    //BUILD QUERY
    final options = QueryOptions(
      document: parseString(query),
      variables: variables ?? {},
      cacheRereadPolicy: CacheRereadPolicy.mergeOptimistic,
      fetchPolicy: FetchPolicy.cacheAndNetwork,
    );

    final result = await client.query(options);

    //IF ERRORS THROW ERROR MESSAGE
    if (result.hasException) {
      debugPrint(result.exception.toString());

      final errMessage = result.exception!.graphqlErrors[0].message;

      throw errMessage;
    }

    //RETURN DATA
    return result.data!;
  }
}
