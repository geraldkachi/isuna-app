// To parse this JSON data, do
//
//     final lgaModel = lgaModelFromJson(jsonString);

import 'dart:convert';

LgaModel lgaModelFromJson(String str) => LgaModel.fromJson(json.decode(str));

String lgaModelToJson(LgaModel data) => json.encode(data.toJson());

class LgaModel {
    final String? name;
    final Location? location;
    final dynamic totalArea;
    final dynamic postalCode;
    final dynamic population;
    final dynamic creationDate;

    LgaModel({
        this.name,
        this.location,
        this.totalArea,
        this.postalCode,
        this.population,
        this.creationDate,
    });

    factory LgaModel.fromJson(Map<String, dynamic> json) => LgaModel(
        name: json["name"],
        location: json["location"] == null ? null : Location.fromJson(json["location"]),
        totalArea: json["total_area"],
        postalCode: json["postal_code"],
        population: json["population"],
        creationDate: json["creation_date"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "location": location?.toJson(),
        "total_area": totalArea,
        "postal_code": postalCode,
        "population": population,
        "creation_date": creationDate,
    };
}

class Location {
    final dynamic latitude;
    final dynamic longitude;

    Location({
        this.latitude,
        this.longitude,
    });

    factory Location.fromJson(Map<String, dynamic> json) => Location(
        latitude: json["latitude"],
        longitude: json["longitude"],
    );

    Map<String, dynamic> toJson() => {
        "latitude": latitude,
        "longitude": longitude,
    };
}
