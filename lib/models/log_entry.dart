import 'package:equatable/equatable.dart';

class LogEntry extends Equatable {
  final String id;
  final String item_id;
  final String collection_id;
  final String message;

  const LogEntry({
    required this.id,
    required this.item_id,
    required this.collection_id,
    required this.message,
  });

  LogEntry copyWith({
    String? id,
    String? item_id,
    String? collection_id,
    String? message,
  }) {
    return LogEntry(
      id: id ?? this.id,
      item_id: item_id ?? this.item_id,
      collection_id: collection_id ?? this.collection_id,
      message: message ?? this.message,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'item_id': item_id,
      'collection_id': collection_id,
      'message': message,
    };
  }

  factory LogEntry.fromJson(Map<String, dynamic> map) {
    return LogEntry(
      id: map['id'] as String,
      item_id: map['item_id'] as String,
      collection_id: map['collection_id'] as String,
      message: map['message'] as String,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [
        id,
        item_id,
        collection_id,
        message,
      ];
}
