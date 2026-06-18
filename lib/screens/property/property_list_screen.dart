import 'package:flutter/material.dart';
import '../../widgets/gradient_app_bar.dart';
import '../../widgets/status_badge.dart';
import '../../services/api_service.dart';

class PropertyListScreen extends StatefulWidget {
  const PropertyListScreen({super.key});

  @override
  State<PropertyListScreen> createState() => _PropertyListScreenState();
}

class _PropertyListScreenState extends State<PropertyListScreen> {
  final _api = ApiService();
  List<dynamic> _properties = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final data = await _api.getProperties();
      if (mounted) setState(() { _properties = data; _loading = false; });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GradientAppBar(title: 'My Properties'),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/properties/add').then((_) => _load()),
        backgroundColor: const Color(0xFF02AFEF),
        child: const Icon(Icons.add),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _properties.isEmpty
              ? const Center(child: Text('No properties yet. Add your first property.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _properties.length,
                  itemBuilder: (context, i) {
                    final p = _properties[i];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: const CircleAvatar(child: Icon(Icons.home_work)),
                        title: Text(p['name'] ?? ''),
                        subtitle: Text('${p['propertyType']} • ${p['address']}'),
                        trailing: StatusBadge(status: p['verificationStatus'] ?? 'pending'),
                        onTap: () => Navigator.pushNamed(context, '/properties/detail', arguments: p),
                      ),
                    );
                  },
                ),
    );
  }
}
