import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/gradient_app_bar.dart';
import '../../widgets/status_badge.dart';
import '../../services/api_service.dart';
import '../../services/auth_service.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});
  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _index = 0;

  final _screens = const [
    _AdminUsersTab(),
    _AdminPropertiesTab(),
    _AdminTenantsTab(),
    _AdminFinanceTab(),
    _AdminServicesTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: 'Admin Panel',
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await AuthService().logout();
              if (context.mounted) Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: _screens[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.people), label: 'Users'),
          NavigationDestination(icon: Icon(Icons.home_work), label: 'Properties'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Tenants'),
          NavigationDestination(icon: Icon(Icons.account_balance), label: 'Finance'),
          NavigationDestination(icon: Icon(Icons.handyman), label: 'Services'),
        ],
      ),
    );
  }
}

class _AdminUsersTab extends StatefulWidget {
  const _AdminUsersTab();
  @override
  State<_AdminUsersTab> createState() => _AdminUsersTabState();
}

class _AdminUsersTabState extends State<_AdminUsersTab> {
  final _api = ApiService();
  List<dynamic> _users = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final data = await _api.adminGetUsers();
      if (mounted) setState(() => _users = data);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _users.length,
      itemBuilder: (context, i) {
        final u = _users[i];
        return Card(
          child: ListTile(
            title: Text(u['fullName'] ?? ''),
            subtitle: Text('${u['email']} • ${u['mobile']}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (u['isVerified'] != true)
                  IconButton(icon: const Icon(Icons.verified, color: Colors.green), onPressed: () async {
                    await _api.adminVerifyUser(u['_id']);
                    _load();
                  }),
                if (u['isSuspended'] != true)
                  IconButton(icon: const Icon(Icons.block, color: Colors.red), onPressed: () async {
                    await _api.adminSuspendUser(u['_id']);
                    _load();
                  }),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _AdminPropertiesTab extends StatefulWidget {
  const _AdminPropertiesTab();
  @override
  State<_AdminPropertiesTab> createState() => _AdminPropertiesTabState();
}

class _AdminPropertiesTabState extends State<_AdminPropertiesTab> {
  final _api = ApiService();
  List<dynamic> _properties = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final data = await _api.adminGetProperties();
      if (mounted) setState(() => _properties = data);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _properties.length,
      itemBuilder: (context, i) {
        final p = _properties[i];
        return Card(
          child: ListTile(
            title: Text(p['name'] ?? ''),
            subtitle: Text(p['address'] ?? ''),
            trailing: StatusBadge(status: p['verificationStatus'] ?? 'pending'),
            onTap: () => _showActions(p),
          ),
        );
      },
    );
  }

  void _showActions(Map<String, dynamic> p) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.check, color: Colors.green),
            title: const Text('Verify'),
            onTap: () async {
              await _api.adminVerifyProperty(p['_id'], 'verified');
              _load();
              if (ctx.mounted) Navigator.pop(ctx);
            },
          ),
          ListTile(
            leading: const Icon(Icons.close, color: Colors.red),
            title: const Text('Reject'),
            onTap: () async {
              await _api.adminVerifyProperty(p['_id'], 'rejected', reason: 'Documents incomplete');
              _load();
              if (ctx.mounted) Navigator.pop(ctx);
            },
          ),
        ],
      ),
    );
  }
}

class _AdminTenantsTab extends StatefulWidget {
  const _AdminTenantsTab();
  @override
  State<_AdminTenantsTab> createState() => _AdminTenantsTabState();
}

class _AdminTenantsTabState extends State<_AdminTenantsTab> {
  final _api = ApiService();
  List<dynamic> _tenants = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final data = await _api.adminGetTenants();
      if (mounted) setState(() => _tenants = data);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _tenants.length,
      itemBuilder: (context, i) {
        final t = _tenants[i];
        return Card(
          child: ListTile(
            title: Text(t['name'] ?? ''),
            subtitle: Text(t['mobile'] ?? ''),
            trailing: StatusBadge(status: t['status'] ?? 'pending'),
            onTap: () async {
              await _api.adminVerifyTenant(t['_id'], {
                'status': 'verified',
                'identityVerified': true,
                'backgroundVerified': true,
                'policeVerified': true,
              });
              _load();
            },
          ),
        );
      },
    );
  }
}

