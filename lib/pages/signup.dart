import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:telmed/pages/home.dart';
import 'package:telmed/utils/constants.dart';
import 'package:telmed/services/register.dart';
import 'package:telmed/pages/login.dart';
import 'package:telmed/models/user.dart';
import 'package:telmed/utils/helper_func.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _passwordStrengthNotifier = ValueNotifier<double>(0.0);
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _genderController = TextEditingController(text: 'Male');
  final TextEditingController _loginIdController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  final TextEditingController _confirmPwdController = TextEditingController();

  int _age = 18;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _qualification = qualifications.first;

  @override
  void dispose() {
    _passwordStrengthNotifier.dispose();
    super.dispose();
  }

  void _calculatePasswordStrength(String password) {
    double strength = 0.0;
    if (password.length >= 8) strength += 0.3;
    if (password.contains(RegExp(r'[A-Z]'))) strength += 0.2;
    if (password.contains(RegExp(r'[a-z]'))) strength += 0.2;
    if (password.contains(RegExp(r'[0-9]'))) strength += 0.2;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength += 0.1;
    _passwordStrengthNotifier.value = strength.clamp(0.0, 1.0);
  }

  void _showCloudAlert(String title, String content) {
    showDialog(
      context: context,
      builder: (context) => CloudAlertDialog(
        title: title,
        content: content,
      ),
    );
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    if (_pwdController.text != _confirmPwdController.text) {
      _showCloudAlert('Password Mismatch', 'Passwords do not match');
      return;
    }

    final user = User(
      "",
      _loginIdController.text,
      _pwdController.text,
      _nameController.text,
      _age,
      _genderController.text,
      _phoneController.text,
      _emailController.text,
      "",
      _qualification!,
      'pat',
      false,
    );

    final response = await RegisterUser().saveUser(user);
    HelperFunc().showAlertDialog(context, response[1], response[2]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FadeInUp(
                  duration: const Duration(milliseconds: 800),
                  child: const Text(
                    "Create Account",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Name Field
                _buildInputField(
                  label: 'Full Name',
                  controller: _nameController,
                  icon: Icons.person,
                  validator: (value) => value!.isEmpty 
                      ? 'Please enter your name' 
                      : null,
                ),

                // Email Field
                _buildInputField(
                  label: 'Email Address',
                  controller: _emailController,
                  icon: Icons.email,
                  validator: (value) => !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value!)
                      ? 'Enter a valid email address'
                      : null,
                ),

                // Login ID Field
                _buildInputField(
                  label: 'Login ID',
                  controller: _loginIdController,
                  icon: Icons.alternate_email,
                  validator: (value) => value!.isEmpty
                      ? 'Login ID is required'
                      : null,
                ),

                // Phone Field
                _buildInputField(
                  label: 'Phone Number',
                  controller: _phoneController,
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone,
                  validator: (value) => value!.length != 10 
                      ? 'Enter 10-digit phone number' 
                      : null,
                ),

                // Gender and Age Row
                Row(
                  children: [
                    Expanded(
                      child: _buildDropdown(
                        value: _genderController.text,
                        items: const ['Male', 'Female', 'Other'],
                        onChanged: (value) => setState(() => _genderController.text = value!),
                        label: 'Gender',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildAgeSelector(),
                    ),
                  ],
                ),

                // Password Field
                _buildPasswordField(
                  label: 'Password',
                  controller: _pwdController,
                  obscure: _obscurePassword,
                  onChanged: _calculatePasswordStrength,
                  onToggle: () => setState(() => _obscurePassword = !_obscurePassword),
                ),
                _buildPasswordStrengthIndicator(),

                // Confirm Password Field
                _buildPasswordField(
                  label: 'Confirm Password',
                  controller: _confirmPwdController,
                  obscure: _obscureConfirmPassword,
                  onToggle: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                ),

                const SizedBox(height: 32),
                _buildSubmitButton(),
                _buildLoginLink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required String? Function(String?) validator,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.deepPurple),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required bool obscure,
    required VoidCallback onToggle,
    void Function(String)? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.lock, color: Colors.deepPurple),
          suffixIcon: IconButton(
            icon: Icon(obscure ? Icons.visibility : Icons.visibility_off),
            onPressed: onToggle,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildPasswordStrengthIndicator() {
    return ValueListenableBuilder<double>(
      valueListenable: _passwordStrengthNotifier,
      builder: (context, strength, _) {
        final color = strength < 0.4 ? Colors.red 
            : strength < 0.7 ? Colors.orange 
            : Colors.green;
            
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: LinearProgressIndicator(
            value: strength,
            backgroundColor: Colors.grey.shade300,
            color: color,
            minHeight: 6,
            borderRadius: BorderRadius.circular(3),
          ),
        );
      },
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
    required String label,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      items: items.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildAgeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Age', style: TextStyle(color: Colors.deepPurple)),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.remove_circle),
              color: Colors.deepPurple,
              onPressed: () => setState(() => _age = _age > 0 ? _age - 1 : 0),
            ),
            Text('$_age', style: const TextStyle(fontSize: 18)),
            IconButton(
              icon: const Icon(Icons.add_circle),
              color: Colors.deepPurple,
              onPressed: () => setState(() => _age = _age < 100 ? _age + 1 : 100),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _submitForm,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurple,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: const Text(
        'SIGN UP',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildLoginLink() {
    return TextButton(
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      ),
      child: RichText(
        text: const TextSpan(
          style: TextStyle(color: Colors.grey),
          children: [
            TextSpan(text: 'Already have an account? '),
            TextSpan(
              text: 'Login',
              style: TextStyle(
                color: Colors.deepPurple,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CloudAlertDialog extends StatelessWidget {
  final String title;
  final String content;

  const CloudAlertDialog({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: ClipPath(
        clipper: CloudClipper(),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 12),
              Text(content, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('OK', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CloudClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width * 0.3, 0);
    path.quadraticBezierTo(size.width * 0.4, -20, size.width * 0.5, 0);
    path.quadraticBezierTo(size.width * 0.6, -20, size.width * 0.7, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}