import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:raporti_veturave_app/providers/raport_provider.dart';
import 'package:raporti_veturave_app/widget/edit_dialog.dart';

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
        backgroundColor: const Color.fromARGB(255, 132, 161, 190),
        iconTheme: const IconThemeData(color: Colors.white),
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
                    headingRowColor: WidgetStateColor.resolveWith((states) =>
                        const Color.fromARGB(
                            255, 165, 182, 165)), // Header row color
                    dataRowColor: WidgetStateColor.resolveWith((states) =>
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
                                              await showDialog<String>(
                                            context: context,
                                            builder: (context) => EditDialog(
                                              title: 'Edit KM e Kthimit',
                                              initialValue: raporti.kmKthimit,
                                              labelText: 'KM e Kthimit',
                                              inputType: TextInputType.number,
                                              onSave: (newValue) {
                                                ref
                                                    .read(raportiProvider
                                                        .notifier)
                                                    .updateKmKthimit(
                                                        raporti.id, newValue);
                                              },
                                            ),
                                          );
                                        },
                                      ),
                                  ],
                                ),
                              ),
                              DataCell(Text(raporti.komenti)),
                              DataCell(Row(
                                children: [
                                  Expanded(child: Text(raporti.komenti2)),
                                  if (raporti.isKomenti2Editable)
                                    IconButton(
                                      onPressed: () async {
                                        final newKomenti2 =
                                            await showDialog<String>(
                                          context: context,
                                          builder: (context) => EditDialog(
                                            title: 'Edit Komenti i dyte',
                                            initialValue: raporti.komenti2,
                                            labelText: 'Komenti i dyte',
                                            inputType: TextInputType.text,
                                            onSave: (newValue) {
                                              ref
                                                  .read(
                                                      raportiProvider.notifier)
                                                  .updateKomenti2(
                                                      raporti.id, newValue);
                                            },
                                          ),
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.edit,
                                        color:
                                            Color.fromARGB(255, 132, 161, 190),
                                      ),
                                    )
                                ],
                              )),
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
}
