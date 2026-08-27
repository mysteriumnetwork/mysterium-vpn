import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/views/subscription/subscription_pause_view.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

Future<void> showSubscriptionPauseDialog(BuildContext context) async =>
    showModal(context, builder: (ctx) => const ModalMessengerScope(child: SubscriptionPauseView()));
