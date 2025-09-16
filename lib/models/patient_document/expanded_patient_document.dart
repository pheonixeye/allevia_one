// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:allevia_one/models/app_constants/document_type.dart';
import 'package:allevia_one/models/patient.dart';
import 'package:allevia_one/models/visit_data/visit_data.dart';
import 'package:allevia_one/models/visits/_visit.dart';
import 'package:pocketbase/pocketbase.dart';

class ExpandedPatientDocument extends Equatable {
  final String id;
  final Patient patient;
  final Visit visit;
  final VisitData visitData;
  final DocumentType documentType;
  final String document;

  const ExpandedPatientDocument({
    required this.id,
    required this.patient,
    required this.visit,
    required this.visitData,
    required this.documentType,
    required this.document,
  });

  @override
  List<Object> get props {
    return [
      id,
      patient,
      visit,
      visitData,
      documentType,
      document,
    ];
  }

  factory ExpandedPatientDocument.fromRecordModel(RecordModel record) {
    return ExpandedPatientDocument(
      id: record.id,
      patient: Patient.fromJson(
        record.get<RecordModel>('expand.patient_id').toJson(),
      ),
      visit: Visit.fromRecordModel(
        record.get<RecordModel>('expand.related_visit_id'),
      ),
      visitData: VisitData.fromRecordModel(
        record.get<RecordModel>('expand.related_visit_data_id'),
      ),
      documentType: DocumentType.fromJson(
        record.get<RecordModel>('expand.document_type_id').toJson(),
      ),
      document: record.data['document'] as String,
    );
  }
}
