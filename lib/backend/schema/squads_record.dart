import 'dart:async';

import 'index.dart';
import 'serializers.dart';
import 'package:built_value/built_value.dart';

part 'squads_record.g.dart';

abstract class SquadsRecord
    implements Built<SquadsRecord, SquadsRecordBuilder> {
  static Serializer<SquadsRecord> get serializer => _$squadsRecordSerializer;

  @nullable
  BuiltList<DocumentReference> get members;

  @nullable
  String get name;

  @nullable
  @BuiltValueField(wireName: 'creation_date')
  DateTime get creationDate;

  @nullable
  @BuiltValueField(wireName: kDocumentReferenceField)
  DocumentReference get reference;

  static void _initializeBuilder(SquadsRecordBuilder builder) => builder
    ..members = ListBuilder()
    ..name = '';

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('squads');

  static Stream<SquadsRecord> getDocument(DocumentReference ref) => ref
      .snapshots()
      .map((s) => serializers.deserializeWith(serializer, serializedData(s)));

  static Future<SquadsRecord> getDocumentOnce(DocumentReference ref) => ref
      .get()
      .then((s) => serializers.deserializeWith(serializer, serializedData(s)));

  SquadsRecord._();
  factory SquadsRecord([void Function(SquadsRecordBuilder) updates]) =
      _$SquadsRecord;

  static SquadsRecord getDocumentFromData(
          Map<String, dynamic> data, DocumentReference reference) =>
      serializers.deserializeWith(serializer,
          {...mapFromFirestore(data), kDocumentReferenceField: reference});
}

Map<String, dynamic> createSquadsRecordData({
  String name,
  DateTime creationDate,
}) =>
    serializers.toFirestore(
        SquadsRecord.serializer,
        SquadsRecord((s) => s
          ..members = null
          ..name = name
          ..creationDate = creationDate));
