import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class CoinIcon extends StatelessWidget {
  const CoinIcon({
    super.key,
    required this.url,
    required this.symbol,
    this.size = 36,
  });

  final String? url;
  final String symbol;
  final double size;

  @override
  Widget build(BuildContext context) {
    final fallback = CircleAvatar(
      radius: size / 2,
      backgroundColor: context.appColors.border,
      child: Text(
        symbol.isEmpty ? '?' : symbol[0].toUpperCase(),
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
    );
    final u = url;
    if (u == null || u.isEmpty) return fallback;
    return ClipOval(
      child: CachedNetworkImage(
        imageUrl: u,
        width: size,
        height: size,
        fit: BoxFit.cover,
        placeholder: (context, url) => fallback,
        errorWidget: (context, url, error) => fallback,
      ),
    );
  }
}