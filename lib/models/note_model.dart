import 'package:equatable/equatable.dart';

/// Represents a note in the application.
///
/// This model holds the details of a note, which can be associated with
/// either a client or a representative, as indicated by the [type] field.
/// It uses [Equatable] to facilitate comparisons.
class NoteModel extends Equatable {
  /// The unique identifier for the note, typically from Firebase.
  final String? id;

  /// The name or title of the note.
  final String name;

  /// The amount associated with the note (can represent money, quantity, etc.).
  final String amount;

  /// The type of the note, e.g., 'client' or 'mandob'.
  final String type;

  const NoteModel({
    this.id,
    required this.name,
    required this.amount,
    required this.type,
  });

  /// Creates a [NoteModel] instance from a JSON map.
  factory NoteModel.fromJson(Map<String, dynamic> json, {String? id}) =>
      NoteModel(
        id: id,
        name: json["name"],
        amount: json["amount"],
        type: json["type"],
      );

  /// Converts this [NoteModel] instance to a JSON map.
  Map<String, dynamic> toJson() => {
        "name": name,
        "amount": amount,
        "type": type,
      };

  @override
  List<Object?> get props => [id, name, amount, type];
}
