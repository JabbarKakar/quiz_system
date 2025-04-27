// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_level_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveLevelAdapter extends TypeAdapter<HiveLevel> {
  @override
  final int typeId = 1;

  @override
  HiveLevel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveLevel(
      levelNumber: fields[0] as int,
      title: fields[1] as String,
      description: fields[2] as String,
      questions: (fields[3] as List).cast<HiveQuestion>(),
      isLocked: fields[4] as bool,
      highScore: fields[5] as int,
      questionsAnswered: fields[6] as int,
    );
  }

  @override
  void write(BinaryWriter writer, HiveLevel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.levelNumber)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.questions)
      ..writeByte(4)
      ..write(obj.isLocked)
      ..writeByte(5)
      ..write(obj.highScore)
      ..writeByte(6)
      ..write(obj.questionsAnswered);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveLevelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
