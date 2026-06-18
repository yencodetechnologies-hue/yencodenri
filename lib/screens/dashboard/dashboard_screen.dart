import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/gradient_app_bar.dart';
import '../../widgets/stat_card.dart';
import '../../services/api_service.dart';
import '../../services/auth_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _api = ApiService();
  Map<String, dynamic>? _data;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final data = await _api.getDashboard();
      if (mounted) setState(() { _data = data; _loading = false; });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _logout() async {
    await AuthService().logout();
    if (mounted) Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

    return Scaffold(
      appBar: GradientAppBar(
        title: 'Dashboard',
        actions: [
          IconButton(icon: const Icon(Icons.notifications_outlined), onPressed: () => Navigator.pushNamed(context, '/notifications')),
          IconButton(icon: const Icon(Icons.logout), onPressed: _logout),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _load,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Overview', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
                    const SizedBox(height: 12),
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1.3,
                      children: [
                        StatCard(title: 'Total Properties', value: '${_data?['totalProperties'] ?? 0}', icon: Icons.home_work),
                        StatCard(title: 'Active Tenants', value: '${_data?['activeTenants'] ?? 0}', icon: Icons.people),
                        StatCard(title: 'Monthly Income', value: currency.format(_data?['monthlyRentalIncome'] ?? 0), icon: Icons.payments),
                        StatCard(title: 'Pending Requests', value: '${_data?['pendingServiceRequests'] ?? 0}', icon: Icons.build),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text('Quick Actions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
                    const SizedBox(height: 12),
                    _QuickActionsGrid(),
                  ],
                ),
              ),
            ),
      drawer: _AppDrawer(),
    );
  }
}

class _QuickActionsGrid extends StatelessWidget {
  final actions = const [
    ('Post Property', Icons.add_home, '/properties/add'),
    ('Rent Property', Icons.key, '/listings/sell'),
    ('Buy Property', Icons.search, '/listings/buy'),
    ('Sell Property', Icons.sell, '/listings/sell'),
    ('Construction', Icons.construction, '/construction'),
    ('Legal Services', Icons.gavel, '/legal'),
    ('Rent Collection', Icons.payment, '/rent'),
    ('Maintenance', Icons.home_repair_service, '/maintenance'),
    ('Service Requests', Icons.handyman, '/service-requests'),
    ('Subscription', Icons.card_membership, '/subscription'),
  ];

  const _QuickActionsGrid();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 0.9),
      itemCount: actions.length,
      itemBuilder: (context, i) {
        final (label, icon, route) = actions[i];
        return InkWell(
          onTap: () => Navigator.pushNamed(context, route),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              gradient: AppColors.brandGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white, size: 28),
                const SizedBox(height: 6),
                Text(label, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final items = [
      ('Dashboard', Icons.dashboard, '/dashboard'),
      ('Properties', Icons.home_work, '/properties'),
      ('Tenants', Icons.people, '/tenants'),
      ('Agreements', Icons.description, '/agreements'),
      ('Rent Collection', Icons.payment, '/rent'),
      ('Maintenance', Icons.home_repair_service, '/maintenance'),
      ('Service Requests', Icons.handyman, '/service-requests'),
      ('Buy Property', Icons.search, '/listings/buy'),
      ('Sell Property', Icons.sell, '/listings/sell'),
      ('Construction', Icons.construction, '/construction'),
      ('Legal', Icons.gavel, '/legal'),
      ('Subscription', Icons.card_membership, '/subscription'),
    ];

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(gradient: AppColors.brandGradient),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.home_work, color: Colors.white, size: 40),
                SizedBox(height: 8),
                Text('NRI Property', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          ...items.map((item) => ListTile(
                leading: Icon(item.$2, color: AppColors.primaryDark),
                title: Text(item.$1),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, item.$3);
                },
              )),
        ],
      ),
    );
  }
}
