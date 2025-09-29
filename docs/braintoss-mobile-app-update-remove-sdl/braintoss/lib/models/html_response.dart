import 'dart:convert';

ContentModel htmlResponseFromJson(String str) =>
    ContentModel.fromJson(json.decode(str));

class ContentModel {
  ContentModel({
    required this.response,
  });

  Response response;

  factory ContentModel.fromJson(Map<String, dynamic> json) => ContentModel(
        response: Response.fromJson(json["response"]),
      );
}

class Response {
  Response({
    required this.status,
    required this.error,
    this.html,
  });

  String status;
  int error;
  String? html;

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        status: json["status"],
        error: json["error"],
        html: json["html"],
      );
}
