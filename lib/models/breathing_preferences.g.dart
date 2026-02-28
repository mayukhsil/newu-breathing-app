// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'breathing_preferences.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BreathingPreferencesAdapter extends TypeAdapter<BreathingPreferences> {
  @override
  final int typeId = 0;

  @override
  BreathingPreferences read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BreathingPreferences(
      simpleDurationSeconds: fields[0] as int,
      rounds: fields[1] as int,
      soundEnabled: fields[2] as bool,
      advancedTimingEnabled: fields[3] as bool,
      breatheInSeconds: fields[4] as int,
      holdInSeconds: fields[5] as int,
      breatheOutSeconds: fields[6] as int,
      holdOutSeconds: fields[7] as int,
    );
  }

  @override
  void write(BinaryWriter writer, BreathingPreferences obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.simpleDurationSeconds)
      ..writeByte(1)
      ..write(obj.rounds)
      ..writeByte(2)
      ..write(obj.soundEnabled)
      ..writeByte(3)
      ..write(obj.advancedTimingEnabled)
      ..writeByte(4)
      ..write(obj.breatheInSeconds)
      ..writeByte(5)
      ..write(obj.holdInSeconds)
      ..writeByte(6)
      ..write(obj.breatheOutSeconds)
      ..writeByte(7)
      ..write(obj.holdOutSeconds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BreathingPreferencesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
