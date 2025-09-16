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

  List<ExpandedPatientDocument>? _filteredDocuments;
  // List<ExpandedPatientDocument>? get filteredDocuments => _filteredDocuments;

  Map<DateTime, List<ExpandedPatientDocument>>? _groupedDocuments;
  Map<DateTime, List<ExpandedPatientDocument>>? get groupedDocuments =>
      _groupedDocuments;

  Future<void> _init() async {
    _documents = await api.fetchPatientDocuments();
    notifyListeners();
    try {
      _filteredDocuments =
          (_documents as ApiDataResult<List<ExpandedPatientDocument>>).data;
      notifyListeners();
    } catch (e) {
      //TODO: handle
    }
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

  void filterAndGroup(String documentTypeId) {
    _filteredDocuments =
        (_documents as ApiDataResult<List<ExpandedPatientDocument>>)
            .data
            .where((e) {
      return e.documentType.id == documentTypeId;
    }).toList();
    _groupedDocuments = Map.fromEntries(_filteredDocuments!.map((doc) {
      //TODO: check grouping implementation
      final date = doc.created;
      final key = DateTime(date.year, date.month, date.day);
      return MapEntry(key, [
        ..._filteredDocuments!.where((e) {
          final _date1 = DateTime(date.year, date.month, date.day);
          final _date2 =
              DateTime(e.created.year, e.created.month, e.created.day);
          return _date1.isAtSameMomentAs(_date2);
        })
      ]);
    }));
    notifyListeners();
  }
}
