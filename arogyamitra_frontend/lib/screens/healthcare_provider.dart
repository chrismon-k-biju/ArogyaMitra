import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'migrant_worker.dart';

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
                  role: _selectedRole,
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


class ProviderDashboard extends StatefulWidget {
  final String doctorName;
  final String role;

  const ProviderDashboard({super.key, required this.doctorName, required this.role});

  @override
  State<ProviderDashboard> createState() => _ProviderDashboardState();
}

class _ProviderDashboardState extends State<ProviderDashboard> {
  int _selectedIndex = 0;
  bool _isLoadingPatients = false;
  List<dynamic> _todayPatients = [];
  final _recordFormKey = GlobalKey<FormState>();
  late String _currentDoctorName;

  String _healthId = '';
  String _recordType = 'General Checkup';
  String _description = '';
  bool _isSubmittingRecord = false;

  final List<String> _recordTypes = [
    'General Checkup',
    'Prescription',
    'Lab Results',
    'Referral',
    'Other'
  ];

  @override
  void initState() {
    super.initState();
    _currentDoctorName = widget.doctorName;
    _fetchTodayPatients();
  }

  Future<void> _fetchTodayPatients() async {
    setState(() => _isLoadingPatients = true);
    final String baseUrl = kIsWeb ? 'http://localhost:3000' : 'http://10.0.2.2:3000';
    
    // Format today's date
    final now = DateTime.now();
    final todayStr = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/doctor-appointments?doctorName=${Uri.encodeComponent(widget.doctorName)}&date=$todayStr'),
      );

