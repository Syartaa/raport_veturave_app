import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:raporti_veturave_app/providers/raport_provider.dart';

class RaportTable extends ConsumerWidget {
  RaportTable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final raportet = ref.watch(raportiProvider);
    final raportiNotifier = ref.read(raportiProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Raportet",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor:
            const Color.fromARGB(255, 132, 161, 190), // Match HomeScreen color
        iconTheme:
            const IconThemeData(color: Colors.white), // Icon color change
      ),
      backgroundColor: Colors.white,
      body: raportiNotifier.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : raportet.isEmpty
              ? const Center(
                  child: Text(
                    'No reports available',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(
                      16.0), // Add padding around the table
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowColor: MaterialStateColor.resolveWith((states) =>
                        const Color.fromARGB(
                            255, 165, 182, 165)), // Header row color
                    dataRowColor: MaterialStateColor.resolveWith((states) =>
                        const Color.fromARGB(
                            255, 245, 245, 245)), // Data row color
                    headingTextStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    columns: const [
                      DataColumn(label: Text('Data')),
                      DataColumn(label: Text('Emri')),
                      DataColumn(label: Text('KM e Marrjes')),
                      DataColumn(label: Text('KM e Kthimit')),
                      DataColumn(label: Text('Komenti')),
                      DataColumn(label: Text('Komenti i dyte')),
                    ],
                    rows: raportet
                        .map((raporti) {
                          final formattedDate =
                              DateFormat('dd-MM-yyyy').format(raporti.data);

                          return DataRow(
                            cells: [
                              DataCell(Text(formattedDate)),
                              DataCell(Text(raporti.emri)),
                              DataCell(Text(raporti.kmMarrjes)),
                              DataCell(
                                Row(
                                  children: [
                                    Expanded(child: Text(raporti.kmKthimit)),
                                    if (raporti.isKmKthimitEditable)
                                      IconButton(
                                        icon: const Icon(
                                          Icons.edit,
                                          color: Color.fromARGB(
                                              255, 132, 161, 190),
                                        ),
                                        onPressed: () async {
                                          final newKmKthimit =
                                              await _showEditKmKthimitDialog(
                                                  context, raporti.kmKthimit);
                                          if (newKmKthimit != null) {
                                            ref
                                                .read(raportiProvider.notifier)
                                                .updateKmKthimit(
                                                    raporti.id, newKmKthimit);
                                          }
                                        },
                                      ),
                                  ],
                                ),
                              ),
                              DataCell(Text(raporti.komenti)),
                              DataCell(Text(raporti.komenti2)),
                            ],
                          );
                        })
                        .toList()
                        .reversed
                        .toList(), // Reverse the list to show the latest reports at the end
                  ),
                ),
    );
  }

  Future<String?> _showEditKmKthimitDialog(
      BuildContext context, String currentKmKthimit) {
    final kmKthimitController = TextEditingController(text: currentKmKthimit);

    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit KM e Kthimit'),
          content: TextField(
            controller: kmKthimitController,
            decoration: const InputDecoration(labelText: 'KM e Kthimit'),
            keyboardType: TextInputType.number,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(kmKthimitController.text);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
