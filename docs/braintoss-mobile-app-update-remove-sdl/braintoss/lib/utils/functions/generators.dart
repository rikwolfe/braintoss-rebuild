import 'package:uuid/uuid.dart';

String generateTimestamp() {
  return DateTime.now().millisecondsSinceEpoch.toString();
}

String generateUUIDv1() {
  return const Uuid().v1().toString();
}

String generateUUIDv4() {
  return const Uuid().v4().toString();
}
