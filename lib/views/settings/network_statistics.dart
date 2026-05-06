import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/extensions/date.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart' hide Radius;

class NetworkStatistics extends ConsumerWidget {
  const NetworkStatistics({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final store = ref.watch(networkStatisticsStorePOD);
    return Observer(
      builder: (context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
        decoration: BoxDecoration(
          color: Palette.of(context).bgSecondary,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Network Statistics', style: Theme.of(context).textStyles.textMd.bold),
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
        ).textStyles.textMd.bold.copyWith(color: Palette.of(context).textBrandPrimary),
      ),
    ],
  );
}
