import 'package:equatable/equatable.dart';

/// Represents a single financial entry for a client.
///
/// This model holds all the details related to a specific transaction,
/// including client information, location, and the quantity and price of the item.
/// It uses [Equatable] to facilitate comparisons.
class EntriesModel extends Equatable {
  /// The unique identifier for the entry, typically from Firebase.
  final String? id;

  /// The address of the client.
  final String address;

  /// The name of the client.
  final String clientName;

  /// The current location of the client at the time of the entry.
  final String currentLocation;

  /// The phone number of the client.
  final String phoneNumber;

  /// The price per item for this entry.
  final num price;

  /// The quantity of items for this entry.
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

  /// Creates an [EntriesModel] instance from a JSON map.
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

  /// Converts this [EntriesModel] instance to a JSON map.
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
