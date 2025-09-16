import 'dart:typed_data';

import 'package:allevia_one/core/api/_api_result.dart';
import 'package:allevia_one/core/api/patient_document_api.dart';
import 'package:allevia_one/models/patient_document/expanded_patient_document.dart';
import 'package:allevia_one/models/patient_document/patient_document.dart';
import 'package:flutter/material.dart';

class PxPatientDocuments extends ChangeNotifier {
  final PatientDocumentApi api;

  PxPatientDocuments({required this.api}) {
    _init();
  }

  ApiResult<List<ExpandedPatientDocument>>? _documents;
  ApiResult<List<ExpandedPatientDocument>>? get documents => _documents;

  Future<void> _init() async {
    _documents = await api.fetchPatientDocuments();
    notifyListeners();
  }

  Future<void> retry() async => await _init();

  Future<void> addPatientDocument(
    PatientDocument document,
    Uint8List file_bytes,
    String filename,
  ) async {
    await api.addPatientDocument(
      document,
      file_bytes,
      filename,
    );
    await _init();
  }
}
