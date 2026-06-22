import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({super.key, required this.status});

  Color get _backgroundColor {
    switch (status.toUpperCase()) {
      case 'ENVIADO':
        return AppTheme.successGreen;
      case 'CANCELADO':
        return AppTheme.cancelRed;
      case 'PENDENTE':
        return AppTheme.gold;
      default:
        return AppTheme.supportGray;
    }
  }

  Color get _textColor {
    if (status.toUpperCase() == 'PENDENTE') {
      return AppTheme.darkText;
    }

    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: _textColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
