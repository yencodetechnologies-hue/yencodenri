import 'package:flutter/material.dart';
import '../../widgets/gradient_app_bar.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/status_badge.dart';
import '../../services/api_service.dart';

class AgreementListScreen extends StatefulWidget {
  const AgreementListScreen({super.key});
  @override
  State<AgreementListScreen> createState() => _AgreementListScreenState();
}

class _AgreementListScreenState extends State<AgreementListScreen> {
  final _api = ApiService();
  List<dynamic> _agreements = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final data = await _api.getAgreements();
      if (mounted) setState(() { _agreements = data; _loading = false; });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GradientAppBar(title: 'Rental Agreements'),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/agreements/create').then((_) => _load()),
        backgroundColor: const Color(0xFF02AFEF),
        child: const Icon(Icons.add),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _agreements.length,
              itemBuilder: (context, i) {
                final a = _agreements[i];
                return Card(
                  child: ListTile(
                    title: Text('₹${a['rentAmount']}/month'),
                    subtitle: Text('${a['propertyId']?['name'] ?? ''} • ${a['tenantId']?['name'] ?? ''}'),
                    trailing: StatusBadge(status: a['status'] ?? 'draft'),
                    onTap: () => Navigator.pushNamed(context, '/agreements/detail', arguments: a),
                  ),
                );
              },
            ),
    );
  }
}

class CreateAgreementScreen extends StatefulWidget {
  const CreateAgreementScreen({super.key});
  @override
  State<CreateAgreementScreen> createState() => _CreateAgreementScreenState();
}

class _CreateAgreementScreenState extends State<CreateAgreementScreen> {
  final _rentController = TextEditingController();
  final _depositController = TextEditingController();
  final _termsController = TextEditingController();
  String? _propertyId;
  String? _tenantId;
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 365));
  List<dynamic> _properties = [];
  List<dynamic> _tenants = [];
  bool _loading = false;
  final _api = ApiService();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final props = await _api.getProperties();
    final tenants = await _api.getTenants();
    if (mounted) setState(() { _properties = props; _tenants = tenants; });
  }

  Future<void> _submit() async {
    if (_propertyId == null || _tenantId == null) return;
    setState(() => _loading = true);
    try {
      await _api.createAgreement({
        'propertyId': _propertyId,
        'tenantId': _tenantId,
        'rentAmount': double.parse(_rentController.text),
        'securityDeposit': double.tryParse(_depositController.text) ?? 0,
        'startDate': _startDate.toIso8601String(),
        'endDate': _endDate.toIso8601String(),
        'terms': _termsController.text,
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
      appBar: const GradientAppBar(title: 'Create Agreement'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Property'),
              items: _properties.map((p) => DropdownMenuItem<String>(value: p['_id'].toString(), child: Text(p['name'].toString()))).toList(),
              onChanged: (v) => setState(() => _propertyId = v),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Tenant'),
              items: _tenants.map((t) => DropdownMenuItem<String>(value: t['_id'].toString(), child: Text(t['name'].toString()))).toList(),
              onChanged: (v) => setState(() => _tenantId = v),
            ),
            const SizedBox(height: 12),
            TextField(controller: _rentController, decoration: const InputDecoration(labelText: 'Rent Amount'), keyboardType: TextInputType.number),
            const SizedBox(height: 12),
            TextField(controller: _depositController, decoration: const InputDecoration(labelText: 'Security Deposit'), keyboardType: TextInputType.number),
            const SizedBox(height: 12),
            TextField(controller: _termsController, decoration: const InputDecoration(labelText: 'Terms & Conditions'), maxLines: 4),
            const SizedBox(height: 24),
            GradientButton(label: 'Create Agreement', onPressed: _submit, isLoading: _loading),
          ],
        ),
      ),
    );
  }
}

class AgreementDetailScreen extends StatefulWidget {
  const AgreementDetailScreen({super.key});
  @override
  State<AgreementDetailScreen> createState() => _AgreementDetailScreenState();
}

class _AgreementDetailScreenState extends State<AgreementDetailScreen> {
  final _api = ApiService();
  bool _loading = false;

  Future<void> _generatePdf(Map<String, dynamic> agreement) async {
    setState(() => _loading = true);
    try {
      await _api.generateAgreementPdf(agreement['_id']);
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('PDF generated')));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _eSign(Map<String, dynamic> agreement) async {
    await _api.eSignAgreement(agreement['_id']);
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('E-Sign completed')));
  }

  @override
  Widget build(BuildContext context) {
    final agreement = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return Scaffold(
      appBar: const GradientAppBar(title: 'Agreement Details'),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Rent: ₹${agreement['rentAmount']}/month', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('Deposit: ₹${agreement['securityDeposit']}'),
                    Text('E-Sign: ${agreement['eSignStatus']}'),
                    if (agreement['pdfUrl'] != null && agreement['pdfUrl'].toString().isNotEmpty)
                      Text('PDF: ${agreement['pdfUrl']}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            GradientButton(label: 'Generate Agreement PDF', onPressed: () => _generatePdf(agreement), isLoading: _loading),
            const SizedBox(height: 12),
            GradientButton(label: 'E-Sign', onPressed: () => _eSign(agreement)),
          ],
        ),
      ),
    );
  }
}
