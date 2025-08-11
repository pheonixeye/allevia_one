import 'package:flutter/material.dart';
import 'package:allevia_one/core/api/_api_result.dart';
import 'package:allevia_one/extensions/loc_ext.dart';
import 'package:allevia_one/functions/shell_function.dart';
import 'package:allevia_one/models/patient.dart';
import 'package:allevia_one/models/api_result_mapper.dart';
import 'package:allevia_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/patients_page/widgets/create_edit_patient_dialog.dart';
import 'package:allevia_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/patients_page/widgets/patient_info_card.dart';
import 'package:allevia_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/patients_page/widgets/search_patients_header.dart';
import 'package:allevia_one/providers/px_locale.dart';
import 'package:allevia_one/providers/px_patients.dart';
import 'package:allevia_one/widgets/central_error.dart';
import 'package:allevia_one/widgets/central_loading.dart';
import 'package:provider/provider.dart';

class PatientsPage extends StatelessWidget {
  const PatientsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PxPatients>(
      builder: (context, p, _) {
        return Scaffold(
          floatingActionButton: FloatingActionButton.small(
            heroTag: 'add-new-patient',
            tooltip: context.loc.addNewPatient,
            onPressed: () async {
              //todo: Add new patient file dialog
              final _patient = await showDialog<Patient?>(
                context: context,
                builder: (context) {
                  return CreateEditPatientDialog();
                },
              );
              if (_patient == null) {
                return;
              }
              if (context.mounted) {
                await shellFunction(
                  context,
                  toExecute: () async {
                    await p.createPatientProfile(_patient);
                  },
                );
              }
            },
            child: const Icon(Icons.add),
          ),
          body: Column(
            children: [
              const SearchPatientsHeader(),
              Expanded(
                child: Consumer<PxLocale>(
                  builder: (context, l, _) {
                    while (p.data == null) {
                      return const CentralLoading();
                    }
                    if (p.data is ApiErrorResult) {
                      return CentralError(
                        code: (p.data as ApiErrorResult).errorCode,
                        toExecute: p.fetchPatients,
                      );
                    } else {
                      while (p.data != null &&
                          (p.data! as PatientDataResult).data.isEmpty) {
                        return Center(
                          child: Card.outlined(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(context.loc.noPatientsFound),
                            ),
                          ),
                        );
                      }
                      return ListView.builder(
                        itemCount: (p.data! as PatientDataResult).data.length,
                        itemBuilder: (context, index) {
                          final item =
                              (p.data! as PatientDataResult).data[index];
                          return PatientInfoCard(
                            patient: item,
                            index: index,
                          );
                        },
                      );
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton.outlined(
                      tooltip: context.loc.previous,
                      onPressed: () async {
                        await shellFunction(
                          context,
                          toExecute: () async {
                            await p.previousPage();
                          },
                        );
                      },
                      icon: const Icon(Icons.arrow_back),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('- ${p.page} -'),
                    ),
                    IconButton.outlined(
                      tooltip: context.loc.next,
                      onPressed: () async {
                        await shellFunction(
                          context,
                          toExecute: () async {
                            await p.nextPage();
                          },
                        );
                      },
                      icon: const Icon(Icons.arrow_forward),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
