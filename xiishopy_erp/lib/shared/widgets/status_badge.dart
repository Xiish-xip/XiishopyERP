/// Xiishopy ERP - Status Badge Widget
/// Colored badge for displaying order/shipment/payment status.
library;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StatusBadge extends StatelessWidget {
  final String label;
  final StatusBadgeType type;

  const StatusBadge({
    super.key,
    required this.label,
    this.type = StatusBadgeType.default_,
  });

  @override
  Widget build(BuildContext context) {
    final color = _getColor();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(label,
        style: GoogleFonts.poppins(
          fontSize: 11, color: color, fontWeight: FontWeight.w600)),
    );
  }

  Color _getColor() {
    switch (type) {
      case StatusBadgeType.success:
        return Colors.green;
      case StatusBadgeType.warning:
        return Colors.orange;
      case StatusBadgeType.error:
        return Colors.red;
      case StatusBadgeType.info:
        return Colors.blue;
      case StatusBadgeType.pending:
        return Colors.yellow;
      case StatusBadgeType.default_:
        return Colors.grey;
    }
  }
}

enum StatusBadgeType { success, warning, error, info, pending, default_ }