import 'package:flutter/material.dart';

// 1. IMPORT YOUR MODULAR FILES
import 'screens/migrant_worker.dart';
import 'screens/healthcare_provider.dart';
import 'screens/public_health.dart'; // <--- NEW IMPORT
import 'widgets/role_card.dart';

void main() {
  runApp(const ArogyaMitraApp());
}

class ArogyaMitraApp extends StatelessWidget {
  const ArogyaMitraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ArogyaMitra',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        // Global theme for Input Fields (Consistency across all screens)
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
      home: const LandingScreen(),
    );
  }
}

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color gradientTop = const Color(0xFF1F6EBB);
    final Color gradientBottom = const Color(0xFF2DCE77);
    final Color textWhite = Colors.white;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [gradientTop, gradientBottom],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                Text(
                  'ArogyaMitra',
                  style: TextStyle(
                    color: textWhite,
                    fontSize: 36,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Your Health Companion',
                  style: TextStyle(
                    color: textWhite.withOpacity(0.9),
                    fontSize: 18,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const SizedBox(height: 50),

                // Card 1 - Migrant Worker
                RoleCard(
                  title: 'Migrant Worker',
                  subtitle: 'Access health records',
                  icon: Icons.person_outline_rounded,
                  iconBgColor: const Color(0xFF1F6EBB), 
                  onTap: () {
                     Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MigrantWorkerScreen()),
                    );
                  },
                ),

                const SizedBox(height: 20),

                // Card 2 - Healthcare Provider
                RoleCard(
                  title: 'Healthcare Provider',
                  subtitle: 'Manage patient records',
                  icon: Icons.medical_services_outlined, 
                  iconBgColor: const Color(0xFF2DCE77),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HealthcareProviderScreen()),
                    );
                  },
                ),

                const SizedBox(height: 20),

                // Card 3 - Public Health
                RoleCard(
                  title: 'Public Health',
                  subtitle: 'View health analytics',
                  icon: Icons.bar_chart_rounded,
                  iconBgColor: const Color(0xFF1F6EBB),
                  onTap: () {
                    // Link to the new Public Health Screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PublicHealthScreen()),
                    );
                  },
                ),

                const Spacer(),

                Text(
                  'Demo Mode - Select a module to explore',
                  style: TextStyle(
                    color: textWhite.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}