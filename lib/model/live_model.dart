// To parse this JSON data, do
//
//     final liveModel = liveModelFromJson(jsonString);

import 'dart:convert';

LiveModel liveModelFromJson(String str) => LiveModel.fromJson(json.decode(str));

String liveModelToJson(LiveModel data) => json.encode(data.toJson());

class LiveModel {
    List<Element> elements;

    LiveModel({
        required this.elements,
    });

    factory LiveModel.fromJson(Map<String, dynamic> json) => LiveModel(
        elements: List<Element>.from(json["elements"].map((x) => Element.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "elements": List<dynamic>.from(elements.map((x) => x.toJson())),
    };
}

class Element {
    int id;
    Stats stats;
    List<Explain> explain;

    Element({
        required this.id,
        required this.stats,
        required this.explain,
    });

    factory Element.fromJson(Map<String, dynamic> json) => Element(
        id: json["id"],
        stats: Stats.fromJson(json["stats"]),
        explain: List<Explain>.from(json["explain"].map((x) => Explain.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "stats": stats.toJson(),
        "explain": List<dynamic>.from(explain.map((x) => x.toJson())),
    };
}

class Explain {
    int fixture;
    List<Stat> stats;

    Explain({
        required this.fixture,
        required this.stats,
    });

    factory Explain.fromJson(Map<String, dynamic> json) => Explain(
        fixture: json["fixture"],
        stats: List<Stat>.from(json["stats"].map((x) => Stat.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "fixture": fixture,
        "stats": List<dynamic>.from(stats.map((x) => x.toJson())),
    };
}

class Stat {
    String identifier;
    int points;
    int value;

    Stat({
        required this.identifier,
        required this.points,
        required this.value,
    });

    factory Stat.fromJson(Map<String, dynamic> json) => Stat(
        identifier: json["identifier"],
        points: json["points"],
        value: json["value"],
    );

    Map<String, dynamic> toJson() => {
        "identifier": identifier,
        "points": points,
        "value": value,
    };
}

class Stats {
    int minutes;
    int goalsScored;
    int assists;
    int cleanSheets;
    int goalsConceded;
    int ownGoals;
    int penaltiesSaved;
    int penaltiesMissed;
    int yellowCards;
    int redCards;
    int saves;
    int bonus;
    int bps;
    String influence;
    String creativity;
    String threat;
    String ictIndex;
    int starts;
    String expectedGoals;
    String expectedAssists;
    String expectedGoalInvolvements;
    String expectedGoalsConceded;
    int totalPoints;
    bool inDreamteam;

    Stats({
        required this.minutes,
        required this.goalsScored,
        required this.assists,
        required this.cleanSheets,
        required this.goalsConceded,
        required this.ownGoals,
        required this.penaltiesSaved,
        required this.penaltiesMissed,
        required this.yellowCards,
        required this.redCards,
        required this.saves,
        required this.bonus,
        required this.bps,
        required this.influence,
        required this.creativity,
        required this.threat,
        required this.ictIndex,
        required this.starts,
        required this.expectedGoals,
        required this.expectedAssists,
        required this.expectedGoalInvolvements,
        required this.expectedGoalsConceded,
        required this.totalPoints,
        required this.inDreamteam,
    });

    factory Stats.fromJson(Map<String, dynamic> json) => Stats(
        minutes: json["minutes"],
        goalsScored: json["goals_scored"],
        assists: json["assists"],
        cleanSheets: json["clean_sheets"],
        goalsConceded: json["goals_conceded"],
        ownGoals: json["own_goals"],
        penaltiesSaved: json["penalties_saved"],
        penaltiesMissed: json["penalties_missed"],
        yellowCards: json["yellow_cards"],
        redCards: json["red_cards"],
        saves: json["saves"],
        bonus: json["bonus"],
        bps: json["bps"],
        influence: json["influence"],
        creativity: json["creativity"],
        threat: json["threat"],
        ictIndex: json["ict_index"],
        starts: json["starts"],
        expectedGoals: json["expected_goals"],
        expectedAssists: json["expected_assists"],
        expectedGoalInvolvements: json["expected_goal_involvements"],
        expectedGoalsConceded: json["expected_goals_conceded"],
        totalPoints: json["total_points"],
        inDreamteam: json["in_dreamteam"],
    );

    Map<String, dynamic> toJson() => {
        "minutes": minutes,
        "goals_scored": goalsScored,
        "assists": assists,
        "clean_sheets": cleanSheets,
        "goals_conceded": goalsConceded,
        "own_goals": ownGoals,
        "penalties_saved": penaltiesSaved,
        "penalties_missed": penaltiesMissed,
        "yellow_cards": yellowCards,
        "red_cards": redCards,
        "saves": saves,
        "bonus": bonus,
        "bps": bps,
        "influence": influence,
        "creativity": creativity,
        "threat": threat,
        "ict_index": ictIndex,
        "starts": starts,
        "expected_goals": expectedGoals,
        "expected_assists": expectedAssists,
        "expected_goal_involvements": expectedGoalInvolvements,
        "expected_goals_conceded": expectedGoalsConceded,
        "total_points": totalPoints,
        "in_dreamteam": inDreamteam,
    };
}
