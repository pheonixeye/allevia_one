import 'package:allevia_one/extensions/is_mobile_context.dart';
import 'package:allevia_one/extensions/loc_ext.dart';
import 'package:allevia_one/extensions/number_translator.dart';
import 'package:allevia_one/functions/shell_function.dart';
import 'package:allevia_one/models/notifications/notification_request.dart';
import 'package:allevia_one/pages/loading_page/pages/lang_page/pages/shell_page/widgets/add_new_notification_request_dialog.dart';
import 'package:allevia_one/pages/loading_page/pages/lang_page/pages/shell_page/widgets/monthly_visits_calendar_dialog.dart';
import 'package:allevia_one/providers/px_locale.dart';
import 'package:allevia_one/providers/px_notifications.dart';
import 'package:allevia_one/providers/px_whatsapp.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:popover/popover.dart';
import 'package:provider/provider.dart';

class NavBarMenuBtn extends StatelessWidget {
  const NavBarMenuBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<PxNotifications, PxLocale>(
      builder: (context, n, l, _) {
        return IconButton.outlined(
          style: IconButton.styleFrom(
            foregroundColor: Colors.white,
            side: const BorderSide(color: Colors.white),
          ),
          onPressed: () {
            showPopover(
              context: context,
              // onPop: () => print('Popover was popped!'),
              direction: PopoverDirection.bottom,
              backgroundColor: Colors.blue.shade50,
              width: 200,
              height: 200,
              arrowHeight: 15,
              arrowWidth: 30,
              bodyBuilder: (context) {
                return ListView(
                  padding: const EdgeInsets.all(8),
                  children: [
                    Consumer<PxWhatsapp>(
                      builder: (context, w, _) {
                        while (w.serverResult == null) {
                          return const SizedBox(
                            width: 30,
                            height: 8,
                            child: LinearProgressIndicator(),
                          );
                        }
                        return ListTile(
                          titleAlignment: ListTileTitleAlignment.top,
                          leading: Icon(
                            w.isConnectedToServer
                                ? FontAwesomeIcons.whatsapp
                                : Icons.wifi_off_rounded,
                            color: w.isConnectedToServer
                                ? Colors.green
                                : Colors.red,
                          ),
                          title: Text(context.loc.whatsappSettings),
                          subtitle: Row(
                            spacing: 4,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(w.isConnectedToServer
                                  ? '${context.loc.conntectedToWhatsappServer} \n ${w.hasConnectedDevices ? w.connectedDevices?.results?.map((e) => '${e.device}\n').toList() : context.loc.noConnectedDevices}'
                                  : '${context.loc.notConntectedToWhatsappServer} \n ${context.loc.noConnectedDevices}'),
                            ],
                          ),
                        );
                      },
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.calendar_month),
                      title: Text(context.loc.visitsCalender),
                      titleAlignment: ListTileTitleAlignment.top,
                      onTap: () async {
                        await showGeneralDialog<void>(
                          context: context,
                          pageBuilder: (context, a1, a2) {
                            return MonthlyVisitsCalendarDialog();
                          },
                          anchorPoint: Offset(100, 100),
                          transitionDuration: const Duration(milliseconds: 600),
                          transitionBuilder:
                              (context, animation, secondaryAnimation, child) {
                            return ScaleTransition(
                              alignment: Alignment.topLeft,
                              scale: animation,
                              child: child,
                            );
                          },
                        );
                      },
                    ),
                    const Divider(),
                    ListTile(
                      titleAlignment: ListTileTitleAlignment.top,
                      leading: const Icon(Icons.notification_add),
                      title: Text(context.loc.notifications),
                      onTap: () {
                        showPopover(
                          context: context,
                          backgroundColor: Colors.blue.shade50,
                          direction: l.isEnglish
                              ? PopoverDirection.right
                              : PopoverDirection.left,
                          width: context.isMobile ? 150 : 300,
                          height: 200,
                          arrowHeight: 15,
                          arrowWidth: 30,
                          bodyBuilder: (context) {
                            return ListView(
                              children: [
                                //todo: add clinic calls + clinic calls dialog
                                ListTile(
                                  leading: const Icon(Icons.add),
                                  title: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      context.loc.addNewNotification,
                                    ),
                                  ),
                                  onTap: () async {
                                    final _notificationRequest =
                                        await showDialog<NotificationRequest?>(
                                      context: context,
                                      builder: (context) {
                                        return const AddNewNotificationRequestDialog();
                                      },
                                    );
                                    if (_notificationRequest == null) {
                                      return;
                                    }
                                    if (context.mounted) {
                                      await shellFunction(
                                        context,
                                        toExecute: () async {
                                          await n.saveFavoriteNotification(
                                            _notificationRequest,
                                          );
                                        },
                                      );
                                    }
                                  },
                                ),
                                const Divider(),
                                Builder(
                                  builder: (context) {
                                    while (n.favoriteNotifications == null) {
                                      return const SizedBox(
                                        width: 100,
                                        height: 8,
                                        child: LinearProgressIndicator(),
                                      );
                                    }

                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ...n.favoriteNotifications!.map((fav) {
                                          final _index = n
                                              .favoriteNotifications!
                                              .indexOf(fav);
                                          return Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: ListTile(
                                              title: Row(
                                                children: [
                                                  Text('(${_index + 1})'
                                                      .toArabicNumber(context)),
                                                  Text(fav.title ?? ''),
                                                ],
                                              ),
                                              subtitle: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(fav.message ?? ''),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: const Divider(),
                                                  ),
                                                ],
                                              ),
                                              onTap: () async {
                                                await shellFunction(
                                                  context,
                                                  toExecute: () async {
                                                    await n.sendNotification(
                                                      topic: fav.topic,
                                                      request: fav,
                                                    );
                                                  },
                                                );
                                              },
                                            ),
                                          );
                                        })
                                      ],
                                    );
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                );
              },
            );
          },
          icon: const Icon(Icons.notification_add),
        );
      },
    );
  }
}
