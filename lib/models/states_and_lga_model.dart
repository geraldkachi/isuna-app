// To parse this JSON data, do
//
//     final statesAndLgaModel = statesAndLgaModelFromJson(jsonString);

import 'dart:convert';

StatesAndLgaModel statesAndLgaModelFromJson(String str) => StatesAndLgaModel.fromJson(json.decode(str));

String statesAndLgaModelToJson(StatesAndLgaModel data) => json.encode(data.toJson());

class StatesAndLgaModel {
    final String? name;
    final String? capital;
    final String? stateCode;
    final String? creationDate;
    final Location? location;
    final String? totalArea;
    final int? population;
    final List<Lgas>? towns;
    final List<Lgas>? lgas;
    final dynamic postalCode;
    final List<dynamic>? borderingStates;
    final List<dynamic>? nationalResources;
    final Politics? politics;
    final List<dynamic>? universities;
    final List<dynamic>? polytechnics;
    final List<dynamic>? airports;
    final List<dynamic>? hospitals;
    final List<dynamic>? languages;
    final List<dynamic>? ethnicGroups;
    final List<dynamic>? religions;

    StatesAndLgaModel({
        this.name,
        this.capital,
        this.stateCode,
        this.creationDate,
        this.location,
        this.totalArea,
        this.population,
        this.towns,
        this.lgas,
        this.postalCode,
        this.borderingStates,
        this.nationalResources,
        this.politics,
        this.universities,
        this.polytechnics,
        this.airports,
        this.hospitals,
        this.languages,
        this.ethnicGroups,
        this.religions,
    });

    factory StatesAndLgaModel.fromJson(Map<String, dynamic> json) => StatesAndLgaModel(
        name: json["name"],
        capital: json["capital"],
        stateCode: json["state_code"],
        creationDate: json["creation_date"],
        location: json["location"] == null ? null : Location.fromJson(json["location"]),
        totalArea: json["total_area"],
        population: json["population"],
        towns: json["towns"] == null ? [] : List<Lgas>.from(json["towns"]!.map((x) => Lgas.fromJson(x))),
        lgas: json["lgas"] == null ? [] : List<Lgas>.from(json["lgas"]!.map((x) => Lgas.fromJson(x))),
        postalCode: json["postal_code"],
        borderingStates: json["bordering_states"] == null ? [] : List<dynamic>.from(json["bordering_states"]!.map((x) => x)),
        nationalResources: json["national_resources"] == null ? [] : List<dynamic>.from(json["national_resources"]!.map((x) => x)),
        politics: json["politics"] == null ? null : Politics.fromJson(json["politics"]),
        universities: json["universities"] == null ? [] : List<dynamic>.from(json["universities"]!.map((x) => x)),
        polytechnics: json["polytechnics"] == null ? [] : List<dynamic>.from(json["polytechnics"]!.map((x) => x)),
        airports: json["airports"] == null ? [] : List<dynamic>.from(json["airports"]!.map((x) => x)),
        hospitals: json["hospitals"] == null ? [] : List<dynamic>.from(json["hospitals"]!.map((x) => x)),
        languages: json["languages"] == null ? [] : List<dynamic>.from(json["languages"]!.map((x) => x)),
        ethnicGroups: json["ethnic_groups"] == null ? [] : List<dynamic>.from(json["ethnic_groups"]!.map((x) => x)),
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
        "towns": towns == null ? [] : List<dynamic>.from(towns!.map((x) => x.toJson())),
        "lgas": lgas == null ? [] : List<dynamic>.from(lgas!.map((x) => x.toJson())),
        "postal_code": postalCode,
        "bordering_states": borderingStates == null ? [] : List<dynamic>.from(borderingStates!.map((x) => x)),
        "national_resources": nationalResources == null ? [] : List<dynamic>.from(nationalResources!.map((x) => x)),
        "politics": politics?.toJson(),
        "universities": universities == null ? [] : List<dynamic>.from(universities!.map((x) => x)),
        "polytechnics": polytechnics == null ? [] : List<dynamic>.from(polytechnics!.map((x) => x)),
        "airports": airports == null ? [] : List<dynamic>.from(airports!.map((x) => x)),
        "hospitals": hospitals == null ? [] : List<dynamic>.from(hospitals!.map((x) => x)),
        "languages": languages == null ? [] : List<dynamic>.from(languages!.map((x) => x)),
        "ethnic_groups": ethnicGroups == null ? [] : List<dynamic>.from(ethnicGroups!.map((x) => x)),
        "religions": religions == null ? [] : List<dynamic>.from(religions!.map((x) => x)),
    };
}

class Lgas {
    final String? name;
    final Location? location;
    final dynamic totalArea;
    final dynamic postalCode;
    final dynamic population;
    final dynamic creationDate;

    Lgas({
        this.name,
        this.location,
        this.totalArea,
        this.postalCode,
        this.population,
        this.creationDate,
    });

    factory Lgas.fromJson(Map<String, dynamic> json) => Lgas(
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

class Politics {
    final String? governor;
    final String? deputyGovernor;

    Politics({
        this.governor,
        this.deputyGovernor,
    });

    factory Politics.fromJson(Map<String, dynamic> json) => Politics(
        governor: json["governor"],
        deputyGovernor: json["deputy_governor"],
    );

    Map<String, dynamic> toJson() => {
        "governor": governor,
        "deputy_governor": deputyGovernor,
    };
}
