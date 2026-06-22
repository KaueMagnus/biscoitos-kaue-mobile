import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final String? subtitle;

  const SectionTitle({super.key, required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.darkText,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(subtitle!, style: const TextStyle(color: AppTheme.supportGray)),
        ],
      ],
    );
  }
}
