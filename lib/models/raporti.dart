import 'package:uuid/uuid.dart';

final uuid = Uuid();

class Raporti {
  final String id;
  final DateTime data;
  final String emri;
  final String kmMarrjes;
  String kmKthimit;
  final String komenti;
  bool isKmKthimitEditable;
  String komenti2;
  bool isKomenti2Editable;

  Raporti({
    required this.data,
    required this.emri,
    required this.kmMarrjes,
    required this.kmKthimit,
    required this.komenti,
    this.isKmKthimitEditable = true,
    this.isKomenti2Editable = true,
    required this.komenti2,
    String? id,
  }) : id = id ?? uuid.v4();
}
