import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../models/entries_model.dart';

/// Widget to display client data in a modern UI
class EntryWidget extends StatelessWidget {
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
          // Gradient header displaying the client's name
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
          // Details section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildRow('العنوان', model.address),
                const SizedBox(height: 8),
                _buildRow('الموقع الحالي', model.currentLocation),
                const SizedBox(height: 8),
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

  // Helper method to build a detail row with label and value.
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
                    decoration: onTap != null ? TextDecoration.underline : null,
                  ),
                ),
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
