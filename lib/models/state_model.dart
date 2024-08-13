// To parse this JSON data, do
//
//     final stateModel = stateModelFromJson(jsonString);

import 'dart:convert';

StateModel stateModelFromJson(String str) => StateModel.fromJson(json.decode(str));

String stateModelToJson(StateModel data) => json.encode(data.toJson());

class StateModel {
    final String? name;
    final String? capital;
    final String? stateCode;
    final String? creationDate;
    final Location? location;
    final String? totalArea;
    final int? population;
    final dynamic postalCode;
    final List<dynamic>? religions;

    StateModel({
        this.name,
        this.capital,
        this.stateCode,
        this.creationDate,
        this.location,
        this.totalArea,
        this.population,
        this.postalCode,
        this.religions,
    });

    factory StateModel.fromJson(Map<String, dynamic> json) => StateModel(
        name: json["name"],
        capital: json["capital"],
        stateCode: json["state_code"],
        creationDate: json["creation_date"],
        location: json["location"] == null ? null : Location.fromJson(json["location"]),
        totalArea: json["total_area"],
        population: json["population"],
        postalCode: json["postal_code"],
        religions: json["religions"] == null ? [] : List<dynamic>.from(json["religions"]!.map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "capital": capital,
        "state_code": stateCode,
        "creation_date": creationDate,
        "location": location?.toJson(),
        "total_area": totalArea,
        "population": population,
        "postal_code": postalCode,
        "religions": religions == null ? [] : List<dynamic>.from(religions!.map((x) => x)),
    };
}

class Location {
    final String? latitude;
    final String? longitude;

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
