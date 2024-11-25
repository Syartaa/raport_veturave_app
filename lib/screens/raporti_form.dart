import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:raporti_veturave_app/providers/user_provider.dart';
import 'package:raporti_veturave_app/screens/raport_table.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raporti_veturave_app/providers/raport_provider.dart';
import 'package:raporti_veturave_app/models/raporti.dart';

class AddRaporti extends ConsumerStatefulWidget {
  AddRaporti({super.key});

  @override
  ConsumerState<AddRaporti> createState() => AddRaportiState();
}

class AddRaportiState extends ConsumerState<AddRaporti> {
  final _formKey = GlobalKey<FormState>();

  // Text controllers to get user input
  final _dataController = TextEditingController();
  final _emriController = TextEditingController();
  final _kmMarresController = TextEditingController();
  final _kmKthimitController = TextEditingController();
  final _komentiController = TextEditingController();
  final _nenshkrimiController = TextEditingController();
  @override
  void initState() {
    super.initState();

    // Set today's date in the _dataController when the widget is initialized
    _dataController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  @override
  void dispose() {
    _dataController.dispose();
    _emriController.dispose();
    _kmMarresController.dispose();
    _kmKthimitController.dispose();
    _komentiController.dispose();
    _nenshkrimiController.dispose();
    super.dispose();
  }

  void _addRaport() {
    if (_formKey.currentState!.validate()) {
      final newRaport = Raporti(
        id: '',
        data: DateTime.parse(_dataController.text),
        emri: _emriController.text,
        kmMarrjes: _kmMarresController.text,
        komenti: _komentiController.text,
        kmKthimit: '',
        komenti2: '',
      );

      ref.read(raportiProvider.notifier).addRaport(newRaport);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Raporti u shtua me sukses')),
      );

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => RaportTable()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userAsyncValue = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Raporti i Vetures",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(
            255, 132, 161, 190), // Match color with HomeScreen
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: userAsyncValue.when(
          data: (user) {
            if (user != null) {
              _emriController.text = user.name;
            }

            return Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Date Field (Read-only with today's date)
                    TextFormField(
                      controller: _dataController,
                      decoration: InputDecoration(
                        labelText: 'Data e sotme',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      readOnly: true, // Make the field read-only
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Data e sotme mungon';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Name Field
                    TextFormField(
                      controller: _emriController,
                      decoration: InputDecoration(
                        labelText: 'Emri',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ju lutem shkruani emrin';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // KM Marrjes Field
                    TextFormField(
                      controller: _kmMarresController,
                      decoration: InputDecoration(
                        labelText: 'KM e marrjes',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ju lutem shkruani KM e marrjes';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Komenti Field
                    TextFormField(
                      controller: _komentiController,
                      decoration: InputDecoration(
                        labelText: 'Komenti',
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ju lutem shkruani komentin';
                        }
                        return null;
                      },
                      maxLines: 5,
                      minLines: 1,
                      keyboardType: TextInputType.multiline,
                    ),
                    const SizedBox(height: 20),

                    // Submit Button
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: ElevatedButton(
                        onPressed: _addRaport,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          backgroundColor: const Color.fromARGB(
                              255, 132, 161, 190), // Match button color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Krijo Raport',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) =>
              Center(child: Text('Error: $error')), // Error handling
        ),
      ),
    );
  }
}
