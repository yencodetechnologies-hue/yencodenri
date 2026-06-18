import 'package:flutter/material.dart';
import '../../widgets/gradient_app_bar.dart';
import '../../widgets/gradient_button.dart';
import '../../services/api_service.dart';

class AddTenantScreen extends StatefulWidget {
  const AddTenantScreen({super.key});

  @override
  State<AddTenantScreen> createState() => _AddTenantScreenState();
}

class _AddTenantScreenState extends State<AddTenantScreen> {
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _aadhaarController = TextEditingController();
  final _panController = TextEditingController();
  final _addressController = TextEditingController();
  final _occupationController = TextEditingController();
  final _employerController = TextEditingController();
  final _emergencyController = TextEditingController();
  bool _loading = false;
  final _api = ApiService();

  Future<void> _submit() async {
    setState(() => _loading = true);
    try {
      await _api.createTenant({
        'name': _nameController.text.trim(),
        'mobile': _mobileController.text.trim(),
        'email': _emailController.text.trim(),
        'aadhaarPassport': _aadhaarController.text.trim(),
        'panCard': _panController.text.trim(),
        'currentAddress': _addressController.text.trim(),
        'occupation': _occupationController.text.trim(),
        'employerDetails': _employerController.text.trim(),
        'emergencyContact': _emergencyController.text.trim(),
      });
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GradientAppBar(title: 'Add Tenant'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Tenant Name')),
            const SizedBox(height: 12),
            TextField(controller: _mobileController, decoration: const InputDecoration(labelText: 'Mobile Number')),
            const SizedBox(height: 12),
            TextField(controller: _emailController, decoration: const InputDecoration(labelText: 'Email')),
            const SizedBox(height: 12),
            TextField(controller: _aadhaarController, decoration: const InputDecoration(labelText: 'Aadhaar / Passport')),
            const SizedBox(height: 12),
            TextField(controller: _panController, decoration: const InputDecoration(labelText: 'PAN Card')),
            const SizedBox(height: 12),
            TextField(controller: _addressController, decoration: const InputDecoration(labelText: 'Current Address')),
            const SizedBox(height: 12),
            TextField(controller: _occupationController, decoration: const InputDecoration(labelText: 'Occupation')),
            const SizedBox(height: 12),
            TextField(controller: _employerController, decoration: const InputDecoration(labelText: 'Employer Details')),
            const SizedBox(height: 12),
            TextField(controller: _emergencyController, decoration: const InputDecoration(labelText: 'Emergency Contact')),
            const SizedBox(height: 24),
            GradientButton(label: 'Save Tenant', onPressed: _submit, isLoading: _loading),
          ],
        ),
      ),
    );
  }
}
