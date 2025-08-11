import 'package:flutter/material.dart';
import 'package:allevia_one/core/api/_api_result.dart';
import 'package:allevia_one/extensions/loc_ext.dart';
import 'package:allevia_one/models/visit_data/visit_data.dart';
import 'package:allevia_one/providers/px_locale.dart';
import 'package:allevia_one/providers/px_visit_data.dart';
import 'package:allevia_one/widgets/central_error.dart';
import 'package:allevia_one/widgets/central_loading.dart';
import 'package:provider/provider.dart';

class VisitDataViewDialog extends StatelessWidget {
  const VisitDataViewDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<PxVisitData, PxLocale>(
      builder: (context, v, l, _) {
        while (v.result == null) {
          return CentralLoading();
        }
        while (v.result is ApiErrorResult) {
          return CentralError(
            code: (v.result as ApiErrorResult).errorCode,
            toExecute: v.retry,
          );
        }
        final _data = (v.result as ApiDataResult<VisitData>).data;
        return AlertDialog(
          backgroundColor: Colors.blue.shade50,
          title: Row(
            children: [
              Expanded(
                child: Text.rich(
                  TextSpan(
                    text: context.loc.visitData,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    children: [
                      TextSpan(text: '\n'),
                      TextSpan(
                        text: '(${_data.patient.name})',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
            //TODO: add visit data in an easy to view way
          ),
        );
      },
    );
  }
}
