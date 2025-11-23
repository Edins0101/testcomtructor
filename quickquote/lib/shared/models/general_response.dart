import 'dart:convert';

GeneralResponse generalResponseFromJson(String str) => GeneralResponse.fromJson(json.decode(str));

String generalResponseToJson(GeneralResponse data) => json.encode(data.toJson());

class GeneralResponse<T> {
  GeneralResponse({
    this.data,
    required this.message,
    required this.error,
  });

  T? data;
  String message;
  bool error;

  factory GeneralResponse.fromJson(Map<String, dynamic> json) =>
      GeneralResponse(
          data: json["data"],
          message: json["message"],
          error: json["error"] ?? false);

  Map<String, dynamic> toJson() => {
        "data": data,
        "message": message,
      };
}