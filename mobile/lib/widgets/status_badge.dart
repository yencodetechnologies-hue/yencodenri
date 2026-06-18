import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({super.key, required this.status});

  Color get _color {
    switch (status.toLowerCase()) {
      case 'verified':
      case 'approved':
      case 'paid':
      case 'completed':
      case 'active':
        return const Color(0xFF10B981);
      case 'pending':
      case 'open':
      case 'draft':
      case 'requested':
        return const Color(0xFFF59E0B);
      case 'rejected':
      case 'failed':
      case 'cancelled':
        return const Color(0xFFEF4444);
      case 'under_review':
      case 'assigned':
      case 'in_progress':
        return const Color(0xFF02AFEF);
      default:
        return const Color(0xFF6B7280);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.replaceAll('_', ' ').toUpperCase(),
        style: TextStyle(color: _color, fontSize: 11, fontWeight: FontWeight.w600),
      ),
    );
  }
}
