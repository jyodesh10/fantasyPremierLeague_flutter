// To parse this JSON data, do
//
//     final picksModel = picksModelFromJson(jsonString);

import 'dart:convert';

PicksModel picksModelFromJson(String str) => PicksModel.fromJson(json.decode(str));

String picksModelToJson(PicksModel data) => json.encode(data.toJson());

class PicksModel {
    dynamic activeChip;
    List<dynamic> automaticSubs;
    Map<String, int> entryHistory;
    List<Pick> picks;

    PicksModel({
        required this.activeChip,
        required this.automaticSubs,
        required this.entryHistory,
        required this.picks,
    });

    factory PicksModel.fromJson(Map<String, dynamic> json) => PicksModel(
        activeChip: json["active_chip"],
        automaticSubs: List<dynamic>.from(json["automatic_subs"].map((x) => x)),
        entryHistory: Map.from(json["entry_history"]).map((k, v) => MapEntry<String, int>(k, v)),
        picks: List<Pick>.from(json["picks"].map((x) => Pick.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "active_chip": activeChip,
        "automatic_subs": List<dynamic>.from(automaticSubs.map((x) => x)),
        "entry_history": Map.from(entryHistory).map((k, v) => MapEntry<String, dynamic>(k, v)),
        "picks": List<dynamic>.from(picks.map((x) => x.toJson())),
    };
}

class Pick {
    int element;
    int position;
    int multiplier;
    bool isCaptain;
    bool isViceCaptain;

    Pick({
        required this.element,
        required this.position,
        required this.multiplier,
        required this.isCaptain,
        required this.isViceCaptain,
    });

    factory Pick.fromJson(Map<String, dynamic> json) => Pick(
        element: json["element"],
        position: json["position"],
        multiplier: json["multiplier"],
        isCaptain: json["is_captain"],
        isViceCaptain: json["is_vice_captain"],
    );

    Map<String, dynamic> toJson() => {
        "element": element,
        "position": position,
        "multiplier": multiplier,
        "is_captain": isCaptain,
        "is_vice_captain": isViceCaptain,
    };
}
