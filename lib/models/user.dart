import 'package:uuid/uuid.dart';

final uuid = Uuid();

class Users {
  final String id;
  final String name;
  final String email;

  Users({
    required this.name,
    required this.email,
    String? id,
  }) : id = id ?? uuid.v4();
}
