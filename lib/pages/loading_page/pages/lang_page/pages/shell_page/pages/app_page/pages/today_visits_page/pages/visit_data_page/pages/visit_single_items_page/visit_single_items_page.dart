import 'package:allevia_one/core/api/patient_document_api.dart';
import 'package:allevia_one/models/patient_document/document_type.dart';
import 'package:allevia_one/models/patient_document/patient_document.dart';
import 'package:allevia_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits_page/pages/visit_data_page/pages/visit_single_items_page/widgets/image_source_dialog.dart';
import 'package:allevia_one/providers/px_patient_documents.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:allevia_one/core/api/_api_result.dart';
import 'package:allevia_one/core/api/clinic_inventory_api.dart';
import 'package:allevia_one/extensions/loc_ext.dart';
import 'package:allevia_one/functions/shell_function.dart';
import 'package:allevia_one/models/doctor_items/_doctor_item.dart';
import 'package:allevia_one/models/doctor_items/doctor_supply_item.dart';
import 'package:allevia_one/models/doctor_items/profile_setup_item.dart';
import 'package:allevia_one/models/visit_data/visit_data.dart';
import 'package:allevia_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits_page/pages/visit_data_page/pages/visit_single_items_page/widgets/supply_item_tile.dart';
import 'package:allevia_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits_page/pages/visit_data_page/widgets/visit_details_page_info_header.dart';
import 'package:allevia_one/providers/px_clinic_inventory.dart';
import 'package:allevia_one/providers/px_doctor_profile_items.dart';
import 'package:allevia_one/providers/px_locale.dart';
import 'package:allevia_one/providers/px_visit_data.dart';
import 'package:allevia_one/widgets/central_error.dart';
import 'package:allevia_one/widgets/central_loading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class VisitSingleItemsPage<T extends DoctorItem> extends StatelessWidget {
  const VisitSingleItemsPage({
    super.key,
    required this.setupItem,
  });
  final ProfileSetupItem setupItem;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer3<PxDoctorProfileItems<T>, PxVisitData, PxLocale>(
        builder: (context, p, v, l, _) {
          return Builder(
            builder: (context) {
              while (v.result == null || p.data == null) {
                return const CentralLoading();
              }

              while (v.result is ApiErrorResult || p.data is ApiErrorResult) {
                return CentralError(
                  code: (v.result as ApiErrorResult).errorCode,
                  toExecute: () async {
                    v.retry();
                    p.retry();
                  },
                );
              }
              final _doctor_items =
                  (p.filteredData as ApiDataResult<List<T>>).data;

              final List<T> _visit_items = switch (setupItem) {
                ProfileSetupItem.labs =>
                  (v.result as ApiDataResult<VisitData>).data.labs as List<T>,
                ProfileSetupItem.rads =>
                  (v.result as ApiDataResult<VisitData>).data.rads as List<T>,
                ProfileSetupItem.procedures =>
                  (v.result as ApiDataResult<VisitData>).data.procedures
                      as List<T>,
                ProfileSetupItem.supplies =>
                  (v.result as ApiDataResult<VisitData>).data.supplies
                      as List<T>,
                _ => [],
              };
              final _data = (v.result as ApiDataResult<VisitData>).data;
              return Column(
                children: [
                  ChangeNotifierProvider(
                    create: (context) => PxPatientDocuments(
                      api: PatientDocumentApi(
                        patient_id: _data.patient.id,
                      ),
                    ),
                    child: Builder(
                      builder: (context) {
                        return VisitDetailsPageInfoHeader(
                          patient: (v.result as ApiDataResult<VisitData>)
                              .data
                              .patient,
                          title: switch (setupItem) {
                            ProfileSetupItem.labs => context.loc.visitLabs,
                            ProfileSetupItem.rads => context.loc.visitRads,
                            ProfileSetupItem.procedures =>
                              context.loc.visitProcedures,
                            ProfileSetupItem.supplies =>
                              context.loc.visitSupplies,
                            _ => '',
                          },
                          iconData: switch (setupItem) {
                            ProfileSetupItem.labs => FontAwesomeIcons.droplet,
                            ProfileSetupItem.rads => FontAwesomeIcons.radiation,
                            ProfileSetupItem.procedures =>
                              FontAwesomeIcons.userDoctor,
                            ProfileSetupItem.supplies =>
                              FontAwesomeIcons.warehouse,
                            _ => Icons.vpn_key_rounded,
                          },
                          actionButton: switch (setupItem) {
                            ProfileSetupItem.labs ||
                            ProfileSetupItem.rads =>
                              FloatingActionButton.small(
                                tooltip: switch (setupItem) {
                                  ProfileSetupItem.labs =>
                                    context.loc.attachLabResult,
                                  ProfileSetupItem.rads =>
                                    context.loc.attachRadResult,
                                  _ => ''
                                },
                                heroTag: '${setupItem.name}add-documents',
                                onPressed: () async {
                                  //TODO:

                                  final _picker = ImagePicker();

                                  final _imgSrc =
                                      await showDialog<ImageSource?>(
                                    context: context,
                                    builder: (context) {
                                      return ImageSourceDialog();
                                    },
                                  );

                                  if (_imgSrc == null) {
                                    return;
                                  }

                                  final _image =
                                      await _picker.pickImage(source: _imgSrc);
                                  if (_image == null) {
                                    return;
                                  }

                                  final _filename = _image.name;

                                  final _file_bytes =
                                      await _image.readAsBytes();

                                  final _document = PatientDocument(
                                    id: '',
                                    patient_id: _data.patient.id,
                                    related_visit_id: _data.visit_id,
                                    related_visit_data_id: _data.id,
                                    document_type: switch (setupItem) {
                                      ProfileSetupItem.labs =>
                                        DocumentType.lab_res,
                                      ProfileSetupItem.rads =>
                                        DocumentType.rad_res,
                                      _ => throw UnimplementedError(),
                                    },
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
                                child: const Icon(Icons.upload_file),
                              ),
                            _ => null,
                          },
                        );
                      },
                    ),
                    builder: (context, child) {
                      return child ?? SizedBox();
                    },
                  ),
                  Card.outlined(
                    elevation: 6,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                hintText:
                                    context.loc.searchByEnglishOrArabicItemName,
                              ),
                              onChanged: (value) {
                                p.searchForItems(value);
                              },
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: FloatingActionButton.small(
                              tooltip: context.loc.clearSearch,
                              backgroundColor: Colors.red.shade200,
                              heroTag: UniqueKey(),
                              onPressed: () {
                                p.clearSearch();
                              },
                              child: const Icon(Icons.refresh),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: ChangeNotifierProvider(
                      create: (context) {
                        final clinic_id = (v.result as ApiDataResult<VisitData>)
                            .data
                            .clinic_id;
                        return PxClinicInventory(
                          api: ClinicInventoryApi(
                            clinic_id: clinic_id,
                          ),
                        );
                      },
                      child: ListView.builder(
                        itemCount: _doctor_items.length,
                        itemBuilder: (context, index) {
                          final _item = _doctor_items[index];
                          return Card.outlined(
                            elevation: 6,
                            child: switch (setupItem) {
                              ProfileSetupItem.supplies => SupplyItemTile(
                                  item: _item as DoctorSupplyItem,
                                  index: index,
                                ),
                              //ui for items other than supplies
                              _ => CheckboxListTile(
                                  title: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: FloatingActionButton.small(
                                            heroTag: UniqueKey(),
                                            onPressed: null,
                                            child: Text('${index + 1}'),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            l.isEnglish
                                                ? _item.name_en
                                                : _item.name_ar,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  value: _visit_items.contains(_item),
                                  onChanged: (value) async {
                                    await shellFunction(
                                      context,
                                      toExecute: () async {
                                        if (_visit_items.contains(_item)) {
                                          await v.removeFromItemList(
                                            _item.id,
                                            setupItem,
                                          );
                                        } else {
                                          await v.addToItemList(
                                            _item.id,
                                            setupItem,
                                          );
                                        }
                                      },
                                    );
                                  },
                                ),
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
