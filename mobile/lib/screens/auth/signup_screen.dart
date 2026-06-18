import 'package:flutter/material.dart';
import '../../widgets/gradient_app_bar.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/otp_input.dart';
import '../../services/auth_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _countryController = TextEditingController();
  final _addressController = TextEditingController();
  final _authService = AuthService();
  bool _termsAccepted = false;
  bool _privacyAccepted = false;
  bool _isLoading = false;
  bool _showOtp = false;
  String _otp = '';

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_termsAccepted || !_privacyAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please accept Terms and Privacy Policy')));
      return;
    }
    setState(() => _isLoading = true);
    try {
      await _authService.register({
        'fullName': _fullNameController.text.trim(),
        'email': _emailController.text.trim(),
        'mobile': _mobileController.text.trim(),
        'password': _passwordController.text,
        'confirmPassword': _confirmPasswordController.text,
        'country': _countryController.text.trim(),
        'address': _addressController.text.trim(),
        'termsAccepted': _termsAccepted,
        'privacyAccepted': _privacyAccepted,
      });
      if (mounted) setState(() => _showOtp = true);
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _verifyOtp() async {
    if (_otp.length != 6) return;
    setState(() => _isLoading = true);
    try {
      await _authService.verifyOtp(_emailController.text.trim(), _otp, 'register');
      if (mounted) Navigator.pushReplacementNamed(context, '/dashboard');
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GradientAppBar(title: 'Sign Up'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: _showOtp ? _buildOtpStep() : _buildForm(),
      ),
    );
  }

  Widget _buildOtpStep() {
    return Column(
      children: [
        const SizedBox(height: 40),
        const Text('Verify OTP', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text('Enter the 6-digit code sent to ${_emailController.text}', textAlign: TextAlign.center),
        const SizedBox(height: 32),
        OtpInput(onCompleted: (code) => _otp = code),
        const SizedBox(height: 32),
        GradientButton(label: 'Verify & Register', onPressed: _verifyOtp, isLoading: _isLoading),
      ],
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(controller: _fullNameController, decoration: const InputDecoration(labelText: 'Full Name'), validator: (v) => v!.isEmpty ? 'Required' : null),
          const SizedBox(height: 12),
          TextFormField(controller: _emailController, decoration: const InputDecoration(labelText: 'Email ID'), keyboardType: TextInputType.emailAddress, validator: (v) => v!.isEmpty ? 'Required' : null),
          const SizedBox(height: 12),
          TextFormField(controller: _mobileController, decoration: const InputDecoration(labelText: 'Mobile Number'), keyboardType: TextInputType.phone, validator: (v) => v!.isEmpty ? 'Required' : null),
          const SizedBox(height: 12),
          TextFormField(controller: _passwordController, decoration: const InputDecoration(labelText: 'Password'), obscureText: true, validator: (v) => v!.length < 6 ? 'Min 6 characters' : null),
          const SizedBox(height: 12),
          TextFormField(controller: _confirmPasswordController, decoration: const InputDecoration(labelText: 'Confirm Password'), obscureText: true, validator: (v) => v != _passwordController.text ? 'Passwords do not match' : null),
          const SizedBox(height: 12),
          TextFormField(controller: _countryController, decoration: const InputDecoration(labelText: 'Country of Residence')),
          const SizedBox(height: 12),
          TextFormField(controller: _addressController, decoration: const InputDecoration(labelText: 'Address'), maxLines: 2),
          const SizedBox(height: 16),
          CheckboxListTile(
            value: _termsAccepted,
            onChanged: (v) => setState(() => _termsAccepted = v ?? false),
            title: const Text('Accept Terms of Service', style: TextStyle(fontSize: 14)),
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
          ),
          CheckboxListTile(
            value: _privacyAccepted,
            onChanged: (v) => setState(() => _privacyAccepted = v ?? false),
            title: const Text('Accept Privacy Policy', style: TextStyle(fontSize: 14)),
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
          ),
          const SizedBox(height: 24),
          GradientButton(label: 'Register', onPressed: _register, isLoading: _isLoading),
        ],
      ),
    );
  }
}
