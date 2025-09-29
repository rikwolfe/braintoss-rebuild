// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'capture_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CaptureEntityAdapter extends TypeAdapter<CaptureEntity> {
  @override
  final int typeId = 1;

  @override
  CaptureEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CaptureEntity(
      messageID: fields[0] as String,
      captureSource: fields[1] as CaptureType,
      timestamp: fields[2] as String,
      filename: fields[3] as String,
      fullFilePath: fields[4] as String,
      status: fields[5] as String,
      email: fields[6] as String?,
      statusCode: fields[7] as int?,
      description: fields[8] as String?,
      bitrate: fields[9] as String?,
      vcard: fields[10] as bool,
      ocr: fields[11] as bool,
      location: fields[12] as String?,
      shared: fields[13] as bool,
      alive: fields[14] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, CaptureEntity obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.messageID)
      ..writeByte(1)
      ..write(obj.captureSource)
      ..writeByte(2)
      ..write(obj.timestamp)
      ..writeByte(3)
      ..write(obj.filename)
      ..writeByte(4)
      ..write(obj.fullFilePath)
      ..writeByte(5)
      ..write(obj.status)
      ..writeByte(6)
      ..write(obj.email)
      ..writeByte(7)
      ..write(obj.statusCode)
      ..writeByte(8)
      ..write(obj.description)
      ..writeByte(9)
      ..write(obj.bitrate)
      ..writeByte(10)
      ..write(obj.vcard)
      ..writeByte(11)
      ..write(obj.ocr)
      ..writeByte(12)
      ..write(obj.location)
      ..writeByte(13)
      ..write(obj.shared)
      ..writeByte(14)
      ..write(obj.alive);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CaptureEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
