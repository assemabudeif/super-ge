import 'package:equatable/equatable.dart';

class NoteModel extends Equatable {
  final String? id;
  final String name;
  final String amount;
  final String type;

  const NoteModel({
    this.id,
    required this.name,
    required this.amount,
    required this.type,
  });

  factory NoteModel.fromJson(Map<String, dynamic> json, {String? id}) =>
      NoteModel(
        id: id,
        name: json["name"],
        amount: json["amount"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "amount": amount,
        "type": type,
      };

  @override
  List<Object?> get props => [id, name, amount, type];
}
