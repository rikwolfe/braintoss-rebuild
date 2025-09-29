import 'package:braintoss/models/request_response_type.dart';

class RequestResponse {
  const RequestResponse({
    required this.type,
    this.error = false,
    this.resolved = true,
    this.sent = false,
  });
  final ResponseStatusType type;
  final bool resolved;
  final bool error;
  final bool sent;
}
