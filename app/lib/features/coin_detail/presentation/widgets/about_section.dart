import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/utils/formatters.dart';
import '../../data/models/coin_detail.dart';

class AboutSection extends StatefulWidget {
  const AboutSection({super.key, required this.detail});
  final CoinDetail detail;

  @override
  State<AboutSection> createState() => _AboutSectionState();
}

class _AboutSectionState extends State<AboutSection> {
  bool _expanded = false;

  Future<void> _open(String url) async {
    var ok = false;
    try {
      ok = await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      );
    } catch (_) {}
    if (!ok && mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Could not open link')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.detail;
    final tt = Theme.of(context).textTheme;
    final text = Fmt.stripHtml(d.description);
    final homepage = d.homepage;
    final cats = d.categories.take(6).toList();
    final hasLink = homepage != null && homepage.isNotEmpty;

    if (text.isEmpty && !hasLink && cats.isEmpty) {
      return const SizedBox.shrink();
    }
    final isLong = text.length > 240;
    final collapsed = isLong && !_expanded;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('About ${d.name}',
            style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        if (text.isNotEmpty) ...[
          Text(
            text,
            maxLines: collapsed ? 5 : null,
            overflow: collapsed ? TextOverflow.ellipsis : TextOverflow.clip,
            style: tt.bodyMedium?.copyWith(height: 1.5),
          ),
          if (isLong)
            TextButton(
              onPressed: () => setState(() => _expanded = !_expanded),
              child: Text(_expanded ? 'Show less' : 'Read more'),
            ),
        ],
        if (cats.isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final c in cats)
                Chip(
                  label: Text(c),
                  visualDensity: VisualDensity.compact,
                ),
            ],
          ),
        ],
        if (hasLink) ...[
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => _open(homepage),
            icon: const Icon(Icons.open_in_new, size: 18),
            label: const Text('Website'),
          ),
        ],
      ],
    );
  }
}