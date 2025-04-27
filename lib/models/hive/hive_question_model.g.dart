// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_question_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveQuestionAdapter extends TypeAdapter<HiveQuestion> {
  @override
  final int typeId = 0;

  @override
  HiveQuestion read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveQuestion(
      id: fields[0] as String,
      question: fields[1] as String,
      options: (fields[2] as List).cast<String>(),
      correctAnswerIndex: fields[3] as int,
      explanation: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, HiveQuestion obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.question)
      ..writeByte(2)
      ..write(obj.options)
      ..writeByte(3)
      ..write(obj.correctAnswerIndex)
      ..writeByte(4)
      ..write(obj.explanation);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveQuestionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
