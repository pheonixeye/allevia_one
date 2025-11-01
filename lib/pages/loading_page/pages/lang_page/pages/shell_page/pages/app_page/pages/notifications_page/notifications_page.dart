import 'package:allevia_one/providers/px_locale.dart';
import 'package:allevia_one/providers/px_notifications.dart';
import 'package:allevia_one/widgets/central_loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer2<PxNotifications, PxLocale>(
        builder: (context, n, l, _) {
          while (n.stream.isEmpty) {
            return CentralLoading();
          }
          return ListView();
        },
      ),
    );
  }
}
