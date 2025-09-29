// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'capture_type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CaptureTypeAdapter extends TypeAdapter<CaptureType> {
  @override
  final int typeId = 2;

  @override
  CaptureType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return CaptureType.photo;
      case 1:
        return CaptureType.voice;
      case 2:
        return CaptureType.note;
      case 3:
        return CaptureType.voiceWatch;
      default:
        return CaptureType.photo;
    }
  }

  @override
  void write(BinaryWriter writer, CaptureType obj) {
    switch (obj) {
      case CaptureType.photo:
        writer.writeByte(0);
        break;
      case CaptureType.voice:
        writer.writeByte(1);
        break;
      case CaptureType.note:
        writer.writeByte(2);
        break;
      case CaptureType.voiceWatch:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CaptureTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
