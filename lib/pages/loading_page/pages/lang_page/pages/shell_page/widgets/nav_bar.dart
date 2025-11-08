import 'package:allevia_one/constants/app_business_constants.dart';
import 'package:allevia_one/extensions/loc_ext.dart';
import 'package:allevia_one/pages/loading_page/pages/lang_page/pages/shell_page/widgets/monthly_visits_calendar_dialog.dart';
import 'package:allevia_one/providers/px_notifications.dart';
import 'package:allevia_one/providers/px_whatsapp.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:allevia_one/assets/assets.dart';
import 'package:allevia_one/extensions/is_mobile_context.dart';
import 'package:allevia_one/providers/px_locale.dart';
import 'package:allevia_one/router/router.dart';
import 'package:popover/popover.dart';
import 'package:provider/provider.dart';

class Navbar extends StatelessWidget implements PreferredSizeWidget {
  const Navbar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return Consumer2<PxNotifications, PxLocale>(
      builder: (context, n, l, _) {
        return AppBar(
          automaticallyImplyLeading: false,
          title: InkWell(
            mouseCursor: context.isMobile ? null : SystemMouseCursors.click,
            onTap: context.isMobile
                ? null
                : () {
                    GoRouter.of(context).go("/${l.lang}/${AppRouter.app}");
                  },
            child: Row(
              children: [
                SizedBox(width: context.isMobile ? 10 : 50),
                Image.asset(
                  AppAssets.icon,
                  width: 40,
                  height: 40,
                ),
                const SizedBox(width: 20),
                const Text.rich(
                  TextSpan(
                    text: "Allevia-One",
                    children: [
                      TextSpan(
                        text: '\n',
                        style: TextStyle(
                          fontSize: 8,
                        ),
                      ),
                      TextSpan(
                        text: 'v${AppBusinessConstants.ALLEVIA_VERSION}',
                        style: TextStyle(
                          fontSize: 8,
                        ),
                      ),
                    ],
                  ),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton.outlined(
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
                                  transitionDuration:
                                      const Duration(milliseconds: 600),
                                  transitionBuilder: (context, animation,
                                      secondaryAnimation, child) {
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
                                  backgroundColor: Colors.amber.shade50,
                                  direction: l.isEnglish
                                      ? PopoverDirection.right
                                      : PopoverDirection.left,
                                  width: 150,
                                  height: 200,
                                  arrowHeight: 15,
                                  arrowWidth: 30,
                                  bodyBuilder: (context) {
                                    return ListView(
                                      children: [
                                        //TODO: add clinic calls + clinic calls dialog
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
                ),
                const SizedBox(width: 10),
              ],
            ),
          ),
          actions: [
            Builder(
              builder: (context) {
                return IconButton.outlined(
                  style: IconButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white),
                  ),
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                  icon: const Icon(Icons.menu),
                );
              },
            ),
            const SizedBox(width: 20),
          ],
        );
      },
    );
  }
}
