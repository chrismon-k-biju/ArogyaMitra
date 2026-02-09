import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';

class HealthcareProviderScreen extends StatefulWidget {
  const HealthcareProviderScreen({super.key});

  @override
  State<HealthcareProviderScreen> createState() => _HealthcareProviderScreenState();
}

class _HealthcareProviderScreenState extends State<HealthcareProviderScreen> {
  String _selectedRole = 'doctor'; 
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();
    super.dispose();
  } 

  Future<void> _handleProviderLogin() async {
    if (_idController.text.isNotEmpty && _passwordController.text.isNotEmpty) {
      setState(() => _isLoading = true);

      final String baseUrl = kIsWeb ? 'http://localhost:3000' : 'http://10.0.2.2:3000';
      final url = Uri.parse('$baseUrl/api/provider-login');

      try {
        final Map<String, dynamic> loginData = {
          'username': _idController.text,
          'password': _passwordController.text,
          'role': _selectedRole, 
        };

        print("Sending Login Data: $loginData");

        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(loginData),
        );

        setState(() => _isLoading = false);

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final name = data['name'];
          
          if (mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProviderDashboard(
                  doctorName: name ?? _idController.text,
                ),
              ),
            );
          }
        } else {
          if (mounted) {
            final errorMsg = jsonDecode(response.body)['message'] ?? 'Login failed';
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(errorMsg), backgroundColor: Colors.red),
            );
          }
        }
      } catch (e) {
        setState(() => _isLoading = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter ID and Password")),
      );
    }
  } 

  @override
  Widget build(BuildContext context) {
    final Color activeBlue = const Color(0xFF1F6EBB);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Center(
                child: Column(
                  children: [
                    Text(
                      'Healthcare Provider',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Select your role to continue',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              _buildRoleSelector('doctor', activeBlue),
              const SizedBox(height: 16),
              _buildRoleSelector('nurse', activeBlue),
              const SizedBox(height: 16),
              _buildRoleSelector('health worker', activeBlue),
              const SizedBox(height: 40),
              const Text("Employee ID / Username", style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              TextField(
                controller: _idController,
                decoration: InputDecoration(
                  hintText: 'Enter your ID / Name',
                  prefixIcon: Icon(Icons.person_outline, color: Colors.grey.shade400),
                ),
              ),
              const SizedBox(height: 20),
              const Text("Password", style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Enter your password',
                  prefixIcon: Icon(Icons.lock_outline, color: Colors.grey.shade400),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleProviderLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: activeBlue.withOpacity(0.6),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading 
                    ? const SizedBox(
                        width: 24, 
                        height: 24, 
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                      )
                    : const Text(
                        'Sign In',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleSelector(String role, Color activeColor) {
    bool isSelected = _selectedRole == role;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedRole = role;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF0F7FF) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? activeColor : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.person_outline,
                color: Colors.grey.shade700,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              role.toUpperCase(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isSelected ? activeColor : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
  }


class ProviderDashboard extends StatelessWidget {
  final String doctorName;

  const ProviderDashboard({super.key, required this.doctorName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildStatsRow(),
                    const SizedBox(height: 20),
                    _buildActionButtons(),
                    const SizedBox(height: 20),
                    _buildCampModeButton(),
                    const SizedBox(height: 20),
                    _buildRecentPatients(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF1F6EBB),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.people_outline), label: 'Patients'),
          BottomNavigationBarItem(icon: Icon(Icons.holiday_village_outlined), label: 'Camp Mode'),
          BottomNavigationBarItem(icon: Icon(Icons.description_outlined), label: 'Reports'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 20),
      width: double.infinity,
      color: const Color(0xFF1F6EBB),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Welcome,',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    doctorName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ],
              ),
              const Icon(Icons.logout, color: Colors.white),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(Icons.local_hospital, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Current Facility', style: TextStyle(color: Colors.white70, fontSize: 10)),
                    Text('PHC Ernakulam', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        _buildStatCard('24', 'Patients\nToday'),
        const SizedBox(width: 10),
        _buildStatCard('8', 'Pending\nReports'),
        const SizedBox(width: 10),
        _buildStatCard('5', 'Follow-ups'),
      ],
    );
  }

  Widget _buildStatCard(String count, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              count,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 120,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1F6EBB), Color(0xFF2DCE77)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.qr_code_scanner, color: Colors.white, size: 40),
                SizedBox(height: 10),
                Text(
                  'Scan Patient\nQR Code',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF1F6EBB), width: 1.5),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search, color: Color(0xFF1F6EBB), size: 40),
                SizedBox(height: 10),
                Text(
                  'Search\nPatient ID',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFF1F6EBB), fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCampModeButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF2DCE77),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.holiday_village, color: Colors.white),
          SizedBox(width: 10),
          Text(
            'Enter Camp Mode',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentPatients() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Patients',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
              ),
              Text(
                'View All',
                style: TextStyle(fontSize: 14, color: Color(0xFF1F6EBB), fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildPatientItem('Rajesh Kumar', '32 years • 2 hours ago', Colors.green),
          _buildPatientItem('Amit Singh', '28 years • 4 hours ago', Colors.teal),
          _buildPatientItem('Mohammed Ali', '35 years • Yesterday', Colors.blue),
        ],
      ),
    );
  }

  Widget _buildPatientItem(String name, String details, Color avatarColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: avatarColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  details,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          const Text(
            'View',
            style: TextStyle(color: Color(0xFF1F6EBB), fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}