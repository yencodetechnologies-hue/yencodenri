import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../widgets/gradient_app_bar.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/status_badge.dart';
import '../../services/api_service.dart';

class RentPaymentScreen extends StatefulWidget {
  const RentPaymentScreen({super.key});
  @override
  State<RentPaymentScreen> createState() => _RentPaymentScreenState();
}

class _RentPaymentScreenState extends State<RentPaymentScreen> {
  final _api = ApiService();
  List<dynamic> _history = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final data = await _api.getRentHistory();
      if (mounted)
        setState(() {
          _history = data;
          _loading = false;
        });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(locale: 'en_IN', symbol: '₹');
    return Scaffold(
      appBar: const GradientAppBar(title: 'Rent Collection'),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text(
                  'Payment History',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                ..._history.map(
                  (p) => Card(
                    child: ListTile(
                      title: Text(currency.format(p['amount'])),
                      subtitle: Text(
                        'Due: ${p['dueDate']?.toString().substring(0, 10) ?? ''} • ${p['method'] ?? ''}',
                      ),
                      trailing: StatusBadge(status: p['status'] ?? 'pending'),
                    ),
                  ),
                ),
                if (_history.isEmpty)
                  const Center(child: Text('No payment history')),
              ],
            ),
    );
  }
}

class MaintenanceScreen extends StatefulWidget {
  const MaintenanceScreen({super.key});
  @override
  State<MaintenanceScreen> createState() => _MaintenanceScreenState();
}

class _MaintenanceScreenState extends State<MaintenanceScreen> {
  final _api = ApiService();
  List<dynamic> _history = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final data = await _api.getMaintenanceHistory();
      if (mounted)
        setState(() {
          _history = data;
        });
    } catch (_) {}
  }

  Future<void> _pay(String type) async {
    try {
      final props = await _api.getProperties();
      if (props.isEmpty) return;
      await _api.createMaintenancePayment({
        'propertyId': props.first['_id'],
        'type': type,
        'description': '$type payment',
        'amount': 5000,
      });
      _load();
      if (mounted)
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Payment initiated')));
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GradientAppBar(title: 'Maintenance'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          GradientButton(
            label: 'Pay Society Maintenance',
            onPressed: () => _pay('society'),
          ),
          const SizedBox(height: 12),
          GradientButton(
            label: 'Pay Utility Bill',
            onPressed: () => _pay('utility'),
          ),
          const SizedBox(height: 12),
          GradientButton(
            label: 'Pay Property Tax',
            onPressed: () => _pay('property_tax'),
          ),
          const SizedBox(height: 24),
          const Text(
            'Payment History',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          ..._history.map(
            (p) => ListTile(
              title: Text('${p['type']} - ₹${p['amount']}'),
              trailing: StatusBadge(status: p['status']),
            ),
          ),
        ],
      ),
    );
  }
}
