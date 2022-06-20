import 'package:animesan/models/mixins.dart';
import 'package:flutter/material.dart';

class NotificationTabConfig extends StatelessWidget with TabConfig {
  const NotificationTabConfig({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [],
    );
  }

  @override
  String get tabTitle => "Notificações";

  @override
  IconData get tabIcon => Icons.circle_notifications_rounded;
}
