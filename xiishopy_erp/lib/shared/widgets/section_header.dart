/// Xiishopy ERP - Section Header Widget
/// Consistent section heading with optional action.
library;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title,
          style: GoogleFonts.poppins(
            fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
        if (actionLabel != null && onAction != null) ...[
          const Spacer(),
          TextButton(
            onPressed: onAction,
            child: Text(actionLabel!,
              style: GoogleFonts.poppins(
                fontSize: 13, color: const Color(0xFF0F3460))),
          ),
        ],
      ],
    );
  }
}