      if (response.statusCode == 200) {
        setState(() {
          _todayPatients = jsonDecode(response.body);
        });
      } else {
        print('Failed to fetch patients. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching patients: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoadingPatients = false);
      }
    }
  }

  Widget _buildDashboardContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildStatsRow(),
            const SizedBox(height: 20),
            _buildActionButtons(),
            const SizedBox(height: 20),
            if (widget.role == 'doctor') ...[
              _buildCampModeButton(),
              const SizedBox(height: 20),
            ],
            if (widget.role == 'health worker') ...[
              _buildMigrantRegistrationButton(),
              const SizedBox(height: 20),
              _buildPublicHealthButton(),
              const SizedBox(height: 20),
            ],
            _buildRecentPatients(),
          ],
        ),
      ),
    );
  }

  Widget _buildMigrantRegistrationButton() {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const RegistrationScreen()));
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF1F6EBB),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_add_alt_1, color: Colors.white),
            SizedBox(width: 10),
            Text(
              'Register Migrant Worker',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPublicHealthButton() {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => ReportAlertScreen(reporterName: widget.doctorName)));
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.white),
            SizedBox(width: 10),
            Text(
              'Report Public Health Alert',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientsContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(20.0),
          child: Text(
            'Today\'s Patients',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        Expanded(
          child: _isLoadingPatients
              ? const Center(child: CircularProgressIndicator())
              : _todayPatients.isEmpty
                  ? const Center(
                      child: Text(
                        'No patients scheduled for today',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _todayPatients.length,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemBuilder: (context, index) {
                        final patient = _todayPatients[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: Colors.grey.shade200),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            leading: CircleAvatar(
                              backgroundColor: const Color(0xFF1F6EBB).withOpacity(0.1),
                              child: const Icon(Icons.person, color: Color(0xFF1F6EBB)),
                            ),
                            title: Text(
                              patient['health_id'], 
                              style: const TextStyle(fontWeight: FontWeight.bold)
                            ),
                            subtitle: Text('Time: ${patient['time']} • ${patient['visit_type']}'),
                            trailing: TextButton(
                              onPressed: () {
                                // Switch to Records tab to add a record for this patient
                                setState(() {
                                  _selectedIndex = 3; 
                                });
                              },
                              child: const Text('Add Record'),
                            ),
                          ),
                        );
                      },
                    ),
        ),
      ],
    );
  }

  Widget _buildRecordsContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Upload Patient Record',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Form(
              key: _recordFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Health ID', style: TextStyle(fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'e.g. AM123456',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    validator: (value) => value == null || value.isEmpty ? 'Please enter Health ID' : null,
                    onSaved: (value) => _healthId = value!,
                  ),
                  const SizedBox(height: 20),
                  const Text('Record Type', style: TextStyle(fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _recordType,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    items: _recordTypes.map((type) {
                      return DropdownMenuItem(value: type, child: Text(type));
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _recordType = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text('Description / Notes', style: TextStyle(fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  TextFormField(
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Enter diagnosis, prescription, or notes...',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    validator: (value) => value == null || value.isEmpty ? 'Please enter description' : null,
                    onSaved: (value) => _description = value!,
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isSubmittingRecord ? null : _submitMedicalRecord,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1F6EBB),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: _isSubmittingRecord
                          ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : const Text('Upload Record', style: TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submitMedicalRecord() async {
    if (_recordFormKey.currentState!.validate()) {
      _recordFormKey.currentState!.save();
      setState(() => _isSubmittingRecord = true);

      final String baseUrl = kIsWeb ? 'http://localhost:3000' : 'http://10.0.2.2:3000';
      final now = DateTime.now();
      final todayStr = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

      try {
        final response = await http.post(
          Uri.parse('$baseUrl/api/medical-records'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'healthId': _healthId,
            'doctorName': widget.doctorName,
            'date': todayStr,
            'recordType': _recordType,
            'description': _description,
          }),
        );

        if (response.statusCode == 201) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Medical record uploaded successfully', style: TextStyle(color: Colors.white)), backgroundColor: Colors.green),
            );
            _recordFormKey.currentState!.reset();
            setState(() {
              _selectedIndex = 0; // Go back to dashboard
            });
          }
        } else {
          throw Exception('Failed to upload record: ${response.body}');
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e', style: const TextStyle(color: Colors.white)), backgroundColor: Colors.red),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isSubmittingRecord = false);
        }
      }
    }
  }

  // Profile Content
  Widget _buildProfileContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          const CircleAvatar(radius: 50, backgroundColor: Color(0xFF1F6EBB), child: Icon(Icons.person, size: 50, color: Colors.white)),
          const SizedBox(height: 16),
          Text(_currentDoctorName, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          Text(widget.role.toUpperCase(), style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 32),
          Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.edit, color: Color(0xFF1F6EBB)),
                  title: const Text('Edit Profile'),
                  onTap: () {
                    final nameController = TextEditingController(text: _currentDoctorName);
                    showDialog(context: context, builder: (ctx) => AlertDialog(
                      title: const Text('Edit Profile'),
                      content: TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                        ElevatedButton(onPressed: () {
                          setState(() {
                            _currentDoctorName = nameController.text;
                          });
                          Navigator.pop(ctx);
                        }, child: const Text('Save')),
                      ],
                    ));
                  },
                ),
                const Divider(height: 1),
                const ListTile(leading: Icon(Icons.settings, color: Colors.grey), title: Text('Settings')),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCampModeContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Health Camp Mode', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Icon(Icons.holiday_village, size: 60, color: Color(0xFF2DCE77)),
                const SizedBox(height: 16),
                const Text('Quick register patients in health camp without appointments.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    _showCampRegistrationDialog();
                  }, 
                  icon: const Icon(Icons.add),
                  label: const Text('New Walk-in Patient'),
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1F6EBB), foregroundColor: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showCampRegistrationDialog() {
    final nameController = TextEditingController();
    final ageController = TextEditingController();
    final phoneController = TextEditingController();
    bool isRegistering = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Walk-in Registration'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
                  TextField(controller: ageController, decoration: const InputDecoration(labelText: 'Age'), keyboardType: TextInputType.number),
                  TextField(controller: phoneController, decoration: const InputDecoration(labelText: 'Phone'), keyboardType: TextInputType.phone),
                  if (isRegistering) const Padding(padding: EdgeInsets.all(16.0), child: CircularProgressIndicator()),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
              ElevatedButton(
                onPressed: isRegistering ? null : () async {
                  if (nameController.text.isEmpty) return;
                  setState(() => isRegistering = true);
                  try {
                    final String baseUrl = kIsWeb ? 'http://localhost:3000' : 'http://10.0.2.2:3000';
                    final response = await http.post(
                      Uri.parse('$baseUrl/api/register'),
                      headers: {'Content-Type': 'application/json'},
                      body: jsonEncode({
                        'name': nameController.text,
                        'phone': phoneController.text.isEmpty ? '0000000000' : phoneController.text,
                        'age': ageController.text.isEmpty ? '0' : ageController.text,
                        'gender': 'Other', 
                        'state': 'Camp',
                        'district': 'Camp',
                        'occupation': 'Walk-in',
                        'password': 'campuser',
                      }),
                    );
                    if (response.statusCode == 201) {
                      final data = jsonDecode(response.body);
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Registered. Health ID: ${data['healthId']}'), duration: const Duration(seconds: 10)));
                    } else {
                      setState(() => isRegistering = false);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to register')));
                    }
                  } catch (e) {
                     setState(() => isRegistering = false);
                     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                  }
                },
                child: const Text('Register'),
              ),
            ],
          );
        }
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<int> currentMap = widget.role == 'doctor' ? [0, 1, 2, 3, 4] : [0, 3, 4];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: _selectedIndex == 0
                ? _buildDashboardContent()
                : _selectedIndex == 1
                    ? _buildPatientsContent()
                    : _selectedIndex == 3
                        ? _buildRecordsContent()
                        : _selectedIndex == 4
                            ? _buildProfileContent()
                            : _buildCampModeContent(),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentMap.indexOf(_selectedIndex) == -1 ? 0 : currentMap.indexOf(_selectedIndex),
        onTap: (index) {
          setState(() {
            _selectedIndex = currentMap[index];
            if (_selectedIndex == 1) {
              _fetchTodayPatients();
            }
          });
        },
        selectedItemColor: const Color(0xFF1F6EBB),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Dashboard'),
          if (widget.role == 'doctor') ...[
            const BottomNavigationBarItem(icon: Icon(Icons.people_outline), label: 'Patients'),
            const BottomNavigationBarItem(icon: Icon(Icons.holiday_village_outlined), label: 'Camp Mode'),
          ],
          const BottomNavigationBarItem(icon: Icon(Icons.description_outlined), label: 'Records'),
          const BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
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
                    widget.doctorName,
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
        if (widget.role != 'nurse') ...[
          _buildStatCard(_todayPatients.length.toString(), 'Patients\nToday'),
          const SizedBox(width: 10),
        ],
        _buildStatCard('0', 'Pending\nReports'),
        const SizedBox(width: 10),
        _buildStatCard('0', 'Follow-ups'),
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
          child: GestureDetector(
            onTap: _showSearchPatientDialog,
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
        ),
      ],
    );
  }

  void _showSearchPatientDialog() {
    final TextEditingController searchController = TextEditingController();
    bool isSearching = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Search Patient'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: searchController,
                  decoration: const InputDecoration(hintText: 'Enter Patient ID', border: OutlineInputBorder()),
                ),
                if (isSearching) ...[
                  const SizedBox(height: 20),
                  const CircularProgressIndicator(),
                ]
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
              ElevatedButton(
                onPressed: isSearching ? null : () async {
                  if (searchController.text.isEmpty) return;
                  setState(() => isSearching = true);
                  
                  try {
                    final String baseUrl = kIsWeb ? 'http://localhost:3000' : 'http://10.0.2.2:3000';
                    final response = await http.get(Uri.parse('$baseUrl/api/profile/${searchController.text}'));
                    
                    if (response.statusCode == 200) {
                      final data = jsonDecode(response.body);
                      Navigator.pop(ctx);
                      _showPatientDetailsDialog(data);
                    } else {
                      setState(() => isSearching = false);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Patient not found')));
                    }
                  } catch (e) {
                    setState(() => isSearching = false);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1F6EBB), foregroundColor: Colors.white),
                child: const Text('Search'),
              ),
            ],
          );
        }
      ),
    );
  }

  void _showPatientDetailsDialog(Map<String, dynamic> patient) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Patient Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${patient['name']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text('Health ID: ${patient['health_id']}'),
            Text('Age/Gender: ${patient['age']} / ${patient['gender']}'),
            Text('Blood Group: ${patient['blood_group'] ?? 'N/A'}'),
            Text('Allergies: ${patient['allergies'] ?? 'N/A'}'),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            const Text('To upload a record for this patient, close this and use the Records tab.', style: TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
        ],
      ),
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
      width: double.infinity,
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
          const SizedBox(height: 32),
          const Center(
            child: Text(
              'No recent patients',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),
          const SizedBox(height: 16),
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

class ReportAlertScreen extends StatefulWidget {
  final String reporterName;
  const ReportAlertScreen({super.key, required this.reporterName});

  @override
  State<ReportAlertScreen> createState() => _ReportAlertScreenState();
}

class _ReportAlertScreenState extends State<ReportAlertScreen> {
  final _formKey = GlobalKey<FormState>();
  String _alertType = 'Disease';
  String? _selectedDistrict;
  final TextEditingController _diseaseNameController = TextEditingController();
  final TextEditingController _affectedHealthIdController = TextEditingController();
  final TextEditingController _vaccinationNameController = TextEditingController();
  final TextEditingController _patientsCountController = TextEditingController();
  bool _isSubmitting = false;

  final List<String> _districts = [
    'Thiruvananthapuram', 'Kollam', 'Pathanamthitta', 'Alappuzha', 
    'Kottayam', 'Idukki', 'Ernakulam', 'Thrissur', 'Palakkad', 
    'Malappuram', 'Kozhikode', 'Wayanad', 'Kannur', 'Kasaragod'
  ];

  Future<void> _submitAlert() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);
      final String baseUrl = kIsWeb ? 'http://localhost:3000' : 'http://10.0.2.2:3000';
      
      try {
        final response = await http.post(
          Uri.parse('$baseUrl/api/alerts'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'district': _selectedDistrict,
            'alertType': _alertType,
            'diseaseName': _alertType == 'Disease' ? _diseaseNameController.text : null,
            'affectedHealthId': _alertType == 'Disease' ? _affectedHealthIdController.text : null,
            'vaccinationName': _alertType == 'Vaccination' ? _vaccinationNameController.text : null,
            'patientsCount': _alertType == 'Vaccination' ? int.tryParse(_patientsCountController.text) : null,
            'reporterName': widget.reporterName,
          }),
        );
        if (response.statusCode == 201) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Alert submitted successfully!')));
            Navigator.pop(context);
          }
        } else {
           throw Exception('Failed to submit alert');
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
        }
      } finally {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Report Public Health Alert', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('District', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedDistrict,
                items: _districts.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
                onChanged: (val) => setState(() => _selectedDistrict = val),
                validator: (val) => val == null ? 'Select district' : null,
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              const Text('Alert Type', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _alertType,
                items: const [
                  DropdownMenuItem(value: 'Disease', child: Text('Disease')),
                  DropdownMenuItem(value: 'Vaccination', child: Text('Vaccination')),
                ],
                onChanged: (val) => setState(() => _alertType = val!),
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              if (_alertType == 'Disease') ...[
                TextFormField(
                  controller: _diseaseNameController,
                  decoration: const InputDecoration(labelText: 'Name of Disease', border: OutlineInputBorder()),
                  validator: (val) => val!.isEmpty ? 'Enter disease name' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _affectedHealthIdController,
                  decoration: const InputDecoration(labelText: 'Affected Person Health ID', border: OutlineInputBorder()),
                  validator: (val) => val!.isEmpty ? 'Enter Health ID' : null,
                ),
              ] else ...[
                TextFormField(
                  controller: _vaccinationNameController,
                  decoration: const InputDecoration(labelText: 'Vaccination Name', border: OutlineInputBorder()),
                  validator: (val) => val!.isEmpty ? 'Enter vaccination name' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _patientsCountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Number of Patients Vaccinated', border: OutlineInputBorder()),
                  validator: (val) => val!.isEmpty ? 'Enter count' : null,
                ),
              ],
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitAlert,
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1F6EBB), foregroundColor: Colors.white),
                  child: _isSubmitting ? const CircularProgressIndicator(color: Colors.white) : const Text('Submit Alert', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}