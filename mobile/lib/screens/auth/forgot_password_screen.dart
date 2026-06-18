import 'package:flutter/material.dart';
import '../../widgets/gradient_app_bar.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/otp_input.dart';
import '../../services/auth_service.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _identifierController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _authService = AuthService();
  bool _otpSent = false;
  bool _isLoading = false;
  String _otp = '';
  String _email = '';

  Future<void> _sendOtp() async {
    setState(() => _isLoading = true);
    try {
      final res = await _authService.forgotPassword(_identifierController.text.trim());
      _email = res['data']?['email'] ?? _identifierController.text.trim();
      if (mounted) setState(() => _otpSent = true);
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _resetPassword() async {
    if (_newPasswordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Passwords do not match')));
      return;
    }
    setState(() => _isLoading = true);
    try {
      await _authService.resetPassword({
        'identifier': _identifierController.text.trim(),
        'code': _otp,
        'newPassword': _newPasswordController.text,
        'confirmPassword': _confirmPasswordController.text,
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password changed successfully')));
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GradientAppBar(title: 'Forgot Password'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            if (!_otpSent) ...[
              TextField(
                controller: _identifierController,
                decoration: const InputDecoration(labelText: 'Email ID / Mobile Number'),
              ),
              const SizedBox(height: 24),
              GradientButton(label: 'Send OTP', onPressed: _sendOtp, isLoading: _isLoading),
            ] else ...[
              Text('OTP sent to $_email', textAlign: TextAlign.center),
              const SizedBox(height: 24),
              OtpInput(onCompleted: (code) => _otp = code),
              const SizedBox(height: 24),
              TextField(controller: _newPasswordController, decoration: const InputDecoration(labelText: 'New Password'), obscureText: true),
              const SizedBox(height: 12),
              TextField(controller: _confirmPasswordController, decoration: const InputDecoration(labelText: 'Confirm Password'), obscureText: true),
              const SizedBox(height: 24),
              GradientButton(label: 'Change Password', onPressed: _resetPassword, isLoading: _isLoading),
            ],
          ],
        ),
      ),
    );
  }
}
