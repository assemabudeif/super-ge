import 'package:equatable/equatable.dart';

class EntriesModel extends Equatable {
  final String? id;
  final String address;
  final String clientName;
  final String currentLocation;
  final String phoneNumber;
  final num price;
  final int quantity;

  const EntriesModel({
    this.id,
    required this.address,
    required this.clientName,
    required this.currentLocation,
    required this.phoneNumber,
    required this.price,
    required this.quantity,
  });

  factory EntriesModel.fromJson(
    Map<String, dynamic> json, {
    required String id,
  }) =>
      EntriesModel(
        id: id,
        address: json["address"],
        clientName: json["client_name"],
        currentLocation: json["current_location"],
        phoneNumber: json["phone_number"],
        price: json["price"],
        quantity: json["quantity"],
      );

  Map<String, dynamic> toJson() => {
        "address": address,
        "client_name": clientName,
        "current_location": currentLocation,
        "phone_number": phoneNumber,
        "price": price,
        "quantity": quantity,
      };

  @override
  List<Object?> get props => [
        id,
        address,
        clientName,
        currentLocation,
        phoneNumber,
        price,
        quantity,
      ];
}
