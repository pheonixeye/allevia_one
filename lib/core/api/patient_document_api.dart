import 'dart:typed_data';

import 'package:allevia_one/core/api/_api_result.dart';
import 'package:allevia_one/core/api/constants/pocketbase_helper.dart';
import 'package:allevia_one/errors/code_to_error.dart';
import 'package:allevia_one/models/patient_document/patient_document.dart';
import 'package:http/http.dart' as http;
import 'package:pocketbase/pocketbase.dart';

class PatientDocumentApi {
  const PatientDocumentApi({required this.patient_id});
  final String patient_id;

  static const collection = 'patient__documents';

  Future<ApiResult<PatientDocument>> addPatientDocument(
    PatientDocument document,
    Uint8List file_bytes,
    String filename,
  ) async {
    try {
      final _result = await PocketbaseHelper.pb.collection(collection).create(
        body: document.toJson(),
        files: [
          http.MultipartFile.fromBytes(
            'document',
            file_bytes,
            filename: filename,
          ),
        ],
      );
      final _patientDoc = PatientDocument.fromJson(_result.toJson());

      return ApiDataResult<PatientDocument>(data: _patientDoc);
    } on ClientException catch (e) {
      return ApiErrorResult<PatientDocument>(
        errorCode: AppErrorCode.clientException.code,
        originalErrorMessage: e.toString(),
      );
    }
  }

  Future<ApiResult<List<PatientDocument>>> fetchPatientDocuments() async {
    try {
      final _result =
          await PocketbaseHelper.pb.collection(collection).getFullList(
                filter: "patient_id = '$patient_id'",
              );

      final _docs =
          _result.map((e) => PatientDocument.fromJson(e.toJson())).toList();

      return ApiDataResult<List<PatientDocument>>(data: _docs);
    } on ClientException catch (e) {
      return ApiErrorResult<List<PatientDocument>>(
        errorCode: AppErrorCode.clientException.code,
        originalErrorMessage: e.toString(),
      );
    }
  }
}
