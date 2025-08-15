import 'package:allevia_one/core/api/patient_previous_visits_api.dart';
import 'package:allevia_one/models/app_constants/app_permission.dart';
import 'package:allevia_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/patients_page/widgets/previous_visits_dialog.dart';
import 'package:allevia_one/providers/px_auth.dart';
import 'package:allevia_one/providers/px_patient_previous_visits.dart';
import 'package:allevia_one/widgets/not_permitted_dialog.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:allevia_one/core/api/forms_api.dart';
import 'package:allevia_one/core/api/patient_forms_api.dart';
import 'package:allevia_one/extensions/loc_ext.dart';
import 'package:allevia_one/functions/shell_function.dart';
import 'package:allevia_one/models/patient.dart';
import 'package:allevia_one/models/visits/visit_create_dto.dart';
import 'package:allevia_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/patients_page/widgets/add_new_visit_dialog.dart';
import 'package:allevia_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/patients_page/widgets/create_edit_patient_dialog.dart';
import 'package:allevia_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/patients_page/widgets/patient_forms_dialog.dart';
import 'package:allevia_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/patients_page/widgets/patient_id_card_dialog.dart';
import 'package:allevia_one/providers/px_app_constants.dart';
import 'package:allevia_one/providers/px_clinics.dart';
import 'package:allevia_one/providers/px_forms.dart';
import 'package:allevia_one/providers/px_locale.dart';
import 'package:allevia_one/providers/px_patient_forms.dart';
import 'package:allevia_one/providers/px_patients.dart';
import 'package:allevia_one/providers/px_visits.dart';
import 'package:allevia_one/router/router.dart';
import 'package:allevia_one/widgets/themed_popupmenu_btn.dart';
import 'package:provider/provider.dart';
import 'package:web/web.dart' as web;

class PatientInfoCard extends StatefulWidget {
  const PatientInfoCard({
    super.key,
    required this.patient,
    required this.index,
  });
  final Patient patient;
  final int index;

  @override
  State<PatientInfoCard> createState() => _PatientInfoCardState();
}

