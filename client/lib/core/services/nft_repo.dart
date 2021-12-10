import 'package:nfts/config/functions.dart';
import 'package:nfts/config/gql_query.dart';
import 'package:nfts/core/services/contract_service.dart';
import 'package:nfts/core/utils/utils.dart';
import 'package:nfts/models/listing_info.dart';
import 'package:web3dart/web3dart.dart';

class NFTRepo {
  final Web3Client _client;
  final ContractService _contractService;

  NFTRepo(this._client, this._contractService);

  Future<ListingInfo> getNFTListingInfo(
      String contractAddress, int tokenId) async {
    final contract =
        await _contractService.loadCollectionContract(contractAddress);

    final data = await _client.call(
      contract: contract,
      function: contract.function(fnfts),
      params: [BigInt.from(tokenId)],
    );

    final forSale = data[0] as bool;
    final listingType = data[1] == BigInt.from(1)
        ? ListingType.bidding
        : forSale
            ? ListingType.fixedPriceSale
            : ListingType.fixedPriceNotSale;

    final price = EtherAmount.inWei(data[2]).getValueInUnit(EtherUnit.ether);

    return ListingInfo(
      listingType: listingType,
      price: price.toDouble(),
      royalties: (data[3] as BigInt).toInt(),
    );
  }
}