class _AdminFinanceTab extends StatefulWidget {
  const _AdminFinanceTab();
  @override
  State<_AdminFinanceTab> createState() => _AdminFinanceTabState();
}

class _AdminFinanceTabState extends State<_AdminFinanceTab> {
  final _api = ApiService();
  Map<String, dynamic>? _finance;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final data = await _api.adminGetFinance();
      if (mounted) setState(() => _finance = data);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(locale: 'en_IN', symbol: '₹');
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _FinanceCard('Subscription Revenue', currency.format(_finance?['subscriptionRevenue'] ?? 0)),
        _FinanceCard('Rent Revenue', currency.format(_finance?['rentRevenue'] ?? 0)),
        _FinanceCard('GST Collected', currency.format(_finance?['gstCollected'] ?? 0)),
        _FinanceCard('Total Revenue', currency.format(_finance?['totalRevenue'] ?? 0), highlight: true),
        const SizedBox(height: 16),
        const Text('Listings', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        _AdminListingsSection(),
      ],
    );
  }
}

class _FinanceCard extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;
  const _FinanceCard(this.label, this.value, {this.highlight = false});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: highlight ? AppColors.primaryDark : null,
      child: ListTile(
        title: Text(label, style: TextStyle(color: highlight ? Colors.white : null)),
        trailing: Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: highlight ? Colors.white : AppColors.primaryAccent)),
      ),
    );
  }
}

class _AdminListingsSection extends StatefulWidget {
  @override
  State<_AdminListingsSection> createState() => _AdminListingsSectionState();
}

class _AdminListingsSectionState extends State<_AdminListingsSection> {
  final _api = ApiService();
  List<dynamic> _listings = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final data = await _api.adminGetListings();
      if (mounted) setState(() => _listings = data);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _listings.map((l) => Card(
            child: ListTile(
              title: Text(l['title'] ?? ''),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  StatusBadge(status: l['status'] ?? 'pending'),
                  IconButton(
                    icon: const Icon(Icons.check, color: Colors.green),
                    onPressed: () async {
                      await _api.adminApproveListing(l['_id']);
                      _load();
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: () async {
                      await _api.adminRejectListing(l['_id'], 'Rejected by admin');
                      _load();
                    },
                  ),
                ],
              ),
            ),
          )).toList(),
    );
  }
}

class _AdminServicesTab extends StatefulWidget {
  const _AdminServicesTab();
  @override
  State<_AdminServicesTab> createState() => _AdminServicesTabState();
}

class _AdminServicesTabState extends State<_AdminServicesTab> {
  final _api = ApiService();
  List<dynamic> _requests = [];
  List<dynamic> _vendors = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final reqs = await _api.adminGetServiceRequests();
      final vendors = await _api.adminGetVendors();
      if (mounted) setState(() { _requests = reqs; _vendors = vendors; });
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Service Requests', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            TextButton(
              onPressed: () => _addVendor(),
              child: const Text('Add Vendor'),
            ),
          ],
        ),
        ..._requests.map((r) => Card(
              child: ListTile(
                title: Text(r['category']?.toString().replaceAll('_', ' ') ?? ''),
                subtitle: Text(r['description'] ?? ''),
                trailing: StatusBadge(status: r['status'] ?? 'open'),
                onTap: () => _assignVendor(r),
              ),
            )),
        const SizedBox(height: 16),
        const Text('Vendors', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ..._vendors.map((v) => ListTile(title: Text(v['name'] ?? ''), subtitle: Text(v['category'] ?? ''))),
      ],
    );
  }

  void _assignVendor(Map<String, dynamic> request) {
    if (_vendors.isEmpty) return;
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: _vendors.map((v) => ListTile(
              title: Text(v['name'] ?? ''),
              onTap: () async {
                await _api.adminAssignVendor(request['_id'], v['_id']);
                _load();
                if (ctx.mounted) Navigator.pop(ctx);
              },
            )).toList(),
      ),
    );
  }

  void _addVendor() {
    final nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Vendor'),
        content: TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Vendor Name')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              await _api.adminCreateVendor({'name': nameController.text, 'category': 'plumbing'});
              _load();
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
