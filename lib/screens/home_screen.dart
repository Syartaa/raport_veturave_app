import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raporti_veturave_app/providers/user_provider.dart';
import 'package:raporti_veturave_app/screens/login.dart';
import 'package:raporti_veturave_app/screens/raport_table.dart';
import 'package:raporti_veturave_app/screens/raporti_form.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 132, 161, 190),
        actions: [
          IconButton(
            onPressed: () async {
              await ref.read(userProvider.notifier).logout();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => LoginScreen()),
                (route) => false,
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: userState.when(
          data: (user) {
            if (user == null) {
              return const Text('No user data found');
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Profile Picture
                const CircleAvatar(
                  radius: 75, // Image size
                  backgroundImage: AssetImage(
                      'assets/1.png'), // Replace with your image link
                ),
                SizedBox(height: 20),

                // Username
                Text(
                  user.name, // Display the dynamic username
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 24,
                    color: Color.fromARGB(255, 70, 68, 68),
                  ),
                ),
                SizedBox(height: 40),

                // Raportet Button
                SizedBox(
                  width: MediaQuery.of(context).size.width *
                      0.7, // 70% of screen width
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => RaportTable()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      backgroundColor: const Color.fromARGB(
                          255, 165, 182, 165), // Color for Raportet button
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Raportet',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Mer Veturen Button
                SizedBox(
                  width: MediaQuery.of(context).size.width *
                      0.7, // 70% of screen width
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => AddRaporti()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      backgroundColor: const Color.fromARGB(
                          255, 132, 161, 190), // Color for Mer Veturen button
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Mer Veturen',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(255, 236, 235, 235),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
          loading: () => const CircularProgressIndicator(),
          error: (e, stack) => Text('Error: $e'),
        ),
      ),
    );
  }
}
