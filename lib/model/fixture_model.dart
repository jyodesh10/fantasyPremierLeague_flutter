// To parse this JSON data, do
//
//     final fixtureModel = fixtureModelFromJson(jsonString);

import 'dart:convert';

List<FixtureModel> fixtureModelFromJson(String str) => List<FixtureModel>.from(json.decode(str).map((x) => FixtureModel.fromJson(x)));

String fixtureModelToJson(List<FixtureModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FixtureModel {
    int code;
    num event;
    bool finished;
    bool finishedProvisional;
    int id;
    DateTime kickoffTime;
    int minutes;
    bool provisionalStartTime;
    bool started;
    int teamA;
    int teamAScore;
    int teamH;
    int teamHScore;
    List<Stat> stats;
    int teamHDifficulty;
    int teamADifficulty;
    int pulseId;

    FixtureModel({
        required this.code,
        required this.event,
        required this.finished,
        required this.finishedProvisional,
        required this.id,
        required this.kickoffTime,
        required this.minutes,
        required this.provisionalStartTime,
        required this.started,
        required this.teamA,
        required this.teamAScore,
        required this.teamH,
        required this.teamHScore,
        required this.stats,
        required this.teamHDifficulty,
        required this.teamADifficulty,
        required this.pulseId,
    });

    factory FixtureModel.fromJson(Map<String, dynamic> json) => FixtureModel(
        code: json["code"],
        event: json["event"] ?? 0,
        finished: json["finished"],
        finishedProvisional: json["finished_provisional"],
        id: json["id"],
        kickoffTime: json["kickoff_time"]!=null ? DateTime.parse(json["kickoff_time"]) : DateTime.now(),
        minutes: json["minutes"],
        provisionalStartTime: json["provisional_start_time"],
        started: json["started"]?? false,
        teamA: json["team_a"],
        teamAScore: json["team_a_score"]??0,
        teamH: json["team_h"],
        teamHScore: json["team_h_score"]??0,
        stats: List<Stat>.from(json["stats"].map((x) => Stat.fromJson(x))),
        teamHDifficulty: json["team_h_difficulty"],
        teamADifficulty: json["team_a_difficulty"],
        pulseId: json["pulse_id"],
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "event": event,
        "finished": finished,
        "finished_provisional": finishedProvisional,
        "id": id,
        "kickoff_time": kickoffTime.toIso8601String(),
        "minutes": minutes,
        "provisional_start_time": provisionalStartTime,
        "started": started,
        "team_a": teamA,
        "team_a_score": teamAScore,
        "team_h": teamH,
        "team_h_score": teamHScore,
        "stats": List<dynamic>.from(stats.map((x) => x.toJson())),
        "team_h_difficulty": teamHDifficulty,
        "team_a_difficulty": teamADifficulty,
        "pulse_id": pulseId,
    };
}

class Stat {
    String identifier;
    List<A> a;
    List<A> h;

    Stat({
        required this.identifier,
        required this.a,
        required this.h,
    });

    factory Stat.fromJson(Map<String, dynamic> json) => Stat(
        identifier: json["identifier"],
        a: List<A>.from(json["a"].map((x) => A.fromJson(x))),
        h: List<A>.from(json["h"].map((x) => A.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "identifier": identifier,
        "a": List<dynamic>.from(a.map((x) => x.toJson())),
        "h": List<dynamic>.from(h.map((x) => x.toJson())),
    };
}

class A {
    int value;
    int element;

    A({
        required this.value,
        required this.element,
    });

    factory A.fromJson(Map<String, dynamic> json) => A(
        value: json["value"],
        element: json["element"],
    );

    Map<String, dynamic> toJson() => {
        "value": value,
        "element": element,
    };
}
