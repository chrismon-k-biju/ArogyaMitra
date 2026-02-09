import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';


class MigrantWorkerScreen extends StatefulWidget {
  const MigrantWorkerScreen({super.key});

  @override
  State<MigrantWorkerScreen> createState() => _MigrantWorkerScreenState();
}

class _MigrantWorkerScreenState extends State<MigrantWorkerScreen> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> _languages = [
    {'name': 'English', 'flag': '🇬🇧'},
    {'name': 'മലയാളം', 'flag': '🇮🇳'},
    {'name': 'हिंदी', 'flag': '🇮🇳'},
    {'name': 'বাংলা', 'flag': '🇮🇳'},
    {'name': 'தமிழ்', 'flag': '🇮🇳'},
  ];

  @override
  Widget build(BuildContext context) {
    final Color gradientTop = const Color(0xFF1F6EBB);
    final Color gradientBottom = const Color(0xFF2DCE77);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [gradientTop, gradientBottom],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.language, size: 50, color: Colors.white),
              const SizedBox(height: 20),
              const Text(
                'ArogyaMitra',
                style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const Text(
                'Your Health Companion',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 30),
              const Text(
                'Select Your Language / भाषा चुनें',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: _languages.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final isSelected = _selectedIndex == index;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedIndex = index),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.white : Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: isSelected ? null : Border.all(color: Colors.white30),
                        ),
                        child: Row(
                          children: [
                            Text(_languages[index]['flag'], style: const TextStyle(fontSize: 20)),
                            const SizedBox(width: 16),
                            Text(
                              _languages[index]['name'],
                              style: TextStyle(
                                color: isSelected ? const Color(0xFF1F6EBB) : Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Spacer(),
                            if (isSelected) const Icon(Icons.check, color: Color(0xFF1F6EBB)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RegistrationScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF1F6EBB),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                         Text('Get Started', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                         SizedBox(width: 8),
                         Icon(Icons.arrow_forward),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _occupationController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Dropdown values
  String? _selectedGender;
  String? _selectedState;

  final List<String> _genders = ['Male', 'Female', 'Other'];
  final List<String> _states = [
    'Kerala', 'Tamil Nadu', 'Karnataka', 'Andhra Pradesh', 
    'Telangana', 'Maharashtra', 'Delhi', 'Uttar Pradesh', 
    'Bihar', 'West Bengal', 'Odisha', 'Rajasthan'
  ]; // Add more as needed

  @override
  void dispose() {
    _phoneController.dispose();
    _nameController.dispose();
    _ageController.dispose();
    _occupationController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1F6EBB)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Registration',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Phone Number Field
                      _buildLabel('Phone Number', Icons.phone_outlined),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            width: 60,
                            height: 50,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            // Assuming Indian context from previous file content
                            child: const Center(child: Text('+91', style: TextStyle(fontSize: 16))), 
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              decoration: _inputDecoration('Enter your phone number'),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter phone number';
                                }
                                if (value.length < 10) {
                                  return 'Enter valid phone number';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Full Name Field
                      _buildLabel('Full Name', Icons.person_outline),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _nameController,
                        textCapitalization: TextCapitalization.words,
                        decoration: _inputDecoration('Enter your full name'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter full name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Age and Gender Row
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel('Age', Icons.calendar_today_outlined),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: _ageController,
                                  keyboardType: TextInputType.number,
                                  decoration: _inputDecoration('Age'),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Required';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(left: 4, bottom: 8),
                                  child: Text(
                                    'Gender',
                                    style: TextStyle(
                                      fontSize: 14, 
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500
                                    ),
                                  ),
                                ),
                                DropdownButtonFormField<String>(
                                  value: _selectedGender,
                                  items: _genders.map((String gender) {
                                    return DropdownMenuItem(
                                      value: gender,
                                      child: Text(gender),
                                    );
                                  }).toList(),
                                  onChanged: (val) => setState(() => _selectedGender = val),
                                  decoration: _inputDecoration(''),
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  validator: (value) => value == null ? 'Required' : null,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // State of Origin Field
                      _buildLabel('State of Origin', Icons.location_on_outlined),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _selectedState,
                        items: _states.map((String state) {
                          return DropdownMenuItem(
                            value: state,
                            child: Text(state),
                          );
                        }).toList(),
                        onChanged: (val) => setState(() => _selectedState = val),
                        decoration: _inputDecoration(''),
                        icon: const Icon(Icons.keyboard_arrow_down),
                        validator: (value) => value == null ? 'Please select state' : null,
                      ),
                      const SizedBox(height: 20),

                      // Occupation Field
                      _buildLabel('Occupation', Icons.work_outline),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _occupationController,
                        textCapitalization: TextCapitalization.words,
                        decoration: _inputDecoration('e.g., Construction Worker, Factory Worker'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter occupation';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Create Password Field
                      _buildLabel('Create Password', Icons.lock_outline),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: _inputDecoration('Start creating a secure password'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please create a password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
            

            // Link to Login
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already registered? ",
                    style: TextStyle(color: Colors.black54),
                  ),
                  GestureDetector(
                    onTap: () {
                       Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const MigrantLoginScreen()),
                      );
                    },
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        color: Color(0xFF1F6EBB),
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Bottom Button
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _registerUser();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1F6EBB),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), 
                    ),
                    elevation: 0,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.qr_code, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Generate Health ID',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _registerUser() async {
    final String baseUrl = kIsWeb ? 'http://localhost:3000' : 'http://10.0.2.2:3000';
    final url = Uri.parse('$baseUrl/api/register');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'phone': _phoneController.text,
          'name': _nameController.text,
          'age': _ageController.text,
          'gender': _selectedGender,
          'state': _selectedState,
          'occupation': _occupationController.text,
          'password': _passwordController.text,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final healthId = data['healthId'];

        if (mounted) {
           Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HealthIDScreen(
                healthId: healthId,
                name: _nameController.text,
              ),
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Registration Failed: ${response.body}')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Widget _buildLabel(String text, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF1F6EBB)),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF1F6EBB)),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      fillColor: Colors.white,
      filled: true,
    );
  }
}

