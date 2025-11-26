import 'package:allevia_one/constants/app_business_constants.dart';
import 'package:allevia_one/pages/loading_page/pages/lang_page/pages/shell_page/widgets/nav_bar_menu_btn.dart';
import 'package:allevia_one/providers/px_notifications.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:allevia_one/assets/assets.dart';
import 'package:allevia_one/extensions/is_mobile_context.dart';
import 'package:allevia_one/providers/px_locale.dart';
import 'package:allevia_one/router/router.dart';
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
                    text: String.fromEnvironment('APPLICATION_NAME'),
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
                const NavBarMenuBtn(),
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
              : [],
        );
      },
    );
  }
}
