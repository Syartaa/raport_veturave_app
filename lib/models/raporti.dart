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

  Raporti({
    required this.data,
    required this.emri,
    required this.kmMarrjes,
    required this.kmKthimit,
    required this.komenti,
    this.isKmKthimitEditable = true,
    required this.komenti2,
    String? id,
  }) : id = id ?? uuid.v4();
}
