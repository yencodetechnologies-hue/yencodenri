import 'package:flutter/material.dart';
import '../../widgets/gradient_app_bar.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/status_badge.dart';
import '../../services/api_service.dart';

class ConstructionScreen extends StatefulWidget {
  const ConstructionScreen({super.key});
  @override
  State<ConstructionScreen> createState() => _ConstructionScreenState();
}

class _ConstructionScreenState extends State<ConstructionScreen> {
  final _api = ApiService();
  List<dynamic> _projects = [];
  String _serviceType = 'new_construction';
  final _descController = TextEditingController();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final data = await _api.getConstructionProjects();
      if (mounted) setState(() => _projects = data);
    } catch (_) {}
  }

  Future<void> _request() async {
    setState(() => _loading = true);
    try {
      await _api.createConstructionProject({
        'serviceType': _serviceType,
        'description': _descController.text,
      });
      _load();
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Request submitted')));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GradientAppBar(title: 'Construction Services'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              value: _serviceType,
              decoration: const InputDecoration(labelText: 'Service Type'),
              items: const [
                DropdownMenuItem(value: 'new_construction', child: Text('New House Construction')),
                DropdownMenuItem(value: 'renovation', child: Text('Renovation')),
                DropdownMenuItem(value: 'interior_design', child: Text('Interior Design')),
                DropdownMenuItem(value: 'architecture', child: Text('Architecture')),
                DropdownMenuItem(value: 'structural_consulting', child: Text('Structural Consulting')),
              ],
              onChanged: (v) => setState(() => _serviceType = v!),
            ),
            const SizedBox(height: 12),
            TextField(controller: _descController, decoration: const InputDecoration(labelText: 'Project Description'), maxLines: 3),
            const SizedBox(height: 16),
            GradientButton(label: 'Request Quotation', onPressed: _request, isLoading: _loading),
            const SizedBox(height: 24),
            const Text('My Projects', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ..._projects.map((p) => Card(
                  child: ListTile(
                    title: Text(p['serviceType']?.toString().replaceAll('_', ' ') ?? ''),
                    subtitle: Text('Quote: ₹${p['quotation'] ?? 0}'),
                    trailing: StatusBadge(status: p['status'] ?? 'requested'),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class LegalScreen extends StatefulWidget {
  const LegalScreen({super.key});
  @override
  State<LegalScreen> createState() => _LegalScreenState();
}

class _LegalScreenState extends State<LegalScreen> {
  final _api = ApiService();
  List<dynamic> _cases = [];
  String _serviceType = 'property_verification';
  final _descController = TextEditingController();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final data = await _api.getLegalCases();
      if (mounted) setState(() => _cases = data);
    } catch (_) {}
  }

  Future<void> _submit() async {
    setState(() => _loading = true);
    try {
      await _api.createLegalCase({
        'serviceType': _serviceType,
        'description': _descController.text,
      });
      _load();
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Legal service requested')));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GradientAppBar(title: 'Legal Services'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              value: _serviceType,
              decoration: const InputDecoration(labelText: 'Service Type'),
              items: const [
                DropdownMenuItem(value: 'property_verification', child: Text('Property Verification')),
                DropdownMenuItem(value: 'document_verification', child: Text('Document Verification')),
                DropdownMenuItem(value: 'sale_deed_registration', child: Text('Sale Deed Registration')),
                DropdownMenuItem(value: 'rental_agreement_registration', child: Text('Rental Agreement Registration')),
                DropdownMenuItem(value: 'legal_consultation', child: Text('Legal Consultation')),
              ],
              onChanged: (v) => setState(() => _serviceType = v!),
            ),
            const SizedBox(height: 12),
            TextField(controller: _descController, decoration: const InputDecoration(labelText: 'Description'), maxLines: 3),
            const SizedBox(height: 16),
            GradientButton(label: 'Book Lawyer', onPressed: _submit, isLoading: _loading),
            const SizedBox(height: 24),
            const Text('My Cases', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ..._cases.map((c) => Card(
                  child: ListTile(
                    title: Text(c['serviceType']?.toString().replaceAll('_', ' ') ?? ''),
                    trailing: StatusBadge(status: c['status'] ?? 'requested'),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});
  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  final _api = ApiService();
  List<dynamic> _fees = [];
  List<dynamic> _subscriptions = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final fees = await _api.getFees();
      final subs = await _api.getMySubscriptions();
      if (mounted) setState(() { _fees = fees; _subscriptions = subs; });
    } catch (_) {}
  }

  Future<void> _subscribe() async {
    try {
      final props = await _api.getProperties();
      if (props.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Add a property first')));
        return;
      }
      await _api.createSubscription(props.first['_id']);
      _load();
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Subscription initiated - ₹14,160 (incl. GST)')));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GradientAppBar(title: 'Subscription & Fees'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Annual Subscription', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const Text('₹12,000 + 18% GST = ₹14,160 per property/year'),
                  const SizedBox(height: 12),
                  GradientButton(label: 'Subscribe Now', onPressed: _subscribe),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Fee Schedule', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ..._fees.map((f) => ListTile(
                title: Text(f['feeType'] ?? ''),
                subtitle: Text(f['description'] ?? ''),
                trailing: Text(f['amount'] == 0 ? 'Quoted' : '₹${f['amount']}'),
              )),
          const SizedBox(height: 16),
          const Text('My Subscriptions', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ..._subscriptions.map((s) => ListTile(
                title: Text('₹${s['totalAmount']}'),
                trailing: StatusBadge(status: s['status'] ?? 'pending'),
              )),
        ],
      ),
    );
  }
}

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});
  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final _api = ApiService();
  List<dynamic> _notifications = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final data = await _api.getNotifications();
      if (mounted) setState(() => _notifications = data);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GradientAppBar(title: 'Notifications'),
      body: ListView.builder(
        itemCount: _notifications.length,
        itemBuilder: (context, i) {
          final n = _notifications[i];
          return ListTile(
            leading: Icon(n['isRead'] == true ? Icons.notifications : Icons.notifications_active),
            title: Text(n['title'] ?? ''),
            subtitle: Text(n['body'] ?? ''),
          );
        },
      ),
    );
  }
}
