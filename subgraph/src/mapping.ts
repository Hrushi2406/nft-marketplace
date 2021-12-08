import {
  CollectionCreated as CollectionCreatedEvent,
  UserCreated as UserCreatedEvent,
} from "../generated/Marketplace/Marketplace";
import {
  NFTCreated as NFTCreatedEvent,
  BidPlaced as BidPlacedEvent,
  BidCanceled as BidCanceledEvent,
  NFTEvent as NFTEventEvent,
  Transfer as TransferEvent,
} from "../generated/templates/CustomERC721Collection/CustomERC721Collection";
import { User, Collection, NFT, Bid, NFTEvent } from "../generated/schema";
import { CustomCollection } from "../generated/templates";
import { store } from "@graphprotocol/graph-ts";

// Called whenever user profile is created or updated
export function handleUserCreated(event: UserCreatedEvent): void {
  // Update
  let entity = User.load(event.params.uAddress.toHex());

  if (entity == null) {
    // Create
    entity = new User(event.params.uAddress.toHex());
  }

  entity.uAddress = event.params.uAddress;
  entity.name = event.params.name;
  entity.image = event.params.image;
  entity.twitterUrl = event.params.twitterUrl;
  entity.websiteUrl = event.params.websiteUrl;

  entity.save();
}

// Called whenever a new collection is listed on marketplace
export function handleCollectionCreated(event: CollectionCreatedEvent): void {
  // Start tracking new CustomERC721Collection contract with cAddress
  CustomCollection.create(event.params.cAddress);

  let entity = new Collection(event.params.cAddress.toHex());
  entity.cAddress = event.params.cAddress;
  entity.name = event.params.name;
  entity.image = event.params.image;
  entity.creator = event.params.creator;
  entity.nItems = 0;
  entity.volumeOfEth = 0;
  entity.metadata = event.params.metadata;

  entity.save();
}

// Called whenever a new NFT is minted on marketplace
export function handleNFTCreated(event: NFTCreatedEvent): void {
  // Update nItems of collection
  let collection = Collection.load(event.params.cAddress.toHex());
  collection!.nItems += 1;
  collection!.save();

  let entity = new NFT(
    event.params.cAddress.toHex() + event.params.tokenId.toHex()
  );
  entity.cAddress = event.params.cAddress;
  entity.tokenId = event.params.tokenId.toI32();
  entity.name = event.params.name;
  entity.image = event.params.image;
  entity.properties = event.params.properties;
  entity.cName = collection!.name;
  entity.cImage = collection!.image;
  entity.creator = collection!.creator;
  entity.owner = collection!.creator;
  entity.metadata = event.params.metadata;

  entity.save();
}

// Called whenever an NFT is Minted / Sold on marketplace i.e. tracks NFT activity
export function handleNFTEvent(event: NFTEventEvent): void {
  // Update trading volume of collection
  let collection = Collection.load(event.params.cAddress.toHex());
  collection!.volumeOfEth += event.params.price.toI32();
  collection!.save();

  // Update owner of NFT
  let nft = NFT.load(
    event.params.cAddress.toHex() + event.params.tokenId.toHex()
  );
  nft!.owner = event.params.to;
  nft!.save();

  // If Transfer event is detected first
  // let entity = NFTEvent.load(event.transaction.hash.toHex())

  // If NFTEvent is detected first
  // if (entity == null) {
  let entity = new NFTEvent(event.transaction.hash.toHex());
  // }

  entity.cAddress = event.params.cAddress;
  entity.tokenId = event.params.tokenId.toI32();
  entity.eventType = event.params.eventType;
  entity.from = event.params.from;
  entity.to = event.params.to;
  entity.price = event.params.price.toI32();
  entity.timestamp = event.block.timestamp;

  entity.save();
}

// Called whenever a user transfers NFT personally and not through marketplace
// export function handleTransfer(event: TransferEvent): void {
//   If NFTEvent transaction is already there means marketplace was involved
//   let entity = NFTEvent.load(event.transaction.hash.toHex())

// If Marketplace is not involved
//   if (!entity) {
//     entity = new NFTEvent(event.transaction.hash.toHex())

//     entity.cAddress = event.transaction.to!
//     entity.tokenId = event.params.tokenId.toI32()
//     entity.eventType = "Transfer"
//     entity.from = event.params.from
//     entity.to = event.params.to
//     entity.price = 0

//     entity.save()

// Update owner of NFT
//     let nft = NFT.load(event.transaction.to!.toHex() + event.params.tokenId.toHex())
//     nft!.owner = event.params.to
//     nft!.save()
//   }
// }

// Called whenever a bid is placed on any NFT
export function handleBidPlaced(event: BidPlacedEvent): void {
  let entity = new Bid(
    event.params.cAddress.toHex() +
      event.params.tokenId.toHex() +
      event.params.from.toHex()
  );
  entity.cAddress = event.params.cAddress;
  entity.tokenId = event.params.tokenId.toI32();
  entity.from = event.params.from;
  entity.price = event.params.price.toI32();

  entity.save();
}

// Called whenever a bid is canceled on any NFT
export function handleBidCanceled(event: BidCanceledEvent): void {
  let id =
    event.params.cAddress.toHex() +
    event.params.tokenId.toHex() +
    event.params.from.toHex();

  store.remove("Bid", id);
}
