import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:super_ge/controllers/bills_controller.dart';

/// A screen that displays a list of all saved bills.
///
/// This view fetches and displays all bills from the Firebase 'bills' collection.
/// Each bill is displayed in a card with client details, items, total amount,
/// and the representative's name. It also provides an option to delete a bill.
class BillsView extends StatelessWidget {
  const BillsView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BillsController>(
      init: BillsController(),
      builder: (controller) {
        // Show a loading indicator while bills are being fetched.
        if (controller.isLoading) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('الفواتير'),
            ),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        // Show a message if there are no bills.
        if (controller.bills.isEmpty) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('الفواتير'),
            ),
            body: const Center(child: Text('لا يوجد فواتير')),
          );
        }

        // Display the list of bills.
        return Scaffold(
          appBar: AppBar(
            title: const Text('الفواتير'),
          ),
          body: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.bills.length,
            itemBuilder: (context, index) {
              final bill = controller.bills[index];
              final date =
                  DateTime.fromMillisecondsSinceEpoch(bill['timestamp']);
              final formattedDate =
                  DateFormat('yyyy/MM/dd - HH:mm').format(date);

              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Bill header with client name and date.
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.blueGrey.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.person, color: Colors.blueGrey),
                            const SizedBox(width: 8),
                            Text(
                              bill['client_name'] ?? '',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const Spacer(),
                            Text(
                              formattedDate,
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Client details.
                      Row(
                        children: [
                          const Icon(Icons.phone,
                              size: 16, color: Colors.green),
                          const SizedBox(width: 6),
                          Text(bill['phone'] ?? ''),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.location_on,
                              size: 16, color: Colors.red),
                          const SizedBox(width: 6),
                          Expanded(child: Text(bill['address'] ?? '')),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.my_location,
                              size: 16, color: Colors.deepPurple),
                          const SizedBox(width: 6),
                          Expanded(
                              child: Text(
                                  bill['current_location'] ?? 'غير متوفر')),
                        ],
                      ),
                      const Divider(height: 20),
                      // Expandable list of items in the bill.
                      ExpansionTile(
                        title: const Text('تفاصيل العناصر',
                            style: TextStyle(fontWeight: FontWeight.w600)),
                        children: List<Widget>.from(
                          (bill['collections'] as List<dynamic>).map(
                            (item) => ListTile(
                              dense: true,
                              leading: const Icon(Icons.inventory,
                                  color: Colors.teal),
                              title: Text(item['name']),
                              subtitle: Text(
                                  'الكمية: ${item['quantity']} - السعر: ${item['price']}'),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Total amount and representative name.
                      Row(
                        children: [
                          const Icon(Icons.attach_money,
                              size: 16, color: Colors.green),
                          const SizedBox(width: 6),
                          Text('الاجمالي: ${bill['total']}'),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.person_pin,
                              size: 16, color: Colors.blueGrey),
                          const SizedBox(width: 6),
                          Text('مندوب: ${bill['mandob_name']}'),
                        ],
                      ),
                      const SizedBox(height: 6),
                      // Delete button for the bill.
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          onPressed: () => controller.deleteBill(bill['id']),
                          icon: const Icon(Icons.delete, color: Colors.red),
                          label: const Text('حذف الفاتورة',
                              style: TextStyle(color: Colors.red)),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
