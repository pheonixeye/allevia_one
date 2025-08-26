import 'package:allevia_one/core/api/patient_previous_visits_api.dart';
import 'package:allevia_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits_page/pages/visit_data_page/widgets/detailed_previous_patient_visits_dialog.dart';
import 'package:allevia_one/providers/px_patient_previous_visits.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:allevia_one/core/api/_api_result.dart';
import 'package:allevia_one/extensions/loc_ext.dart';
import 'package:allevia_one/models/patient.dart';
import 'package:allevia_one/models/visit_data/visit_data.dart';
import 'package:allevia_one/providers/px_visit_data.dart';
import 'package:allevia_one/router/router.dart';
import 'package:provider/provider.dart';

class VisitDetailsPageInfoHeader extends StatelessWidget {
  const VisitDetailsPageInfoHeader({
    super.key,
    required this.patient,
    required this.title,
    required this.iconData,
    this.actionButton,
  });
  final Patient patient;
  final String title;
  final IconData iconData;
  final Widget? actionButton;

  @override
  Widget build(BuildContext context) {
    return Consumer<PxVisitData>(
      builder: (context, v, _) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: CircleAvatar(
              child: Icon(iconData),
            ),
            title: Row(
              children: [
                Flexible(
                  child: Text(
                    patient.name,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: FloatingActionButton.small(
                    tooltip: context.loc.previousPatientVisits,
                    heroTag: UniqueKey(),
                    onPressed: () async {
                      //todo: show previous patient visits
                      await showDialog(
                        context: context,
                        builder: (context) {
                          return ChangeNotifierProvider(
                            create: (context) => PxPatientPreviousVisits(
                              api: PatientPreviousVisitsApi(
                                patient_id: patient.id,
                              ),
                            ),
                            child: DetailedPreviousPatientVisitsDialog(),
                          );
                        },
                      );
                    },
                    child: const Icon(FontAwesomeIcons.personWalkingArrowRight),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: FloatingActionButton.small(
                    tooltip: context.loc.patientDocuments,
                    heroTag: UniqueKey(),
                    onPressed: () {
                      //TODO: show previous patient Documents
                    },
                    child: const Icon(Icons.document_scanner),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: FloatingActionButton.small(
                    tooltip: context.loc.visitPrescription,
                    heroTag: UniqueKey(),
                    onPressed: () {
                      //todo: go to prescription page
                      GoRouter.of(context).goNamed(
                        AppRouter.visit_prescription,
                        pathParameters: defaultPathParameters(context)
                          ..addAll({
                            'visit_id': (v.result as ApiDataResult<VisitData>)
                                .data
                                .visit_id,
                          }),
                      );
                    },
                    child: const Icon(FontAwesomeIcons.prescription),
                  ),
                ),
              ],
            ),
            subtitle: Text(title),
            trailing: actionButton,
          ),
        );
      },
    );
  }
}
