import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:super_ge/controllers/entries_controller.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../models/entries_model.dart';

/// A widget to display the details of a single client entry in a styled card.
///
/// This widget presents the information from an [EntriesModel] in a visually
/// appealing format, including a gradient header, client details, and a delete button.
/// It is used in the `EntriesView` to list all entries for a collection.
class EntryWidget extends StatelessWidget {
  /// The data model for the entry to be displayed.
  final EntriesModel model;

  const EntryWidget({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Gradient header displaying the client's name and a delete button.
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              gradient: LinearGradient(
                colors: [Color(0xFF3F51B5), Color(0xFF2196F3)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    model.clientName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                // Delete button for the entry.
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.white),
                  onPressed: () {
                    // Finds the EntriesController instance and calls the delete method.
                    Get.put(EntriesController()).deleteEntry(model.id!);
                  },
                ),
              ],
            ),
          ),
          // Details section for the entry.
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildRow('العنوان', model.address),
                const SizedBox(height: 8),
                _buildRow('الموقع الحالي', model.currentLocation),
                const SizedBox(height: 8),
                // The phone number is a tappable link to open the dialer.
                _buildRow('رقم الهاتف', model.phoneNumber, onTap: () {
                  launchUrlString(
                    "tel:${model.phoneNumber}",
                  );
                }),
                const SizedBox(height: 8),
                _buildRow('السعر', model.price.toString()),
                const SizedBox(height: 8),
                _buildRow('الكمية', model.quantity.toString()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// A helper method to build a detail row with a label and a value.
  ///
  /// Optionally, an `onTap` function can be provided to make the value tappable.
  Widget _buildRow(
    String label,
    String value, {
    Function()? onTap,
  }) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: InkWell(
            onTap: onTap,
            child: Row(
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    // Underline the text if it's tappable.
                    decoration: onTap != null ? TextDecoration.underline : null,
                  ),
                ),
                // Show a phone icon if it's a phone number.
                if (onTap != null) ...[
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.phone,
                    color: Colors.green,
                    size: 16,
                  )
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
