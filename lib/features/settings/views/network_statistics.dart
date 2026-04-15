import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mysterium_vpn/core/extensions/date.dart';
import 'package:mysterium_vpn/core/styles/style.dart';
import 'package:mysterium_vpn/features/vpn/store/network_statistics_store.dart';
import 'package:mysterium_vpn/service_locator.dart';

class NetworkStatistics extends StatelessWidget {
  const NetworkStatistics({super.key});

  @override
  Widget build(BuildContext context) {
    final store = getIt<NetworkStatisticsStore>();
    return Observer(
      builder: (context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
        decoration: BoxDecoration(
          color: context.c.isDarkMode ? Palette.darkIndigo : Palette.grayContainer,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Network Statistics', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            Wrap(
              runSpacing: 8,
              spacing: 8,
              children: [
                _StatisticsItem(
                  title: 'Total Downloaded MB',
                  value: store.totalDownloadInMB.toStringAsFixed(2),
                ),
                _StatisticsItem(
                  title: 'Total Uploaded MB',
                  value: store.totalUploadInMB.toStringAsFixed(2),
                ),
                _StatisticsItem(
                  title: 'Download Mbps',
                  value: store.downloadSpeed.toStringAsFixed(2),
                ),
                _StatisticsItem(title: 'Upload Mbps', value: store.uploadSpeed.toStringAsFixed(2)),
                _StatisticsItem(
                  title: 'Latest Handshake',
                  value: store.latestHandshake?.formatWithTime() ?? 'N/A',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatisticsItem extends StatelessWidget {
  const _StatisticsItem({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
      const SizedBox(height: 5),
      Text(
        value,
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(color: Palette.purple, fontWeight: FontWeight.w700),
      ),
    ],
  );
}
