// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_quiz_attempt_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveQuizAttemptAdapter extends TypeAdapter<HiveQuizAttempt> {
  @override
  final int typeId = 2;

  @override
  HiveQuizAttempt read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveQuizAttempt(
      levelNumber: fields[0] as int,
      dateTime: fields[1] as DateTime,
      score: fields[2] as int,
      totalQuestions: fields[3] as int,
      questionResults: (fields[4] as Map).cast<String, bool>(),
    );
  }

  @override
  void write(BinaryWriter writer, HiveQuizAttempt obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.levelNumber)
      ..writeByte(1)
      ..write(obj.dateTime)
      ..writeByte(2)
      ..write(obj.score)
      ..writeByte(3)
      ..write(obj.totalQuestions)
      ..writeByte(4)
      ..write(obj.questionResults);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveQuizAttemptAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
