import 'package:equatable/equatable.dart';
import 'package:super_ge/models/entries_model.dart';

// ignore: must_be_immutable
class CollectionsModel extends Equatable {
  final String? id;
  final String name;
  final num endSellPrice;
  final num gomlahPrice;
  final num quantity;
  final num startSellPrice;
  num? profits;
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

  factory CollectionsModel.fromJson(Map<String, dynamic> json, String id) =>
      CollectionsModel(
        id: id,
        endSellPrice: json["end_sell_price"],
        gomlahPrice: json["gomlah_price"],
        name: json["name"],
        quantity: json["quantity"],
        startSellPrice: json["start_sell_price"],
      );

  Map<String, dynamic> toJson() => {
        "end_sell_price": endSellPrice,
        "gomlah_price": gomlahPrice,
        "name": name,
        "quantity": quantity,
        "start_sell_price": startSellPrice,
      };

  @override
  List<Object?> get props => [
        endSellPrice,
        gomlahPrice,
        name,
        quantity,
        startSellPrice,
      ];
}
