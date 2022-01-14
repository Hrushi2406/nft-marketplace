import '../core/utils/utils.dart';

class ListingInfo {
  late bool forSale;
  late bool isFixedPrice;
  final ListingType listingType;
  final double price;
  final int royalties;

  ListingInfo({
    required this.listingType,
    required this.price,
    required this.royalties,
  }) {
    forSale = listingType == ListingType.fixedPriceSale;

    isFixedPrice = !(listingType == ListingType.bidding);

    // listingType == ListingType.fixedPriceSale ||
    // listingType == ListingType.fixedPriceNotSale;
  }
}
