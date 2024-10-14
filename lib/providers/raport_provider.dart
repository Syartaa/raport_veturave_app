import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raporti_veturave_app/models/raporti.dart';

class RaportiNotifier extends StateNotifier<List<Raporti>> {
  RaportiNotifier() : super([]) {
    getAllRaports();
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool isLoading = true;

  Future<void> getAllRaports() async {
    try {
      print('Fetching data from Firestore...');
      isLoading = true;
      state = []; // Clear the state before fetching

      // Using `get()` for one-time data fetch
      final snapshot = await _firestore.collection('raporte').get();

      print('Received ${snapshot.docs.length} documents');

      if (snapshot.docs.isNotEmpty) {
        final raportet = snapshot.docs.map((doc) {
          final data = doc.data();

          // Debugging print statement
          print('Parsing document ${doc.id}: $data');

          // Handle the 'data' field based on its type
          DateTime parsedDate;
          if (data['data'] is Timestamp) {
            parsedDate = (data['data'] as Timestamp).toDate();
          } else if (data['data'] is String) {
            parsedDate = DateTime.parse(data['data']);
          } else {
            throw 'Invalid date format'; // In case of unexpected format
          }

          return Raporti(
            id: doc.id,
            data: parsedDate, // Use the parsed date
            emri: data['emri'] ?? 'Unknown',
            kmMarrjes: data['kmMarrjes'] ?? '0',
            kmKthimit: data['kmKthimit'] ?? '0',
            komenti: data['komenti'] ?? '',
            isKmKthimitEditable: false,
            komenti2: data['komenti2'] ?? '',
            isKomenti2Editable: false,
          );
        }).toList();

        state = raportet;
      } else {
        print('No documents found');
      }
    } catch (e) {
      print('Error fetching reports: $e');
    } finally {
      isLoading = false;
    }
  }

  Future<void> addRaport(Raporti raporti) async {
    try {
      final newDocRef = await _firestore.collection('raporte').add({
        'data': raporti.data.toIso8601String(),
        'emri': raporti.emri,
        'kmMarrjes': raporti.kmMarrjes,
        'kmKthimit': raporti.kmKthimit,
        'komenti': raporti.komenti,
        'komenti2': raporti.komenti2,
      });

      final newRaport = Raporti(
        id: newDocRef.id,
        data: raporti.data,
        emri: raporti.emri,
        kmMarrjes: raporti.kmMarrjes,
        kmKthimit: raporti.kmKthimit,
        komenti: raporti.komenti,
        isKmKthimitEditable: true,
        komenti2: raporti.komenti2,
        isKomenti2Editable: true,
      );

      state = [...state, newRaport];
    } catch (e) {
      print('Error adding report: $e');
    }
  }

  // Update km e kthimit in Firestore
  Future<void> updateKmKthimit(String id, String newKmKthimit) async {
    try {
      await _firestore.collection('raporte').doc(id).update({
        'kmKthimit': newKmKthimit,
      });

      state = state.map((raporti) {
        if (raporti.id == id) {
          return Raporti(
            id: raporti.id,
            data: raporti.data,
            emri: raporti.emri,
            kmMarrjes: raporti.kmMarrjes,
            kmKthimit: newKmKthimit,
            komenti: raporti.komenti,
            isKmKthimitEditable: false,
            komenti2: raporti.komenti2,
          );
        }
        return raporti;
      }).toList();
    } catch (e) {
      print('Error updating kmKthimit: $e');
    }
  }

  Future<void> updateKomenti2(String id, String newKomenti2) async {
    try {
      await _firestore.collection('raporte').doc(id).update({
        'komenti2': newKomenti2,
      });

      state = state.map((raporti) {
        if (raporti.id == id) {
          return Raporti(
            id: raporti.id,
            data: raporti.data,
            emri: raporti.emri,
            kmMarrjes: raporti.kmMarrjes,
            kmKthimit: raporti.kmKthimit,
            komenti: raporti.komenti,
            komenti2: newKomenti2,
            isKmKthimitEditable: false,
            isKomenti2Editable:
                false, // After editing, mark komenti2 as not editable
          );
        }
        return raporti;
      }).toList();
    } catch (e) {
      print('Error updating komenti2: $e');
    }
  }
}

final raportiProvider =
    StateNotifierProvider<RaportiNotifier, List<Raporti>>((ref) {
  return RaportiNotifier();
});
