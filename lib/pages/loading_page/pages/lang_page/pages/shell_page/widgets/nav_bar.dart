import 'package:allevia_one/constants/app_business_constants.dart';
import 'package:allevia_one/extensions/loc_ext.dart';
import 'package:allevia_one/pages/loading_page/pages/lang_page/pages/shell_page/widgets/monthly_visits_calendar_dialog.dart';
import 'package:allevia_one/providers/px_whatsapp.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:allevia_one/assets/assets.dart';
import 'package:allevia_one/extensions/is_mobile_context.dart';
import 'package:allevia_one/extensions/switch_lang.dart';
import 'package:allevia_one/providers/px_locale.dart';
import 'package:allevia_one/router/router.dart';
import 'package:provider/provider.dart';

class Navbar extends StatelessWidget implements PreferredSizeWidget {
  const Navbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PxLocale>(
      builder: (context, l, _) {
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
                Consumer<PxWhatsapp>(
                  builder: (context, w, _) {
                    while (w.serverResult == null) {
                      return const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(),
                      );
                    }
                    return IconButton.outlined(
                      tooltip: w.isConnectedToServer
                          ? '${context.loc.conntectedToWhatsappServer} \n ${w.hasConnectedDevices ? w.connectedDevices?.results?.map((e) => '${e.device}\n').toList() : context.loc.noConnectedDevices}'
                          : '${context.loc.notConntectedToWhatsappServer} \n ${context.loc.noConnectedDevices}',
                      style: IconButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white),
                      ),
                      onPressed: null,
                      icon: Icon(
                        w.isConnectedToServer
                            ? FontAwesomeIcons.whatsapp
                            : Icons.wifi_off_rounded,
                        color:
                            w.isConnectedToServer ? Colors.green : Colors.red,
                      ),
                    );
                  },
                ),
                const SizedBox(width: 20),
                IconButton.outlined(
                  tooltip: context.loc.visitsCalender,
                  style: IconButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white),
                  ),
                  onPressed: () async {
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
                  icon: const Icon(Icons.calendar_month),
                ),
                const SizedBox(width: 10),
              ],
            ),
          ),
          actions: context.isMobile
              ? [
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
                ]
              : [
                  const VerticalDivider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Consumer<PxLocale>(
                      builder: (context, l, _) {
                        return TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            context.switchLanguage();
                          },
                          child: Text(l.lang == "en" ? "عربي" : "English"),
                        );
                      },
                    ),
                  ),
                  const VerticalDivider(),
                  const SizedBox(width: 100),
                ],
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
