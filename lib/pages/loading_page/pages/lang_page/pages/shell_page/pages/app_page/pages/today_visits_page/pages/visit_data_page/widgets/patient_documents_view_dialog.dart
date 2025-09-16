import 'package:allevia_one/core/api/_api_result.dart';
import 'package:allevia_one/extensions/loc_ext.dart';
import 'package:allevia_one/models/patient_document/expanded_patient_document.dart';
import 'package:allevia_one/providers/px_app_constants.dart';
import 'package:allevia_one/providers/px_locale.dart';
import 'package:allevia_one/providers/px_patient_documents.dart';
import 'package:allevia_one/widgets/central_error.dart';
import 'package:allevia_one/widgets/central_loading.dart';
import 'package:allevia_one/widgets/central_no_items.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PatientDocumentsViewDialog extends StatelessWidget {
  const PatientDocumentsViewDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer3<PxAppConstants, PxPatientDocuments, PxLocale>(
      builder: (context, a, d, l, _) {
        while (a.constants == null || d.documents == null) {
          return const CentralLoading();
        }
        final _result =
            (d.documents as ApiResult<List<ExpandedPatientDocument>>);
        while (_result is ApiErrorResult<List<ExpandedPatientDocument>>) {
          return CentralError(
            code: (_result as ApiErrorResult).errorCode,
            toExecute: d.retry,
          );
        }
        final _data =
            (_result as ApiDataResult<List<ExpandedPatientDocument>>).data;
        while (_data.isEmpty) {
          return CentralNoItems(
            message: context.loc.noItemsFound,
          );
        }
        return AlertDialog(
          title: Row(
            children: [
              Expanded(
                child: Text.rich(
                  TextSpan(
                    text: context.loc.previousPatientVisits,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    children: [
                      TextSpan(text: '\n'),
                      TextSpan(
                        text: '(${_data.first.patient.name})',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 10),
              IconButton.outlined(
                onPressed: () {
                  Navigator.pop(context, null);
                },
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          contentPadding: const EdgeInsets.all(8),
          insetPadding: const EdgeInsets.all(8),
          content: SizedBox(
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height,
          ),
        );
      },
    );
  }
}
