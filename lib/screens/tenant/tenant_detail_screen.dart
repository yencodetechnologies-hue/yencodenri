import 'package:flutter/material.dart';
import '../../widgets/gradient_app_bar.dart';
import '../../widgets/status_badge.dart';

class TenantDetailScreen extends StatelessWidget {
  const TenantDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tenant = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      appBar: const GradientAppBar(title: 'Tenant Verification'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(tenant['name'] ?? '', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      StatusBadge(status: tenant['status'] ?? 'pending'),
                    ],
                  ),
                  const Divider(),
                  _Row('Mobile', tenant['mobile']),
                  _Row('Email', tenant['email']),
                  _Row('Aadhaar/Passport', tenant['aadhaarPassport']),
                  _Row('PAN', tenant['panCard']),
                  _Row('Address', tenant['currentAddress']),
                  _Row('Occupation', tenant['occupation']),
                  _Row('Employer', tenant['employerDetails']),
                  _Row('Emergency', tenant['emergencyContact']),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Verification Status', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          _VerifyChip('Identity', tenant['identityVerified'] == true),
          _VerifyChip('Background', tenant['backgroundVerified'] == true),
          _VerifyChip('Police', tenant['policeVerified'] == true),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String? value;
  const _Row(this.label, this.value);
  @override
  Widget build(BuildContext context) {
    if (value == null || value!.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(children: [
        SizedBox(width: 120, child: Text(label, style: const TextStyle(fontWeight: FontWeight.w500))),
        Expanded(child: Text(value!)),
      ]),
    );
  }
}

class _VerifyChip extends StatelessWidget {
  final String label;
  final bool verified;
  const _VerifyChip(this.label, this.verified);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(verified ? Icons.check_circle : Icons.pending, color: verified ? Colors.green : Colors.orange),
      title: Text('$label Verification'),
      trailing: Text(verified ? 'Verified' : 'Pending'),
    );
  }
}
