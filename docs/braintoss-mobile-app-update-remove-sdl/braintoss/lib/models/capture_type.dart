import 'package:hive/hive.dart';

part "capture_type.g.dart";

@HiveType(typeId: 2)
enum CaptureType {
  @HiveField(0)
  photo,
  @HiveField(1)
  voice,
  @HiveField(2)
  note,
  @HiveField(3)
  voiceWatch,
}
