import 'package:raporti_veturave_app/models/raporti.dart';

class RaportiState {
  final List<Raporti> raportet;
  final bool isLoading;
  final String? error;

  RaportiState({
    required this.raportet,
    required this.isLoading,
    this.error,
  });

  factory RaportiState.initial() {
    return RaportiState(raportet: [], isLoading: true);
  }
}
