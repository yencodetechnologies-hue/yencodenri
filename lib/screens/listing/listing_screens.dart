import 'package:flutter/material.dart';
import '../../widgets/gradient_app_bar.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/status_badge.dart';
import '../../services/api_service.dart';

class BuySearchScreen extends StatefulWidget {
  const BuySearchScreen({super.key});
  @override
  State<BuySearchScreen> createState() => _BuySearchScreenState();
}

class _BuySearchScreenState extends State<BuySearchScreen> {
  final _locationController = TextEditingController();
  final _api = ApiService();
  List<dynamic> _listings = [];
  bool _loading = false;

  Future<void> _search() async {
    setState(() => _loading = true);
    try {
      final data = await _api.searchBuyListings(location: _locationController.text);
      if (mounted) setState(() { _listings = data; _loading = false; });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GradientAppBar(title: 'Buy Property'),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(child: TextField(controller: _locationController, decoration: const InputDecoration(labelText: 'Filter by Location', isDense: true))),
                const SizedBox(width: 8),
                ElevatedButton(onPressed: _search, child: const Text('Search')),
              ],
            ),
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _listings.length,
                    itemBuilder: (context, i) {
                      final l = _listings[i];
                      return Card(
                        child: ListTile(
                          title: Text(l['title'] ?? ''),
                          subtitle: Text('${l['location']} • ₹${l['price']}'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => _showDetail(l),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showDetail(Map<String, dynamic> listing) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(listing['title'] ?? '', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text('₹${listing['price']}'),
            Text(listing['description'] ?? ''),
            const SizedBox(height: 16),
            GradientButton(label: 'Contact Broker', onPressed: () => Navigator.pop(ctx)),
            const SizedBox(height: 8),
            GradientButton(label: 'Schedule Site Visit', onPressed: () => Navigator.pop(ctx)),
          ],
        ),
      ),
    );
  }
}

class SellListingScreen extends StatefulWidget {
  const SellListingScreen({super.key});
  @override
  State<SellListingScreen> createState() => _SellListingScreenState();
}

class _SellListingScreenState extends State<SellListingScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _locationController = TextEditingController();
  final _priceController = TextEditingController();
  final _contactController = TextEditingController();
  bool _loading = false;
  final _api = ApiService();
  List<dynamic> _myListings = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final data = await _api.getMyListings();
      if (mounted) setState(() => _myListings = data);
    } catch (_) {}
  }

  Future<void> _submit() async {
    setState(() => _loading = true);
    try {
      await _api.createListing({
        'type': 'sell',
        'title': _titleController.text,
        'description': _descController.text,
        'location': _locationController.text,
        'price': double.parse(_priceController.text),
        'contactMobile': _contactController.text,
      });
      _load();
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Listing created')));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GradientAppBar(title: 'Sell Property'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(controller: _titleController, decoration: const InputDecoration(labelText: 'Property Title')),
            const SizedBox(height: 12),
            TextField(controller: _descController, decoration: const InputDecoration(labelText: 'Description'), maxLines: 3),
            const SizedBox(height: 12),
            TextField(controller: _locationController, decoration: const InputDecoration(labelText: 'Location')),
            const SizedBox(height: 12),
            TextField(controller: _priceController, decoration: const InputDecoration(labelText: 'Expected Price'), keyboardType: TextInputType.number),
            const SizedBox(height: 12),
            TextField(controller: _contactController, decoration: const InputDecoration(labelText: 'Contact Mobile')),
            const SizedBox(height: 24),
            GradientButton(label: 'Create Listing', onPressed: _submit, isLoading: _loading),
            const SizedBox(height: 24),
            const Text('My Listings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ..._myListings.map((l) => ListTile(
                  title: Text(l['title'] ?? ''),
                  subtitle: Text('₹${l['price']}'),
                  trailing: StatusBadge(status: l['status'] ?? 'pending'),
                )),
          ],
        ),
      ),
    );
  }
}
