import 'dart:convert';

class StatusRequestResponse {
  StatusRequestResponse({
    required this.response,
  });

  ResponseObj response;

  factory StatusRequestResponse.fromRawJson(String str) =>
      StatusRequestResponse.fromJson(json.decode(str));

  factory StatusRequestResponse.fromJson(Map<String, dynamic> json) =>
      StatusRequestResponse(
        response: ResponseObj.fromJson(json["response"]),
      );
}

class ResponseObj {
  ResponseObj({
    this.status,
    this.error,
    this.description,
    this.history,
    this.messageId,
  });

  String? status;
  int? error;
  String? description;
  List<History>? history;
  String? messageId;

  factory ResponseObj.fromRawJson(String str) =>
      ResponseObj.fromJson(json.decode(str));

  factory ResponseObj.fromJson(Map<String, dynamic> json) => ResponseObj(
        status: json["status"],
        error: json["error"],
        description: json["description"],
        messageId: json["mid"],
        history: json["history"] == null
            ? null
            : List<History>.from(
                json["history"].map((x) => History.fromJson(x))),
      );
}

class History {
  History({
    this.code,
    this.status,
    this.email,
    this.description,
    this.language,
    this.alive,
    this.timestamp,
  });
  int? code;
  String? status;
  String? email;
  int? timestamp;
  String? description;
  String? language;
  String? alive;

  factory History.fromRawJson(String str) => History.fromJson(json.decode(str));

  factory History.fromJson(Map<String, dynamic> json) => History(
        status: json["status"],
        email: json["email"],
        timestamp: json["timestamp"],
        code: json["code"],
        description: json["description"],
        language: json["language"],
        alive: json["alive"],
      );
}
