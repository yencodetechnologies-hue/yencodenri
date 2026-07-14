import 'package:flutter/material.dart';
import '../../widgets/gradient_app_bar.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/status_badge.dart';
import '../../services/api_service.dart';

class ServiceRequestListScreen extends StatefulWidget {
  const ServiceRequestListScreen({super.key});
  @override
  State<ServiceRequestListScreen> createState() =>
      _ServiceRequestListScreenState();
}

class _ServiceRequestListScreenState extends State<ServiceRequestListScreen> {
  final _api = ApiService();
  List<dynamic> _requests = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final data = await _api.getServiceRequests();
      if (mounted)
        setState(() {
          _requests = data;
          _loading = false;
        });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GradientAppBar(title: 'Service Requests'),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(
          context,
          '/service-requests/create',
        ).then((_) => _load()),
        backgroundColor: const Color(0xFF02AFEF),
        child: const Icon(Icons.add),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _requests.length,
              itemBuilder: (context, i) {
                final r = _requests[i];
                return Card(
                  child: ListTile(
                    leading: Icon(_categoryIcon(r['category'])),
                    title: Text(
                      r['category']?.toString().replaceAll('_', ' ') ?? '',
                    ),
                    subtitle: Text(r['description'] ?? ''),
                    trailing: StatusBadge(status: r['status'] ?? 'open'),
                  ),
                );
              },
            ),
    );
  }

  IconData _categoryIcon(String? cat) {
    switch (cat) {
      case 'plumbing':
        return Icons.plumbing;
      case 'electrical':
        return Icons.electrical_services;
      case 'cleaning':
        return Icons.cleaning_services;
      case 'painting':
        return Icons.format_paint;
      default:
        return Icons.handyman;
    }
  }
}

class CreateServiceRequestScreen extends StatefulWidget {
  const CreateServiceRequestScreen({super.key});
  @override
  State<CreateServiceRequestScreen> createState() =>
      _CreateServiceRequestScreenState();
}

class _CreateServiceRequestScreenState
    extends State<CreateServiceRequestScreen> {
  String _category = 'plumbing';
  final _descController = TextEditingController();
  bool _loading = false;
  final _api = ApiService();

  Future<void> _submit() async {
    setState(() => _loading = true);
    try {
      await _api.createServiceRequest({
        'category': _category,
        'description': _descController.text,
      });
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GradientAppBar(title: 'Create Request'),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              initialValue: _category,
              decoration: const InputDecoration(labelText: 'Category'),
              items: const [
                DropdownMenuItem(value: 'plumbing', child: Text('Plumbing')),
                DropdownMenuItem(
                  value: 'electrical',
                  child: Text('Electrical'),
                ),
                DropdownMenuItem(value: 'cleaning', child: Text('Cleaning')),
                DropdownMenuItem(value: 'painting', child: Text('Painting')),
                DropdownMenuItem(
                  value: 'pest_control',
                  child: Text('Pest Control'),
                ),
                DropdownMenuItem(value: 'carpentry', child: Text('Carpentry')),
                DropdownMenuItem(
                  value: 'appliance_repair',
                  child: Text('Appliance Repair'),
                ),
              ],
              onChanged: (v) => setState(() => _category = v!),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 4,
            ),
            const SizedBox(height: 24),
            GradientButton(
              label: 'Submit Request',
              onPressed: _submit,
              isLoading: _loading,
            ),
          ],
        ),
      ),
    );
  }
}