class _PatientInfoCardState extends State<PatientInfoCard> {
  @override
  Widget build(BuildContext context) {
    return Card.outlined(
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer3<PxAppConstants, PxPatients, PxClinics>(
          builder: (context, a, p, c, _) {
            while (c.result == null || a.constants == null) {
              return ListTile(
                title: Row(
                  children: [
                    Expanded(
                      child: LinearProgressIndicator(),
                    ),
                  ],
                ),
              );
            }
            return ListTile(
              leading: FloatingActionButton.small(
                heroTag: widget.patient.id,
                onPressed: null,
                child: Text('${widget.index + 1}'),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(child: Text(widget.patient.name)),
                  FloatingActionButton.small(
                    tooltip: context.loc.editPatientData,
                    heroTag: '${widget.patient.id}+${widget.index}',
                    onPressed: () async {
                      //todo: edit patient name/phone/dob
                      //@permission
                      final _perm = context.read<PxAuth>().isActionPermitted(
                            PermissionEnum.User_Patient_EditInfo,
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
                      final _patient = await showDialog<Patient?>(
                        context: context,
                        builder: (context) {
                          return CreateEditPatientDialog(
                            patient: widget.patient,
                          );
                        },
                      );
                      if (_patient == null) {
                        return;
                      }
                      if (context.mounted) {
                        await shellFunction(
                          context,
                          toExecute: () async {
                            await p.editPatientBaseData(_patient);
                          },
                        );
                      }
                    },
                    child: const Icon(Icons.edit),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
              titleAlignment: ListTileTitleAlignment.top,
              subtitle: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 8,
                        children: [
                          Text.rich(
                            TextSpan(
                              text: context.loc.dateOfBirth,
                              children: [
                                TextSpan(text: ' : '),
                                TextSpan(
                                  text: DateFormat(
                                    'dd / MM / yyyy',
                                    context.read<PxLocale>().lang,
                                  ).format(
                                    DateTime.parse(widget.patient.dob),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Text.rich(
                            TextSpan(
                              text: context.loc.phone,
                              children: [
                                TextSpan(text: ' : '),
                                TextSpan(
                                  text: widget.patient.phone,
                                ),
                                TextSpan(text: '  '),
                                WidgetSpan(
                                  child: InkWell(
                                    child: const Icon(Icons.call),
                                    onTap: () async {
                                      //@permission
                                      final _perm = context
                                          .read<PxAuth>()
                                          .isActionPermitted(
                                            PermissionEnum.User_Patient_Call,
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
                                      web.window.open(
                                        'tel://+2${widget.patient.phone}',
                                        '_blank',
                                      );
                                    },
                                  ),
                                ),
                                TextSpan(text: '  '),
                                WidgetSpan(
                                  child: InkWell(
                                    child:
                                        const Icon(FontAwesomeIcons.whatsapp),
                                    onTap: () async {
                                      //@permission
                                      final _perm = context
                                          .read<PxAuth>()
                                          .isActionPermitted(
                                            PermissionEnum
                                                .User_Patient_Whatsapp,
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
                                      web.window.open(
                                        'https://wa.me/+2${widget.patient.phone}',
                                        '_blank',
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (widget.patient.email.isNotEmpty)
                            Text.rich(
                              TextSpan(
                                text: context.loc.email,
                                children: [
                                  TextSpan(text: ' : '),
                                  TextSpan(
                                    text: widget.patient.email,
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () async {
                                        //@permission
                                        final _perm = context
                                            .read<PxAuth>()
                                            .isActionPermitted(
                                              PermissionEnum.User_Patient_Email,
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
                                        web.window.open(
                                          'mailto://${widget.patient.email}',
                                          '_blank',
                                        );
                                      },
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    ThemedPopupmenuBtn<void>(
                      tooltip: context.loc.patientActions,
                      icon: const Icon(Icons.add_reaction),
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(
                            child: Row(
                              children: [
                                const Icon(Icons.event_available_rounded),
                                SizedBox(width: 4),
                                Text(context.loc.addNewVisit),
                              ],
                            ),
                            onTap: () async {
                              //@permission
                              final _perm =
                                  context.read<PxAuth>().isActionPermitted(
                                        PermissionEnum.User_Patient_AddNewVisit,
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
                              final _visitDto =
                                  await showDialog<VisitCreateDto?>(
                                context: context,
                                builder: (context) {
                                  return AddNewVisitDialog(
                                    patient: widget.patient,
                                  );
                                },
                              );
                              if (_visitDto == null) {
                                return;
                              }
                              //todo:
                              if (context.mounted) {
                                await shellFunction(
                                  context,
                                  toExecute: () async {
                                    await context
                                        .read<PxVisits>()
                                        .addNewVisit(_visitDto);
                                    //todo: notify patient with visit details && entry number => manual
                                    //todo: generate bookkeeping entry based on the state of the visit
                                  },
                                  duration: const Duration(milliseconds: 500),
                                );
                              }
                              if (context.mounted) {
                                GoRouter.of(context).goNamed(
                                  AppRouter.app,
                                  pathParameters:
                                      defaultPathParameters(context),
                                );
                              }
                            },
                          ),
                          PopupMenuItem(
                            child: Row(
                              children: [
                                const Icon(Icons.sick_sharp),
                                SizedBox(width: 4),
                                Text(context.loc.previousPatientVisits),
                              ],
                            ),
                            onTap: () async {
                              //@permission
                              final _perm = context
                                  .read<PxAuth>()
                                  .isActionPermitted(
                                    PermissionEnum.User_Patient_PreviousVisits,
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
                              //TODO: build previous visits dialog ui && logic
                              await showDialog(
                                context: context,
                                builder: (context) {
                                  return ChangeNotifierProvider(
                                    key: ValueKey(widget.patient.id),
                                    create: (context) =>
                                        PxPatientPreviousVisits(
                                      api: PatientPreviousVisitsApi(
                                        patient_id: widget.patient.id,
                                      ),
                                    ),
                                    child: PreviousVisitsDialog(),
                                  );
                                },
                              );
                            },
                          ),
                          PopupMenuItem(
                            child: Row(
                              children: [
                                const Icon(FontAwesomeIcons.idCard),
                                SizedBox(width: 4),
                                Text(context.loc.patientCard),
                              ],
                            ),
                            onTap: () async {
                              //@permission
                              final _perm =
                                  context.read<PxAuth>().isActionPermitted(
                                        PermissionEnum.User_Patient_InfoCard,
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
                              await showDialog(
                                context: context,
                                builder: (context) {
                                  return PatientIdCardDialog(
                                    patient: widget.patient,
                                  );
                                },
                              );
                            },
                          ),
                          PopupMenuItem(
                            child: Row(
                              children: [
                                const Icon(Icons.attach_file),
                                SizedBox(width: 4),
                                Text(context.loc.patientForms),
                              ],
                            ),
                            onTap: () async {
                              //@permission
                              final _perm =
                                  context.read<PxAuth>().isActionPermitted(
                                        PermissionEnum.User_Patient_Forms,
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
                              await showDialog(
                                context: context,
                                builder: (context) {
                                  return MultiProvider(
                                    providers: [
                                      ChangeNotifierProvider(
                                        create: (context) => PxForms(
                                          api: FormsApi(),
                                        ),
                                      ),
                                      ChangeNotifierProvider(
                                        create: (context) => PxPatientForms(
                                          api: PatientFormsApi(
                                            patient_id: widget.patient.id,
                                          ),
                                        ),
                                      ),
                                    ],
                                    child: PatientFormsDialog(),
                                  );
                                },
                              );
                            },
                          ),
                        ];
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
