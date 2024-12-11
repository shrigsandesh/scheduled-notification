// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_info.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NotificationInfoAdapter extends TypeAdapter<NotificationInfo> {
  @override
  final int typeId = 1;

  @override
  NotificationInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NotificationInfo(
      name: fields[1] as String,
      dateTime: fields[2] as DateTime,
      enabled: fields[3] as bool,
      interval: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, NotificationInfo obj) {
    writer
      ..writeByte(4)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.dateTime)
      ..writeByte(3)
      ..write(obj.enabled)
      ..writeByte(4)
      ..write(obj.interval);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