class HealthIDScreen extends StatelessWidget {
  final String healthId;
  final String? name;

  const HealthIDScreen({super.key, required this.healthId, this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1F6EBB)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Your Health ID',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF1F6EBB), width: 2),
                ),
                child: Center(
                  child: Icon(
                    Icons.qr_code_2,
                    size: 200,
                    color: const Color(0xFF1F6EBB),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                'Your Health ID',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                healthId,
                style: const TextStyle(
                  fontSize: 32,
                  color: Color(0xFF1F6EBB),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 12),
              RichText(
                text: TextSpan(
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                  children: [
                    const TextSpan(text: 'Save this QR code for '),
                    TextSpan(
                      text: 'quick access',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(flex: 3),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                    } else {
                        Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MigrantWorkerDashboard(
                            healthId: healthId,
                            name: name ?? 'User',
                            ),
                        ),
                        );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1F6EBB),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    Navigator.canPop(context) ? 'Back to Dashboard' : 'Continue to Dashboard',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
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
}

class MigrantLoginScreen extends StatefulWidget {
  const MigrantLoginScreen({super.key});

  @override
  State<MigrantLoginScreen> createState() => _MigrantLoginScreenState();
}

class _MigrantLoginScreenState extends State<MigrantLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      final String baseUrl = kIsWeb ? 'http://localhost:3000' : 'http://10.0.2.2:3000';
      final url = Uri.parse('$baseUrl/api/login');
      try {
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'phone': _phoneController.text,
            'password': _passwordController.text,
          }),
        );
        
        setState(() => _isLoading = false);

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final healthId = data['healthId']; // Expected from backend
          
          if (mounted) {
             Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MigrantWorkerDashboard(
                  healthId: healthId,
                  name: data['name'],
                ),
              ),
            );
          }
        } else {
           if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
               const SnackBar(
                content: Text('Invalid Phone Numer or Password'), // UI message updated
                backgroundColor: Colors.red,
              ),
            );
           }
        }
      } catch (e) {
        setState(() => _isLoading = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Login Error: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1F6EBB)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Migrant Login',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Welcome Back!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F6EBB),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Please sign in to continue',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                
                // Phone Number Field (Replaced Name)
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: _inputDecoration('Enter your phone number', Icons.phone_outlined),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Password Field
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: _inputDecoration('Enter password', Icons.lock_outline),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 40),

                // Login Button
                SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1F6EBB),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading 
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: const Color(0xFF1F6EBB)),
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF1F6EBB)),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
      filled: true,
      fillColor: Colors.grey.shade50,
    );
  }
}

