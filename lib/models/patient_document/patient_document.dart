import 'package:allevia_one/models/patient_document/document_type.dart';
import 'package:equatable/equatable.dart';

class PatientDocument extends Equatable {
  final String id;
  final String patient_id;
  final String related_visit_id;
  final String related_visit_data_id;
  final DocumentType document_type;
  final String document;

  const PatientDocument({
    required this.id,
    required this.patient_id,
    required this.related_visit_id,
    required this.related_visit_data_id,
    required this.document_type,
    required this.document,
  });

  PatientDocument copyWith({
    String? id,
    String? patient_id,
    String? related_visit_id,
    String? related_visit_data_id,
    DocumentType? document_type,
    String? document,
  }) {
    return PatientDocument(
      id: id ?? this.id,
      patient_id: patient_id ?? this.patient_id,
      related_visit_id: related_visit_id ?? this.related_visit_id,
      related_visit_data_id:
          related_visit_data_id ?? this.related_visit_data_id,
      document_type: document_type ?? this.document_type,
      document: document ?? this.document,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'patient_id': patient_id,
      'related_visit_id': related_visit_id,
      'related_visit_data_id': related_visit_data_id,
      'document_type': document_type.name,
      'document': document,
    };
  }

  factory PatientDocument.fromJson(Map<String, dynamic> map) {
    return PatientDocument(
      id: map['id'] as String,
      patient_id: map['patient_id'] as String,
      related_visit_id: map['related_visit_id'] as String,
      related_visit_data_id: map['related_visit_data_id'] as String,
      document_type: DocumentType.fromString(map['document_type'] as String),
      document: map['document'] as String,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      patient_id,
      related_visit_id,
      related_visit_data_id,
      document_type,
      document,
    ];
  }
}
