import 'package:allevia_one/extensions/loc_ext.dart';
import 'package:allevia_one/extensions/visit_ext.dart';
import 'package:allevia_one/functions/shell_function.dart';
import 'package:allevia_one/models/app_constants/app_permission.dart';
import 'package:allevia_one/models/clinic/schedule_shift.dart';
import 'package:allevia_one/models/shift.dart';
import 'package:allevia_one/models/visits/_visit.dart';
import 'package:allevia_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits_page/widgets/visit_view_card/reschedule_visit_dialog.dart';
import 'package:allevia_one/providers/px_auth.dart';
import 'package:allevia_one/providers/px_visits.dart';
import 'package:allevia_one/providers/px_visits_per_clinic_shift.dart';
import 'package:allevia_one/widgets/not_permitted_dialog.dart';
import 'package:allevia_one/widgets/snackbar_.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VisitShiftRow extends StatelessWidget {
  const VisitShiftRow({super.key, required this.visit});
  final Visit visit;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: const Icon(Icons.more_time_rounded),
        ),
        Expanded(
          flex: 3,
          child: ElevatedButton(
            onPressed: () async {
              //@permission
              final _perm = context.read<PxAuth>().isActionPermitted(
                    PermissionEnum.User_TodayVisits_Reschedule_Visit,
                    context,
                  );
              if (!_perm.isAllowed) {
                await showDialog(
                  context: context,
                  builder: (context) {
                    return NotPermittedDialog(
                      permission: _perm.permission,
                    );
                  },
                );
                return;
              }
              final _shift = await showDialog<ScheduleShift?>(
                context: context,
                builder: (context) {
                  return ChangeNotifierProvider(
                    create: (context) => PxVisitsPerClinicShift(
                      visit_date: visit.visit_date,
                      clinic_id: visit.clinic.id,
                    ),
                    child: RescheduleVisitDialog(
                      visit: visit,
                    ),
                  );
                },
              );
              if (_shift == null) {
                return;
              }
              final _clinicSchedule = visit.clinic.clinic_schedule.firstWhere(
                (sch) => sch.intday == visit.visitSchedule.intday,
              );

              if (visit.visitSchedule.isInSameShift(_clinicSchedule, _shift)) {
                if (context.mounted) {
                  showIsnackbar(context.loc.sameShiftSelected);
                }
                return;
              }

              if (context.mounted) {
                await shellFunction(
                  context,
                  toExecute: () async {
                    //todo
                    await context.read<PxVisits>().updateVisitScheduleShift(
                          visit_shift_id: visit.visitSchedule.id,
                          shift: Shift.fromScheduleShift(_shift),
                        );
                  },
                );
              }
            },
            child: Text(visit.formattedShift(context)),
          ),
        ),
        const Spacer(),
      ],
    );
  }
}
