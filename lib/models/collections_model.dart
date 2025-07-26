import 'package:equatable/equatable.dart';
import 'package:super_ge/models/entries_model.dart';

// ignore: must_be_immutable
/// Represents a collection or category of items in the application.
///
/// This model holds details about a specific collection, including its pricing,
/// quantity, and associated entries. It uses [Equatable] to facilitate comparisons.
class CollectionsModel extends Equatable {
  /// The unique identifier for the collection, typically from Firebase.
  final String? id;

  /// The name of the collection.
  final String name;

  /// The maximum selling price for an item in this collection.
  final num endSellPrice;

  /// The wholesale price for an item in this collection.
  final num gomlahPrice;

  /// The available quantity of items in this collection.
  final num quantity;

  /// The minimum selling price for an item in this collection.
  final num startSellPrice;

  /// The calculated profits for this collection. This is a mutable field.
  num? profits;

  /// A list of financial entries associated with this collection.
  List<EntriesModel> entries = [];

  CollectionsModel({
    this.id,
    required this.endSellPrice,
    required this.gomlahPrice,
    required this.name,
    required this.quantity,
    required this.startSellPrice,
    this.profits,
  });

  /// Creates a [CollectionsModel] instance from a JSON map.
  factory CollectionsModel.fromJson(Map<String, dynamic> json, String id) =>
      CollectionsModel(
        id: id,
        endSellPrice: json["end_sell_price"],
        gomlahPrice: json["gomlah_price"],
        name: json["name"],
        quantity: json["quantity"],
        startSellPrice: json["start_sell_price"],
      );

  /// Converts this [CollectionsModel] instance to a JSON map.
  Map<String, dynamic> toJson() => {
        "end_sell_price": endSellPrice,
        "gomlah_price": gomlahPrice,
        "name": name,
        "quantity": quantity,
        "start_sell_price": startSellPrice,
      };

  @override
  List<Object?> get props => [
        id, // Added id to props for Equatable comparison
        endSellPrice,
        gomlahPrice,
        name,
        quantity,
        startSellPrice,
      ];
}
