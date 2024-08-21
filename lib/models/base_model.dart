// To parse this JSON data, do
//
//     final baseModel = baseModelFromJson(jsonString);

import 'dart:convert';

BaseModel baseModelFromJson(String str) => BaseModel.fromJson(json.decode(str));

String baseModelToJson(BaseModel data) => json.encode(data.toJson());

class BaseModel {
    final String? data;
    final bool? status;
    final String? message;

    BaseModel({
        this.data,
        this.status,
        this.message,
    });

    factory BaseModel.fromJson(Map<String, dynamic> json) => BaseModel(
        data: json["data"],
        status: json["status"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "data": data,
        "status": status,
        "message": message,
    };
}
