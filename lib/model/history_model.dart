// To parse this JSON data, do
//
//     final historyModel = historyModelFromJson(jsonString);

import 'dart:convert';

HistoryModel historyModelFromJson(String str) => HistoryModel.fromJson(json.decode(str));

String historyModelToJson(HistoryModel data) => json.encode(data.toJson());

class HistoryModel {
    List<Map<String, dynamic>> current;
    List<Past> past;
    List<Chip> chips;

    HistoryModel({
        required this.current,
        required this.past,
        required this.chips,
    });

    factory HistoryModel.fromJson(Map<String, dynamic> json) => HistoryModel(
        current: List<Map<String, dynamic>>.from(json["current"].map((x) => Map.from(x).map((k, v) => MapEntry<String, dynamic>(k, v)))),
        past: List<Past>.from(json["past"].map((x) => Past.fromJson(x))),
        chips: List<Chip>.from(json["chips"].map((x) => Chip.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "current": List<dynamic>.from(current.map((x) => Map.from(x).map((k, v) => MapEntry<String, dynamic>(k, v)))),
        "past": List<dynamic>.from(past.map((x) => x.toJson())),
        "chips": List<dynamic>.from(chips.map((x) => x.toJson())),
    };
}

class Chip {
    String name;
    DateTime time;
    int event;

    Chip({
        required this.name,
        required this.time,
        required this.event,
    });

    factory Chip.fromJson(Map<String, dynamic> json) => Chip(
        name: json["name"],
        time: DateTime.parse(json["time"]),
        event: json["event"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "time": time.toIso8601String(),
        "event": event,
    };
}

class Past {
    String seasonName;
    int totalPoints;
    int rank;

    Past({
        required this.seasonName,
        required this.totalPoints,
        required this.rank,
    });

    factory Past.fromJson(Map<String, dynamic> json) => Past(
        seasonName: json["season_name"],
        totalPoints: json["total_points"],
        rank: json["rank"],
    );

    Map<String, dynamic> toJson() => {
        "season_name": seasonName,
        "total_points": totalPoints,
        "rank": rank,
    };
}
