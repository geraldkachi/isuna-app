// To parse this JSON data, do
//
//     final pageInfoModel = pageInfoModelFromJson(jsonString);

import 'dart:convert';

PageInfoModel pageInfoModelFromJson(String str) => PageInfoModel.fromJson(json.decode(str));

String pageInfoModelToJson(PageInfoModel data) => json.encode(data.toJson());

class PageInfoModel {
    final bool? hasNextPage;
    final bool? hasPreviousPage;
    final String? startCursor;
    final String? endCursor;

    PageInfoModel({
        this.hasNextPage,
        this.hasPreviousPage,
        this.startCursor,
        this.endCursor,
    });

    factory PageInfoModel.fromJson(Map<String, dynamic> json) => PageInfoModel(
        hasNextPage: json["hasNextPage"],
        hasPreviousPage: json["hasPreviousPage"],
        startCursor: json["startCursor"],
        endCursor: json["endCursor"],
    );

    Map<String, dynamic> toJson() => {
        "hasNextPage": hasNextPage,
        "hasPreviousPage": hasPreviousPage,
        "startCursor": startCursor,
        "endCursor": endCursor,
    };
}
