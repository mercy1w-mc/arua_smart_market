import 'package:flutter/material.dart';

import '../../app/theme.dart';

class BrandMark extends StatelessWidget {
  const BrandMark({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: compact ? 38 : 46,
          height: compact ? 38 : 46,
          decoration: BoxDecoration(
            color: AppColors.forest,
            borderRadius: BorderRadius.circular(compact ? 12 : 15),
          ),
          child: Icon(
            Icons.eco_rounded,
            color: Colors.white,
            size: compact ? 22 : 27,
          ),
        ),
        if (!compact) ...[
          const SizedBox(width: 12),
          const Text(
            'ARUA\nSMART MARKET',
            style: TextStyle(
              height: .95,
              color: AppColors.ink,
              fontSize: 15,
              fontWeight: FontWeight.w900,
              letterSpacing: .6,
            ),
          ),
        ],
      ],
    );
  }
}