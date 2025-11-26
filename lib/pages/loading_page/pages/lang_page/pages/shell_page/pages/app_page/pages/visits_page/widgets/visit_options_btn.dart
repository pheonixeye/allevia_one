import 'package:allevia_one/core/api/bookkeeping_api.dart';
import 'package:allevia_one/core/api/patient_document_api.dart';
import 'package:allevia_one/core/api/visit_data_api.dart';
import 'package:allevia_one/extensions/loc_ext.dart';
import 'package:allevia_one/models/app_constants/app_permission.dart';
import 'package:allevia_one/models/visits/_visit.dart';
import 'package:allevia_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/visits_page/widgets/reciept_prepare_dialog.dart';
import 'package:allevia_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/visits_page/widgets/visit_data_view_dialog.dart';
import 'package:allevia_one/providers/px_app_constants.dart';
import 'package:allevia_one/providers/px_auth.dart';
import 'package:allevia_one/providers/px_one_visit_bookkeeping.dart';
import 'package:allevia_one/providers/px_patient_documents.dart';
import 'package:allevia_one/providers/px_visit_data.dart';
import 'package:allevia_one/router/router.dart';
import 'package:allevia_one/widgets/not_permitted_dialog.dart';
import 'package:allevia_one/widgets/snackbar_.dart';
import 'package:allevia_one/widgets/themed_popupmenu_btn.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class VisitOptionsBtn extends StatelessWidget {
  const VisitOptionsBtn({super.key, required this.x});
  final Visit x;

  @override
  Widget build(BuildContext context) {
    return Consumer<PxAppConstants>(
      builder: (context, a, _) {
        while (a.constants == null) {
          return const Center(
            child: LinearProgressIndicator(),
          );
        }
        return Center(
          child: Row(
            children: [
              InkWell(
                hoverColor: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(12),
                onTap: () async {
                  //todo: Go to visit Data View Dialog
                  await showDialog<void>(
                    context: context,
                    builder: (context) {
                      return ChangeNotifierProvider(
                        create: (context) => PxVisitData(
                          api: VisitDataApi(
                            visit_id: x.id,
                          ),
                        ),
                        child: VisitDataViewDialog(
                          visit: x,
                        ),
                      );
                    },
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(x.patient.name),
                ),
              ),
              const Spacer(),
              ThemedPopupmenuBtn<void>(
                icon: const Icon(Icons.menu),
                tooltip: context.loc.settings,
                itemBuilder: (context) {
                  return [
                    PopupMenuItem<void>(
                      child: Row(
                        children: [
                          const Icon(Icons.receipt_long),
                          SizedBox(width: 4),
                          Text(context.loc.printReciept),
                        ],
                      ),
                      onTap: () async {
                        //@permission
                        final _perm = context.read<PxAuth>().isActionPermitted(
                              PermissionEnum.User_Visits_PrintReciept,
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

                        await showDialog<void>(
                          context: context,
                          builder: (context) {
                            return ChangeNotifierProvider.value(
                              value: PxOneVisitBookkeeping(
                                api: BookkeepingApi(
                                  visit_id: x.id,
                                ),
                              ),
                              child: RecieptPrepareDialog(
                                visit: x,
                              ),
                            );
                          },
                        );
                      },
                    ),
                    PopupMenuItem<void>(
                      child: ChangeNotifierProvider(
                        create: (context) => PxVisitData(
                          api: VisitDataApi(
                            visit_id: x.id,
                          ),
                        ),
                        child: InkWell(
                          child: Row(
                            children: [
                              const Icon(Icons.arrow_forward),
                              SizedBox(width: 4),
                              Text(
                                context.loc.openVisit,
                              ),
                            ],
                          ),
                          onTap: () async {
                            //@permission
                            final _perm =
                                context.read<PxAuth>().isActionPermitted(
                                      PermissionEnum.Admin,
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
                            if (x.visit_status.id == a.notAttended.id) {
                              showIsnackbar(context.loc.visitNotAttended);
                              return;
                            }
                            GoRouter.of(context).goNamed(
                              AppRouter.visit_forms,
                              pathParameters: defaultPathParameters(context)
                                ..addAll({
                                  'visit_id': x.id,
                                }),
                            );
                          },
                        ),
                      ),
                    ),
                    PopupMenuItem<void>(
                      child: ChangeNotifierProvider(
                        create: (context) => PxPatientDocuments(
                          api: PatientDocumentApi(
                            patient_id: x.patient.id,
                          ),
                        ),
                        child: InkWell(
                          child: Row(
                            children: [
                              const Icon(FontAwesomeIcons.prescriptionBottle),
                              SizedBox(width: 4),
                              Text(
                                context.loc.printPrescription,
                              ),
                            ],
                          ),
                          onTap: () async {
                            if (x.visit_status.id == a.notAttended.id) {
                              showIsnackbar(context.loc.visitNotAttended);
                              return;
                            }
                            //todo: get patient documents
                            //TODO: print prescription
                          },
                        ),
                      ),
                    ),
                  ];
                },
              ),
              SizedBox(width: 10),
            ],
          ),
        );
      },
    );
  }
}
