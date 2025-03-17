import 'package:equatable/equatable.dart';

class CollectionsModel extends Equatable {
  final String? id;
  final String name;
  final int endSellPrice;
  final int gomlahPrice;
  final int quantity;
  final int startSellPrice;

  const CollectionsModel({
    this.id,
    required this.endSellPrice,
    required this.gomlahPrice,
    required this.name,
    required this.quantity,
    required this.startSellPrice,
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
