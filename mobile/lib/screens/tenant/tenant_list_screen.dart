import 'package:flutter/material.dart';
import '../../widgets/gradient_app_bar.dart';
import '../../widgets/status_badge.dart';
import '../../services/api_service.dart';

class TenantListScreen extends StatefulWidget {
  const TenantListScreen({super.key});

  @override
  State<TenantListScreen> createState() => _TenantListScreenState();
}

class _TenantListScreenState extends State<TenantListScreen> {
  final _api = ApiService();
  List<dynamic> _tenants = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final data = await _api.getTenants();
      if (mounted) setState(() { _tenants = data; _loading = false; });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GradientAppBar(title: 'Tenants'),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/tenants/add').then((_) => _load()),
        backgroundColor: const Color(0xFF02AFEF),
        child: const Icon(Icons.add),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _tenants.length,
              itemBuilder: (context, i) {
                final t = _tenants[i];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.person)),
                    title: Text(t['name'] ?? ''),
                    subtitle: Text('${t['mobile']} • ${t['occupation'] ?? ''}'),
                    trailing: StatusBadge(status: t['status'] ?? 'pending'),
                    onTap: () => Navigator.pushNamed(context, '/tenants/detail', arguments: t),
                  ),
                );
              },
            ),
    );
  }
}
