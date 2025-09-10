import 'package:allevia_one/core/api/patient_document_api.dart';
import 'package:allevia_one/core/api/patient_previous_visits_api.dart';
import 'package:allevia_one/functions/shell_function.dart';
import 'package:allevia_one/models/patient_document/patient_document.dart';
import 'package:allevia_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits_page/pages/visit_data_page/widgets/image_source_and_document_type_dialog.dart';
import 'package:allevia_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits_page/pages/visit_data_page/widgets/detailed_previous_patient_visits_dialog.dart';
import 'package:allevia_one/providers/px_patient_documents.dart';
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
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class VisitDetailsPageInfoHeader extends StatelessWidget {
  const VisitDetailsPageInfoHeader({
    super.key,
    required this.patient,
    required this.title,
    required this.iconData,
  });
  final Patient patient;
  final String title;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return Consumer<PxVisitData>(
      builder: (context, v, _) {
        while (v.result == null) {
          return LinearProgressIndicator();
        }
        final _data = (v.result as ApiDataResult<VisitData>).data;
        return ChangeNotifierProvider.value(
          value: PxPatientDocuments(
            api: PatientDocumentApi(
              patient_id: patient.id,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: CircleAvatar(
                child: Icon(iconData),
              ),
              title: Row(
                children: [
                  Flexible(
                    child: Text(patient.name),
                  ),
                ],
              ),
              subtitle: Text(title),
              trailing: FloatingActionButton.small(
                heroTag: UniqueKey(),
                onPressed: null,
                child: PopupMenuButton<void>(
                  offset: Offset(0, 48),
                  elevation: 6,
                  icon: const Icon(Icons.settings),
                  shadowColor: Colors.transparent,
                  color: Colors.lightBlue.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(),
                  ),
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        child: Row(
                          spacing: 8,
                          children: [
                            const Icon(
                                FontAwesomeIcons.personWalkingArrowRight),
                            Text(context.loc.previousPatientVisits),
                          ],
                        ),
                        onTap: () async {
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
                      ),
                      PopupMenuItem(
                        child: Row(
                          spacing: 8,
                          children: [
                            const Icon(Icons.document_scanner),
                            Text(context.loc.patientDocuments),
                          ],
                        ),
                        onTap: () async {
                          //TODO: show previous patient Documents
                        },
                      ),
                      PopupMenuItem(
                        child: Row(
                          spacing: 8,
                          children: [
                            const Icon(FontAwesomeIcons.prescription),
                            Text(context.loc.visitPrescription),
                          ],
                        ),
                        onTap: () {
                          //todo: go to prescription page
                          GoRouter.of(context).goNamed(
                            AppRouter.visit_prescription,
                            pathParameters: defaultPathParameters(context)
                              ..addAll({
                                'visit_id': _data.visit_id,
                              }),
                          );
                        },
                      ),
                      PopupMenuItem(
                        onTap: () async {
                          final _picker = ImagePicker();

                          final _imgSrcDocType =
                              await showDialog<ImageSourceAndDocumentTypeId?>(
                            context: context,
                            builder: (context) {
                              return ImageSourceAndDocumentTypeDialog();
                            },
                          );

                          if (_imgSrcDocType == null) {
                            return;
                          }

                          final _image = await _picker.pickImage(
                              source: _imgSrcDocType.imageSource);
                          if (_image == null) {
                            return;
                          }

                          final _filename = _image.name;

                          final _file_bytes = await _image.readAsBytes();

                          final _document = PatientDocument(
                            id: '',
                            patient_id: _data.patient.id,
                            related_visit_id: _data.visit_id,
                            related_visit_data_id: _data.id,
                            document_type_id: _imgSrcDocType.document_type_id,
                            document: '',
                          );

                          if (context.mounted) {
                            await shellFunction(
                              context,
                              toExecute: () async {
                                await context
                                    .read<PxPatientDocuments>()
                                    .addPatientDocument(
                                      _document,
                                      _file_bytes,
                                      _filename,
                                    );
                              },
                            );
                          }
                        },
                        child: Row(
                          spacing: 8,
                          children: [
                            const Icon(Icons.upload_file),
                            Text(context.loc.attachDocument),
                          ],
                        ),
                      ),
                    ];
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
