import 'package:flutter/material.dart';
import '../../widgets/gradient_app_bar.dart';
import '../../widgets/status_badge.dart';

class PropertyDetailScreen extends StatelessWidget {
  const PropertyDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final property = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      appBar: const GradientAppBar(title: 'Property Details'),
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
                      Text(property['name'] ?? '', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      StatusBadge(status: property['verificationStatus'] ?? 'pending'),
                    ],
                  ),
                  const Divider(),
                  _DetailRow('Holder', property['holderName']),
                  _DetailRow('Type', property['propertyType']),
                  _DetailRow('Address', property['address']),
                  _DetailRow('Contact', property['contactPerson']),
                  _DetailRow('Email', property['email']),
                  _DetailRow('Local Contact', property['localContact']),
                  _DetailRow('Relationship', property['relationship']),
                ],
              ),
            ),
          ),
          if (property['documents'] != null && (property['documents'] as List).isNotEmpty) ...[
            const SizedBox(height: 16),
            const Text('Legal Documents', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ...(property['documents'] as List).map((d) => ListTile(
                  leading: const Icon(Icons.description),
                  title: Text(d['type'] ?? 'Document'),
                  subtitle: Text(d['filename'] ?? ''),
                )),
          ],
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String? value;
  const _DetailRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    if (value == null || value!.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 120, child: Text(label, style: const TextStyle(fontWeight: FontWeight.w500))),
          Expanded(child: Text(value!)),
        ],
      ),
    );
  }
}
