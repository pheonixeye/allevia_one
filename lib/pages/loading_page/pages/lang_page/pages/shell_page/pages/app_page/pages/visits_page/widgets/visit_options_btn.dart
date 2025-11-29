import 'package:allevia_one/core/api/_api_result.dart';
import 'package:allevia_one/core/api/bookkeeping_api.dart';
import 'package:allevia_one/core/api/patient_document_api.dart';
import 'package:allevia_one/core/api/visit_data_api.dart';
import 'package:allevia_one/extensions/loc_ext.dart';
import 'package:allevia_one/functions/shell_function.dart';
import 'package:allevia_one/models/app_constants/app_permission.dart';
import 'package:allevia_one/models/visits/_visit.dart';
import 'package:allevia_one/models/visits/concised_visit.dart';
import 'package:allevia_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits_page/pages/visit_data_page/widgets/patient_documents_view_dialog.dart';
import 'package:allevia_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/visits_page/widgets/reciept_prepare_dialog.dart';
import 'package:allevia_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/visits_page/widgets/visit_data_view_dialog.dart';
import 'package:allevia_one/providers/px_app_constants.dart';
import 'package:allevia_one/providers/px_auth.dart';
import 'package:allevia_one/providers/px_one_visit_bookkeeping.dart';
import 'package:allevia_one/providers/px_patient_documents.dart';
import 'package:allevia_one/providers/px_visit_data.dart';
import 'package:allevia_one/providers/px_visit_filter.dart';
import 'package:allevia_one/router/router.dart';
import 'package:allevia_one/widgets/not_permitted_dialog.dart';
import 'package:allevia_one/widgets/snackbar_.dart';
import 'package:allevia_one/widgets/themed_popupmenu_btn.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class VisitOptionsBtn extends StatefulWidget {
  const VisitOptionsBtn({
    super.key,
    required this.concisedVisit,
  });
  final ConcisedVisit concisedVisit;

  @override
  State<VisitOptionsBtn> createState() => _VisitOptionsBtnState();
}

class _VisitOptionsBtnState extends State<VisitOptionsBtn> {
  Visit? _expandedVisit;
  @override
  Widget build(BuildContext context) {
    return Consumer2<PxAppConstants, PxVisitFilter>(
      builder: (context, a, v, _) {
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
                  if (_expandedVisit == null) {
                    await shellFunction(
                      context,
                      toExecute: () async {
                        await v.fetchOneExpandedVisit(widget.concisedVisit.id);
                        _expandedVisit =
                            (v.expandedVisit as ApiDataResult<Visit>).data;
                      },
                    );
                  }
                  if (context.mounted) {
                    await showDialog<void>(
                      context: context,
                      builder: (context) {
                        return ChangeNotifierProvider(
                          create: (context) => PxVisitData(
                            api: VisitDataApi(
                              visit_id: widget.concisedVisit.id,
                            ),
                          ),
                          child: VisitDataViewDialog(
                            visit: _expandedVisit!,
                          ),
                        );
                      },
                    );
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(widget.concisedVisit.patient.name),
                ),
              ),
              const Spacer(),
              ThemedPopupmenuBtn<void>(
                onOpened: () async {
                  if (_expandedVisit == null) {
                    await shellFunction(
                      context,
                      toExecute: () async {
                        await v.fetchOneExpandedVisit(widget.concisedVisit.id);
                        _expandedVisit =
                            (v.expandedVisit as ApiDataResult<Visit>).data;
                      },
                    );
                  }
                },
                icon: const Icon(Icons.menu),
                tooltip: context.loc.settings,
                itemBuilder: (context) {
                  return [
                    PopupMenuItem<void>(
                      onTap: null,
                      padding: const EdgeInsets.all(0),
                      child: InkWell(
                        onTap: () async {
                          //@permission
                          final _perm =
                              context.read<PxAuth>().isActionPermitted(
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
                                    visit_id: widget.concisedVisit.id,
                                  ),
                                ),
                                child: RecieptPrepareDialog(
                                  visit: _expandedVisit!,
                                ),
                              );
                            },
                          );
                        },
                        child: Row(
                          children: [
                            const Icon(Icons.receipt_long),
                            SizedBox(width: 4),
                            Text(context.loc.printReciept),
                          ],
                        ),
                      ),
                    ),
                    PopupMenuItem<void>(
                      onTap: null,
                      padding: const EdgeInsets.all(0),
                      child: ChangeNotifierProvider(
                        create: (context) => PxVisitData(
                          api: VisitDataApi(
                            visit_id: widget.concisedVisit.id,
                          ),
                        ),
                        child: InkWell(
                          child: Row(
                            children: [
                              const Icon(Icons.arrow_forward),
                              SizedBox(width: 4),
                              Text(context.loc.openVisit),
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
                            if (widget.concisedVisit.visit_status_id ==
                                a.notAttended.id) {
                              showIsnackbar(context.loc.visitNotAttended);
                              return;
                            }
                            GoRouter.of(context).goNamed(
                              AppRouter.visit_forms,
                              pathParameters: defaultPathParameters(context)
                                ..addAll({
                                  'visit_id': widget.concisedVisit.id,
                                }),
                            );
                          },
                        ),
                      ),
                    ),
                    PopupMenuItem<void>(
                      onTap: null,
                      padding: const EdgeInsets.all(0),
                      child: ChangeNotifierProvider(
                        create: (context) => PxPatientDocuments(
                          api: PatientDocumentApi(
                            patient_id: widget.concisedVisit.patient.id,
                          ),
                        ),
                        child: InkWell(
                          child: Row(
                            children: [
                              const Icon(Icons.document_scanner),
                              SizedBox(width: 4),
                              Text(context.loc.patientDocuments),
                            ],
                          ),
                          onTap: () async {
                            if (widget.concisedVisit.visit_status_id ==
                                a.notAttended.id) {
                              showIsnackbar(context.loc.visitNotAttended);
                              return;
                            }

                            await showDialog(
                              context: context,
                              builder: (context) {
                                return ChangeNotifierProvider(
                                  create: (context) => PxPatientDocuments(
                                    api: PatientDocumentApi(
                                      patient_id:
                                          widget.concisedVisit.patient.id,
                                    ),
                                    visit_id: widget.concisedVisit.id,
                                  ),
                                  child: const PatientDocumentsViewDialog(),
                                );
                              },
                            );
                            //todo: get patient documents
                            //TODO: print prescription
                            //TODO: Send patient the link VIA WHATSAPP
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