class MigrantWorkerDashboard extends StatefulWidget {
  final String healthId;
  final String name;

  const MigrantWorkerDashboard({
    super.key, 
    required this.healthId, 
    required this.name,
  });

  @override
  State<MigrantWorkerDashboard> createState() => _MigrantWorkerDashboardState();
}

class _MigrantWorkerDashboardState extends State<MigrantWorkerDashboard> {
  int _selectedIndex = 0;
  int _currentProfileTab = 0;
  bool _isUpdatingEmergency = false;
  List<dynamic> _appointments = [];
  bool _isLoadingAppointments = true;
  Map<String, dynamic>? _profileData;
  bool _isLoadingProfile = false;

  @override
  void initState() {
    super.initState();
    _fetchAppointments();
  }

  Future<void> _fetchAppointments() async {
    final String baseUrl = kIsWeb ? 'http://localhost:3000' : 'http://10.0.2.2:3000';
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/appointments/${widget.healthId}'));
      if (response.statusCode == 200) {
        if (mounted) {
          final List<dynamic> allAppointments = jsonDecode(response.body);
          final now = DateTime.now();
          final today = DateTime(now.year, now.month, now.day);

          setState(() {
            _appointments = allAppointments.where((appt) {
              try {
                final apptDate = DateTime.parse(appt['date']);
                return !apptDate.isBefore(today);
              } catch (e) {
                return true; // Keep if date parsing fails
              }
            }).toList();
            _isLoadingAppointments = false;
          });
        }
      } else {
        throw Exception('Failed to load appointments');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingAppointments = false);
      }
      print('Error fetching appointments: $e');
    }
  }

  Future<void> _fetchProfileDetails() async {
    setState(() => _isLoadingProfile = true);
    final String baseUrl = kIsWeb ? 'http://localhost:3000' : 'http://10.0.2.2:3000';
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/profile/${widget.healthId}'));
      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
            _profileData = jsonDecode(response.body);
            _isLoadingProfile = false;
          });
        }
      } else {
        throw Exception('Failed to load profile');
      }
    } catch (e) {
      print('Error fetching profile: $e');
      if (mounted) {
        setState(() => _isLoadingProfile = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading profile: $e')),
        );
      }
    }
  }

  Future<void> _deleteAppointment(int id) async {
    print('Attempting to delete appointment with ID: $id'); // Debug print
    final String baseUrl = kIsWeb ? 'http://localhost:3000' : 'http://10.0.2.2:3000';
    try {
      final response = await http.delete(Uri.parse('$baseUrl/api/delete-appointment/$id'));
      print('Delete response status: ${response.statusCode}'); // Debug print
      print('Delete response body: ${response.body}'); // Debug print

      if (response.statusCode == 200) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Appointment cancelled successfully'),
              backgroundColor: Colors.green, // Visual cue for success
            ),
          );
          _fetchAppointments(); // Refresh list
        }
      } else {
        throw Exception('Failed to delete: ${response.body}');
      }
    } catch (e) {
      print('Error in _deleteAppointment: $e'); // Debug print
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error cancelling appointment: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _showDeleteConfirmation(int id) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Cancel Appointment"),
          content: const Text("Are you sure you want to cancel this appointment? This action cannot be undone."),
          actions: [
            TextButton(
              child: const Text("No"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text("Yes, Cancel", style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteAppointment(id);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Stack(
        children: [
          // Background Header
          Container(
            height: 280,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF1F6EBB), Color(0xFF2DCE77)],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
          ),
          
          // Content
          SafeArea(
            child: Column(
              children: [
                // Top Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                       Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Welcome back,',
                            style: TextStyle(color: Colors.white70, fontSize: 14),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          _buildHeaderIcon(Icons.language),
                          const SizedBox(width: 12),
                          Stack(
                            children: [
                              _buildHeaderIcon(Icons.notifications_outlined),
                              Positioned(
                                right: 12,
                                top: 12,
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 10),

                // Main Content Switching
                Expanded(
                  child: _selectedIndex == 0 
                      ? _buildHomeContent() 
                      : _selectedIndex == 2 // Appointments Tab
                          ? _buildAppointmentsContent()
                          : _selectedIndex == 3 // Profile Tab
                              ? _buildProfileContent()
                              : Center(child: Text("Coming Soon", style: TextStyle(color: Colors.white))),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.home_outlined, 'Home'),
                _buildNavItem(1, Icons.description_outlined, 'Records'),
                const SizedBox(width: 48), // Space for FAB
                _buildNavItem(2, Icons.calendar_today_outlined, 'Appointments'),
                _buildNavItem(3, Icons.person_outline, 'Profile'),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Container(
        height: 64,
        width: 64,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [Color(0xFF1F6EBB), Color(0xFF2DCE77)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0x402DCE77),
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () {
             Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HealthIDScreen(
                  healthId: widget.healthId,
                  name: widget.name,
                ),
              ),
            );
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Icon(Icons.qr_code_scanner, color: Colors.white, size: 30),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildHomeContent() {
    // Find next appointment
    Map<String, dynamic>? nextAppointment;
    if (_appointments.isNotEmpty) {
      nextAppointment = _appointments.first;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 10),
          // Health ID Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white30),
            ),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.qr_code, color: Color(0xFF1F6EBB), size: 32),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Your Health ID',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.healthId.length > 12 
                            ? '${widget.healthId.substring(0, 8)}-...' 
                            : widget.healthId,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 30),
          
          // Stats Row
          Row(
            children: [
              _buildStatCard(
                icon: Icons.description_outlined,
                color: const Color(0xFFE3F2FD),
                iconColor: const Color(0xFF1976D2),
                value: '12',
                label: 'Health\nRecords',
              ),
              const SizedBox(width: 16),
              _buildStatCard(
                icon: Icons.calendar_today_outlined,
                color: const Color(0xFFE8F5E9),
                iconColor: const Color(0xFF388E3C),
                value: _appointments.length.toString(),
                label: 'Appointments',
              ),
              const SizedBox(width: 16),
              _buildStatCard(
                icon: Icons.notifications_none_outlined,
                color: const Color(0xFFFFF3E0),
                iconColor: const Color(0xFFF57C00),
                value: '5',
                label: 'Notifications',
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Next Appointment
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               _buildSectionHeader('Next Appointment'),
               GestureDetector(
                 onTap: () => setState(() {
                    _selectedIndex = 2;
                    _fetchAppointments();
                 }), // Switch to Appointments tab
                 child: const Text(
                   'View All',
                   style: TextStyle(
                     color: Color(0xFF1F6EBB),
                     fontWeight: FontWeight.w600,
                     fontSize: 14,
                   ),
                 ),
               ),
            ],
          ),
          const SizedBox(height: 12),
          _buildNextAppointmentCard(nextAppointment),
          
          const SizedBox(height: 24),
          
          // Recent Health Activity
           Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               _buildSectionHeader('Recent Health Activity'),
               const Text(
                 'View All',
                 style: TextStyle(
                   color: Color(0xFF1F6EBB),
                   fontWeight: FontWeight.w600,
                   fontSize: 14,
                 ),
               ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                 _buildActivityItem(
                  icon: Icons.favorite_border,
                  color: const Color(0xFFE3F2FD),
                  iconColor: const Color(0xFF1976D2),
                  title: 'Blood Pressure Check',
                  subtitle: 'PHC Ernakulam • 3 days ago',
                ),
                const Divider(height: 1, indent: 70, endIndent: 20),
                 _buildActivityItem(
                  icon: Icons.assignment_outlined,
                  color: const Color(0xFFE8F5E9),
                  iconColor: const Color(0xFF388E3C),
                  title: 'Lab Test - Blood Sugar',
                  subtitle: 'Lab Tech • 5 days ago',
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Notifications
          _buildSectionHeader('Notifications'),
          const SizedBox(height: 12),
          Container(
             decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                 _buildNotificationItem(
                   icon: Icons.notifications_none, 
                   iconColor: const Color(0xFFF57C00),
                   bgColor: const Color(0xFFFFF3E0),
                   title: 'COVID-19 Booster dose due',
                   subtitle: '2 days from now',
                   actionText: 'Schedule',
                 ),
                 const Divider(height: 1, indent: 70, endIndent: 20),
                 _buildNotificationItem(
                   icon: Icons.notifications_none, 
                   iconColor: const Color(0xFFF57C00),
                   bgColor: const Color(0xFFFFF3E0),
                   title: 'Follow-up visit for diabetes check',
                   subtitle: 'Tomorrow, 10:00 AM',
                   actionText: 'View Details',
                 ),
              ],
            ),
          ),

          const SizedBox(height: 100), // Bottom padding for FAB
        ],
      ),
    );
  }

  Widget _buildAppointmentsContent() {
    return Column(
      children: [
        // Title or Header for Appointments
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'My Appointments',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Since it's on the gradient background
                ),
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookAppointmentScreen(
                        healthId: widget.healthId,
                        name: widget.name,
                      ),
                    ),
                  );
                  if (result == true) {
                    _fetchAppointments(); // Refresh list
                  }
                },
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Book New'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF1F6EBB),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        
        // List area
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFFF5F7FA),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: _isLoadingAppointments 
                ? const Center(child: CircularProgressIndicator())
                : _appointments.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.calendar_today_outlined, size: 64, color: Colors.grey.shade300),
                            const SizedBox(height: 16),
                            Text(
                              'No appointments yet',
                              style: TextStyle(color: Colors.grey.shade500, fontSize: 16),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(20),
                        itemCount: _appointments.length,
                        itemBuilder: (context, index) {
                          final appt = _appointments[index];
                          // Format Date
                          String dateStr = appt['date'] ?? '';
                          try {
                              DateTime date = DateTime.parse(dateStr);
                              dateStr = "${date.day}-${date.month}-${date.year}"; 
                          } catch (e) {
                              dateStr = dateStr;
                          }

                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.02),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFE3F2FD),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        appt['visit_type'] ?? 'Visit',
                                        style: const TextStyle(
                                          color: Color(0xFF1976D2),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: (appt['status'] == 'Scheduled') 
                                            ? const Color(0xFFE8F5E9) 
                                            : Colors.grey.shade100,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        appt['status'] ?? 'Scheduled',
                                        style: TextStyle(
                                          color: (appt['status'] == 'Scheduled') 
                                              ? const Color(0xFF388E3C) 
                                              : Colors.grey.shade600,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    // Delete Button
                                    IconButton( // Added delete button
                                      icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                                      onPressed: () => _showDeleteConfirmation(appt['id']),
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Container(
                                      width: 48,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade100,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Icon(Icons.person, color: Color(0xFF1F6EBB)),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            appt['doctor_name'] ?? 'Doctor',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            appt['facility'] ?? 'Facility',
                                            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                const Divider(),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(Icons.calendar_today, size: 16, color: Colors.grey.shade500),
                                    const SizedBox(width: 8),
                                    Text(
                                      dateStr,
                                      style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                                    ),
                                    const SizedBox(width: 24),
                                    Icon(Icons.access_time, size: 16, color: Colors.grey.shade500),
                                    const SizedBox(width: 8),
                                    Text(
                                      appt['time'] ?? '',
                                      style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
          ),
        ),
      ],
    );
  }

  Widget _buildNextAppointmentCard(Map<String, dynamic>? appointment) {
    if (appointment == null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: const Center(
          child: Text("No upcoming appointments"),
        ),
      );
    }
    
    // Parse date for display
    String dateStr = appointment['date'] ?? '';
    try {
        DateTime date = DateTime.parse(dateStr);
        // Simple manual format or just use cleaned string
        dateStr = "${date.day}/${date.month}";
    } catch(e) {}

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
         boxShadow: [
             BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.calendar_today, color: Color(0xFF388E3C)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  appointment['visit_type'] ?? 'Appointment',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${appointment['doctor_name']} • ${appointment['facility']}',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
                const SizedBox(height: 4),
                Text(
                  '${dateStr}, ${appointment['time']}',
                  style: const TextStyle(
                    color: Color(0xFF1F6EBB),
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: Colors.white, size: 24),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color color,
    required Color iconColor,
    required String value,
    required String label,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
             BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.black54,
      ),
    );
  }



  Widget _buildActivityItem({
    required IconData icon,
    required Color color,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem({
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String title,
    required String subtitle,
    required String actionText,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Text(
                      actionText,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF1F6EBB),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() => _selectedIndex = index);
        if (index == 0) {
          _fetchAppointments();
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? const Color(0xFF1F6EBB) : Colors.grey,
            size: 26,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: isSelected ? const Color(0xFF1F6EBB) : Colors.grey,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
  Future<void> _updateEmergencyNumber(String? number) async {
    setState(() => _isUpdatingEmergency = true);
    final String baseUrl = kIsWeb ? 'http://localhost:3000' : 'http://10.0.2.2:3000';
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/api/profile/${widget.healthId}/emergency'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'emergencyNo': number}),
      );

      if (response.statusCode == 200) {
        // Update local profile data
        setState(() {
            if (_profileData != null) {
                _profileData!['emergency_no'] = number;
            }
        });
        if (mounted) {
           ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(number == null ? 'Emergency number removed' : 'Emergency number updated')),
          );
        }
      } else {
        throw Exception('Failed to update');
      }
    } catch (e) {
      if (mounted) {
         ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
      }
    } finally {
       setState(() => _isUpdatingEmergency = false);
    }
  }

  void _showEmergencyDialog({String? currentNumber}) {
      final TextEditingController controller = TextEditingController(text: currentNumber);
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
            title: Text(currentNumber == null ? 'Add Emergency Number' : 'Edit Emergency Number'),
            content: TextField(
                controller: controller,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                    labelText: 'Emergency Contact Number',
                    hintText: 'Enter 10-digit number',
                    border: OutlineInputBorder(),
                ),
            ),
            actions: [
                TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('Cancel'),
                ),
                ElevatedButton(
                    onPressed: () {
                        if (controller.text.isNotEmpty) {
                            _updateEmergencyNumber(controller.text);
                            Navigator.pop(ctx);
                        }
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1F6EBB)),
                    child: const Text('Save'),
                ),
            ],
        ),
      );
  }

  Widget _buildProfileContent() {
    if (_profileData == null && !_isLoadingProfile) {
       _fetchProfileDetails();
    }

    if (_isLoadingProfile) {
      return const Center(child: CircularProgressIndicator(color: Colors.white));
    }

    if (_profileData == null) {
      return const Center(child: Text("Failed to load profile", style: TextStyle(color: Colors.white)));
    }

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: Column(
          children: [
            // Header with Back Button and Edit Icon (Visual only as per request)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.black),
                        onPressed: () => setState(() => _selectedIndex = 0),
                      ),
                      const Text(
                        'Profile',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const Icon(Icons.edit_outlined, color: Color(0xFF1F6EBB)),
                ],
              ),
            ),
            const Divider(height: 1),
            
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Profile Avatar
                    Container(
                      width: 100,
                      height: 100,
                      decoration: const BoxDecoration(
                        color: Color(0xFF00897B),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.person_outline, size: 50, color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    
                    // Name
                    Text(
                      _profileData!['name'] ?? 'User',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    
                    // Health ID
                    Text(
                      'Health ID: ${_profileData!['health_id'] ?? widget.healthId}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Tabs
                    Row(
                      children: [
                        Expanded(child: _buildTabItem('Personal Info', 0)),
                        Expanded(child: _buildTabItem('Emergency', 1)),
                        Expanded(child: _buildTabItem('Health Info', 2)),
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    // Fields
                    _buildActiveTabContent(),
                    
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem(String title, int index) {
      final isSelected = _currentProfileTab == index;
    return InkWell(
      onTap: () => setState(() => _currentProfileTab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? const Color(0xFF1F6EBB) : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? const Color(0xFF1F6EBB) : Colors.grey.shade600,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildActiveTabContent() {
      if (_currentProfileTab == 0) {
          // Personal Info
          return Column(
              children: [
                _buildProfileField('Full Name', _profileData!['name'] ?? '', Icons.person_outline),
                const SizedBox(height: 16),
                _buildProfileField('Phone Number', _profileData!['phone'] ?? '', Icons.phone_outlined),
                const SizedBox(height: 16),
                _buildProfileField('Age', '${_profileData!['age'] ?? ''} years', null),
                const SizedBox(height: 16),
                _buildProfileField('Gender', _profileData!['gender'] ?? '', null),
                const SizedBox(height: 16),
                _buildProfileField('State of Origin', _profileData!['state'] ?? '', Icons.location_on_outlined),
                const SizedBox(height: 16),
                _buildProfileField('Occupation', _profileData!['occupation'] ?? '', Icons.work_outline),
              ],
          );
      } else if (_currentProfileTab == 1) {
          // Emergency
          return _buildEmergencyTab();
      } else {
          // Health Info (Placeholder)
           return const Center(child: Padding(
             padding: EdgeInsets.only(top: 40.0),
             child: Text("Health Information not available", style: TextStyle(color: Colors.grey)),
           ));
      }
  }

  Widget _buildEmergencyTab() {
      final emergencyNo = _profileData!['emergency_no'];
      
      if (_isUpdatingEmergency) {
          return const Center(child: Padding(
            padding: EdgeInsets.all(20.0),
            child: CircularProgressIndicator(),
          ));
      }

      if (emergencyNo == null || emergencyNo.toString().isEmpty) {
          return Column(
              children: [
                   Icon(Icons.contact_emergency, size: 60, color: Colors.grey.shade300),
                   const SizedBox(height: 16),
                   const Text(
                       "No emergency contact added",
                       style: TextStyle(color: Colors.grey, fontSize: 16),
                   ),
                   const SizedBox(height: 24),
                   ElevatedButton.icon(
                       onPressed: () => _showEmergencyDialog(),
                       icon: const Icon(Icons.add),
                       label: const Text("Add Emergency Number"),
                       style: ElevatedButton.styleFrom(
                           backgroundColor: const Color(0xFF1F6EBB),
                           padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                       ),
                   ),
              ],
          );
      }
      
      return Column(
          children: [
               Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red.shade100),
                  ),
                  child: Row(
                      children: [
                          Container(
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.phone_in_talk, color: Colors.red),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                      const Text(
                                          "Emergency Contact",
                                          style: TextStyle(fontSize: 12, color: Colors.grey),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                          emergencyNo,
                                          style: const TextStyle(
                                              fontSize: 18, 
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                          ),
                                      ),
                                  ],
                              ),
                          ),
                      ],
                  ),
               ),
               const SizedBox(height: 24),
               Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                       OutlinedButton.icon(
                           onPressed: () => _showEmergencyDialog(currentNumber: emergencyNo),
                           icon: const Icon(Icons.edit, size: 18),
                           label: const Text("Edit"),
                           style: OutlinedButton.styleFrom(foregroundColor: const Color(0xFF1F6EBB)),
                       ),
                       const SizedBox(width: 16),
                       OutlinedButton.icon(
                           onPressed: () {
                               showDialog(
                                   context: context, 
                                   builder: (ctx) => AlertDialog(
                                       title: const Text("Remove Number?"),
                                       content: const Text("Are you sure you want to remove this emergency contact?"),
                                       actions: [
                                           TextButton(
                                               onPressed: () => Navigator.pop(ctx), 
                                               child: const Text("Cancel"),
                                           ),
                                           TextButton(
                                               onPressed: () {
                                                   Navigator.pop(ctx);
                                                   _updateEmergencyNumber(null);
                                               }, 
                                               child: const Text("Remove", style: TextStyle(color: Colors.red)),
                                           ),
                                       ],
                                   ),
                               );
                           },
                           icon: const Icon(Icons.delete_outline, size: 18),
                           label: const Text("Remove"),
                           style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                       ),
                   ],
               ),
          ],
      );
  }

  Widget _buildProfileField(String label, String value, IconData? icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 14,
            ),
          ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
            // border: Border.all(color: Colors.grey.shade200), // Optional border
          ),
          child: Row(
            children: [
              if (icon != null) ...[
                Icon(icon, color: const Color(0xFF1F6EBB), size: 20),
                const SizedBox(width: 12),
              ],
              Text(
                value,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class BookAppointmentScreen extends StatefulWidget {
  final String healthId;
  final String name;

  const BookAppointmentScreen({
    super.key, 
    required this.healthId, 
    required this.name,
  });

  @override
  State<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _facilityController = TextEditingController();
  final TextEditingController _visitTypeController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  
  String? _selectedTime;
  String? _selectedDoctor; // Replaced manual facility with Doctor selection as per requirement "available doctors from healthworkers table"
  List<String> _doctors = [];
  bool _isLoadingDoctors = true;
  bool _isSubmitting = false;

  final List<String> _timeSlots = [
    '9:00 AM', '10:00 AM', '11:00 AM',
    '2:00 PM', '3:00 PM', '4:00 PM',
  ];

  @override
  void initState() {
    super.initState();
    _fetchDoctors();
  }

  Future<void> _fetchDoctors() async {
    final String baseUrl = kIsWeb ? 'http://localhost:3000' : 'http://10.0.2.2:3000';
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/doctors'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _doctors = data.map((d) => d['name'].toString()).toList();
          _isLoadingDoctors = false;
        });
      }
    } catch (e) {
      print('Error fetching doctors: $e');
      setState(() => _isLoadingDoctors = false);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> _bookAppointment() async {
    if (_formKey.currentState!.validate() && _selectedTime != null) {
      setState(() => _isSubmitting = true);
      
      final String baseUrl = kIsWeb ? 'http://localhost:3000' : 'http://10.0.2.2:3000';
      try {
        final response = await http.post(
          Uri.parse('$baseUrl/api/book-appointment'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'healthId': widget.healthId,
            'doctorName': _selectedDoctor ?? 'Assigned Doctor',
            'date': _dateController.text,
            'time': _selectedTime,
            'facility': _facilityController.text.isEmpty ? 'PHC Ernakulam' : _facilityController.text, // Default if empty
            'visitType': _visitTypeController.text.isEmpty ? 'General Checkup' : _visitTypeController.text,
            'notes': _notesController.text,
          }),
        );

        if (response.statusCode == 201) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Appointment Booked Successfully!')),
            );
            Navigator.pop(context, true); // Return true to refresh
          }
        } else {
           throw Exception('Failed to book');
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error booking appointment: $e')),
          );
        }
      } finally {
        setState(() => _isSubmitting = false);
      }
    } else if (_selectedTime == null) {
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a time slot')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.blue),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Book Appointment',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel('Select Date'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _dateController,
                readOnly: true,
                onTap: () => _selectDate(context),
                decoration: _inputDecoration('YYYY-MM-DD'),
                validator: (val) => val!.isEmpty ? 'Select a date' : null,
              ),
              const SizedBox(height: 20),
              
              _buildLabel('Select Time'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _timeSlots.map((time) {
                  final isSelected = _selectedTime == time;
                  return ChoiceChip(
                    label: Text(time),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() => _selectedTime = selected ? time : null);
                    },
                    selectedColor: Colors.blue.withOpacity(0.1),
                    backgroundColor: Colors.white,
                    side: BorderSide(color: isSelected ? Colors.blue : Colors.grey.shade300),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.blue : Colors.black,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              _buildLabel('Select Facility'),
              const SizedBox(height: 8),
              // Using doctor list for facility selection as an example of backend integration, 
              // but requirement says "show only available doctors".
              // Let's keep facility as a text field for now as per image UI, but maybe pre-fill?
              TextFormField(
                 controller: _facilityController,
                 decoration: _inputDecoration('Enter Facility Name'),
                 validator: (val) => val!.isEmpty ? 'Required' : null,
              ),

               const SizedBox(height: 20),
               if (_isLoadingDoctors)
                 const Center(child: CircularProgressIndicator())
               else ...[
                 _buildLabel('Select Doctor'),
                 const SizedBox(height: 8),
                 DropdownButtonFormField<String>(
                   value: _selectedDoctor,
                   items: _doctors.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
                   onChanged: (val) => setState(() => _selectedDoctor = val),
                   decoration: _inputDecoration('Choose a doctor'),
                   validator: (val) => val == null ? 'Please select a doctor' : null,
                 ),
               ],


              const SizedBox(height: 20),

              _buildLabel('Type of Visit'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _visitTypeController,
                decoration: _inputDecoration('e.g., General, Specialist'),
              ),
              const SizedBox(height: 20),

              _buildLabel('Additional Notes (Optional)'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _notesController,
                maxLines: 4,
                decoration: _inputDecoration('Any specific concerns or symptoms...'),
              ),
              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _bookAppointment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1F6EBB),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isSubmitting 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Confirm Appointment', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500));
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
    );
  }
}