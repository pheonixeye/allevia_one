import 'package:allevia_one/core/api/_api_result.dart';
import 'package:allevia_one/extensions/loc_ext.dart';
import 'package:allevia_one/functions/shell_function.dart';
import 'package:allevia_one/models/notifications/saved_notification.dart';
import 'package:allevia_one/providers/px_auth.dart';
import 'package:allevia_one/providers/px_locale.dart';
import 'package:allevia_one/providers/px_notifications.dart';
import 'package:allevia_one/widgets/central_error.dart';
import 'package:allevia_one/widgets/central_loading.dart';
import 'package:allevia_one/widgets/central_no_items.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  late final ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer2<PxNotifications, PxLocale>(
        builder: (context, n, l, _) {
          while (n.notifications == null) {
            return CentralLoading();
          }
          while (n.notifications is ApiErrorResult) {
            return CentralError(
              code: (n.notifications as ApiErrorResult).errorCode,
              toExecute: n.retry,
            );
          }
          while (n.notifications != null &&
              (n.notifications is ApiDataResult) &&
              (n.notifications as ApiDataResult<List<SavedNotification>>)
                  .data
                  .isEmpty) {
            return CentralNoItems(
              message: context.loc.noItemsFound,
            );
          }
          final _items =
              (n.notifications as ApiDataResult<List<SavedNotification>>).data;
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _controller,
                  itemCount: _items.length,
                  itemBuilder: (context, index) {
                    final _item = _items[index];
                    final _isNotificationRead = _item.read_by
                        .map((e) => e.id)
                        .toList()
                        .contains(PxAuth.doc_id_static_getter);
                    return Card.filled(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(0),
                      ),
                      elevation: _isNotificationRead ? 0 : 6,
                      color: _isNotificationRead
                          ? Colors.white
                          : _item.notification_topic.tileColor,
                      child: InkWell(
                        onTap: _isNotificationRead
                            ? null
                            : () async {
                                await shellFunction(
                                  context,
                                  toExecute: () async {
                                    await n.readNotification(
                                      _item.id,
                                      PxAuth.doc_id_static_getter,
                                    );
                                  },
                                );
                              },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            spacing: 4,
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (_item.title.isNotEmpty) Text(_item.title),
                              if (_item.message.isNotEmpty) Text(_item.message)
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton.outlined(
                      tooltip: context.loc.previous,
                      onPressed: () async {
                        await shellFunction(
                          context,
                          toExecute: () async {
                            await n.previousPage();
                          },
                          duration: const Duration(milliseconds: 100),
                        );
                        _controller.animateTo(
                          0,
                          duration: const Duration(milliseconds: 100),
                          curve: Curves.easeIn,
                        );
                      },
                      icon: const Icon(Icons.arrow_back),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('- ${n.page} -'),
                    ),
                    IconButton.outlined(
                      tooltip: context.loc.next,
                      onPressed: () async {
                        await shellFunction(
                          context,
                          toExecute: () async {
                            await n.nextPage();
                          },
                          duration: const Duration(milliseconds: 100),
                        );
                        _controller.animateTo(
                          0,
                          duration: const Duration(milliseconds: 100),
                          curve: Curves.easeIn,
                        );
                      },
                      icon: const Icon(Icons.arrow_forward),
                    ),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
