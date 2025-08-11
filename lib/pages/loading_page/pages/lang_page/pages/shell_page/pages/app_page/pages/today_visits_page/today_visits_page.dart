import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:allevia_one/core/api/_api_result.dart';
import 'package:allevia_one/extensions/loc_ext.dart';
import 'package:allevia_one/models/clinic/clinic.dart';
import 'package:allevia_one/models/visits/_visit.dart';
import 'package:allevia_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits_page/widgets/clinics_tab_bar.dart';
import 'package:allevia_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits_page/widgets/visit_view_card.dart';
import 'package:allevia_one/providers/px_clinics.dart';
import 'package:allevia_one/providers/px_locale.dart';
import 'package:allevia_one/providers/px_visits.dart';
import 'package:allevia_one/router/router.dart';
import 'package:allevia_one/widgets/central_error.dart';
import 'package:allevia_one/widgets/central_loading.dart';
import 'package:allevia_one/widgets/central_no_items.dart';
import 'package:allevia_one/widgets/floating_ax_menu_bubble.dart';
import 'package:provider/provider.dart';

class TodayVisitsPage extends StatefulWidget {
  const TodayVisitsPage({super.key});

  @override
  State<TodayVisitsPage> createState() => _TodayVisitsPageState();
}

class _TodayVisitsPageState extends State<TodayVisitsPage>
    with TickerProviderStateMixin {
  TabController? _tabController;

  late final AnimationController _animationController;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 260),
    );

    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<PxVisits, PxClinics, PxLocale>(
      builder: (context, v, c, l, _) {
        while (c.result == null) {
          return const CentralLoading();
        }
        while (c.result is ApiErrorResult) {
          return CentralError(
            code: (c.result as ApiErrorResult).errorCode,
            toExecute: c.retry,
          );
        }

        while ((c.result as ApiDataResult<List<Clinic>>).data.isEmpty) {
          return CentralNoItems(
            message: context.loc.noClinicsFound,
          );
        }

        final _clinics = (c.result as ApiDataResult<List<Clinic>>).data;

        _tabController = TabController(
          length: _clinics.length,
          vsync: this,
        );
        return Scaffold(
          body: Column(
            children: [
              Stack(
                children: [
                  ClinicsTabBar(
                    clinics: _clinics,
                    controller: _tabController!,
                  ),
                  if (v.isUpdating)
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: CupertinoActivityIndicator(),
                      ),
                    ),
                ],
              ),
              Expanded(
                child: Builder(
                  builder: (context) {
                    while (v.visits == null) {
                      return const CentralLoading();
                    }

                    while (v.visits is ApiErrorResult) {
                      return CentralError(
                        code:
                            (v.visits as ApiErrorResult<List<Visit>>).errorCode,
                        toExecute: v.retry,
                      );
                    }

                    while (v.visits != null &&
                        (v.visits is ApiDataResult) &&
                        (v.visits as ApiDataResult<List<Visit>>).data.isEmpty) {
                      return CentralNoItems(
                        message: context.loc.noVisitsFoundForToday,
                      );
                    }
                    final _items =
                        (v.visits as ApiDataResult<List<Visit>>).data;
                    return TabBarView(
                      controller: _tabController,
                      physics: BouncingScrollPhysics(),
                      children: [
                        ...(c.result as ApiDataResult<List<Clinic>>)
                            .data
                            .map((x) {
                          final _clinicItems =
                              _items.where((e) => e.clinic.id == x.id).toList();

                          while (_clinicItems.isEmpty) {
                            return CentralNoItems(
                                message: context.loc.noVisitsFoundForToday);
                          }

                          return ListView.builder(
                            itemCount: _clinicItems.length,
                            itemBuilder: (context, index) {
                              final _item = _clinicItems[index];
                              return VisitViewCard(
                                visit: _item,
                                index: index,
                              );
                            },
                          );
                        })
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionMenuBubble(
            animation: _animation,
            // On pressed change animation state
            onPress: () => _animationController.isCompleted
                ? _animationController.reverse()
                : _animationController.forward(),
            // Floating Action button Icon color
            iconColor: Colors.white,
            // Flaoting Action button Icon
            // iconData: Icons.settings,
            animatedIconData: AnimatedIcons.menu_arrow,
            backGroundColor: Colors.amber,
            items: [
              Bubble(
                title: context.loc.addNewVisit,
                iconColor: Colors.white,
                bubbleColor: Colors.amber,
                icon: Icons.add,
                titleStyle: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
                onPress: () async {
                  _animationController.reverse();
                  GoRouter.of(context).goNamed(
                    AppRouter.patients,
                    pathParameters: defaultPathParameters(context),
                  );
                },
              ),
              Bubble(
                title: context.loc.scanQrCode,
                iconColor: Colors.white,
                bubbleColor: Colors.amber,
                icon: Icons.qr_code,
                titleStyle: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
                onPress: () async {
                  _animationController.reverse();
                  //TODO: scan code
                  //TODO: get patient data
                  //TODO: open new visit dialog
                },
              ),
            ],
          ),
        );
      },
    );
  }
}


// FloatingActionButton.small(
//   heroTag: 'add-new-visit-nav',
//   tooltip: context.loc.addNewVisit,
//   onPressed: () {
//     GoRouter.of(context).goNamed(
//       AppRouter.patients,
//       pathParameters: defaultPathParameters(context),
//     );
//   },
//   child: const Icon(Icons.add),
// ),