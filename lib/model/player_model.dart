// To parse this JSON data, do
//
//     final playerModel = playerModelFromJson(jsonString);

import 'dart:convert';

PlayerModel playerModelFromJson(String str) => PlayerModel.fromJson(json.decode(str));

String playerModelToJson(PlayerModel data) => json.encode(data.toJson());

class PlayerModel {
    int id;
    DateTime joinedTime;
    int startedEvent;
    int favouriteTeam;
    String playerFirstName;
    String playerLastName;
    int playerRegionId;
    String playerRegionName;
    String playerRegionIsoCodeShort;
    String playerRegionIsoCodeLong;
    int summaryOverallPoints;
    int summaryOverallRank;
    int summaryEventPoints;
    int summaryEventRank;
    int currentEvent;
    Leagues leagues;
    String name;
    bool nameChangeBlocked;
    dynamic kit;
    int lastDeadlineBank;
    int lastDeadlineValue;
    int lastDeadlineTotalTransfers;

    PlayerModel({
        required this.id,
        required this.joinedTime,
        required this.startedEvent,
        required this.favouriteTeam,
        required this.playerFirstName,
        required this.playerLastName,
        required this.playerRegionId,
        required this.playerRegionName,
        required this.playerRegionIsoCodeShort,
        required this.playerRegionIsoCodeLong,
        required this.summaryOverallPoints,
        required this.summaryOverallRank,
        required this.summaryEventPoints,
        required this.summaryEventRank,
        required this.currentEvent,
        required this.leagues,
        required this.name,
        required this.nameChangeBlocked,
        required this.kit,
        required this.lastDeadlineBank,
        required this.lastDeadlineValue,
        required this.lastDeadlineTotalTransfers,
    });

    factory PlayerModel.fromJson(Map<String, dynamic> json) => PlayerModel(
        id: json["id"],
        joinedTime: DateTime.parse(json["joined_time"]),
        startedEvent: json["started_event"],
        favouriteTeam: json["favourite_team"],
        playerFirstName: json["player_first_name"],
        playerLastName: json["player_last_name"],
        playerRegionId: json["player_region_id"],
        playerRegionName: json["player_region_name"],
        playerRegionIsoCodeShort: json["player_region_iso_code_short"],
        playerRegionIsoCodeLong: json["player_region_iso_code_long"],
        summaryOverallPoints: json["summary_overall_points"],
        summaryOverallRank: json["summary_overall_rank"],
        summaryEventPoints: json["summary_event_points"],
        summaryEventRank: json["summary_event_rank"],
        currentEvent: json["current_event"],
        leagues: Leagues.fromJson(json["leagues"]),
        name: json["name"],
        nameChangeBlocked: json["name_change_blocked"],
        kit: json["kit"],
        lastDeadlineBank: json["last_deadline_bank"],
        lastDeadlineValue: json["last_deadline_value"],
        lastDeadlineTotalTransfers: json["last_deadline_total_transfers"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "joined_time": joinedTime.toIso8601String(),
        "started_event": startedEvent,
        "favourite_team": favouriteTeam,
        "player_first_name": playerFirstName,
        "player_last_name": playerLastName,
        "player_region_id": playerRegionId,
        "player_region_name": playerRegionName,
        "player_region_iso_code_short": playerRegionIsoCodeShort,
        "player_region_iso_code_long": playerRegionIsoCodeLong,
        "summary_overall_points": summaryOverallPoints,
        "summary_overall_rank": summaryOverallRank,
        "summary_event_points": summaryEventPoints,
        "summary_event_rank": summaryEventRank,
        "current_event": currentEvent,
        "leagues": leagues.toJson(),
        "name": name,
        "name_change_blocked": nameChangeBlocked,
        "kit": kit,
        "last_deadline_bank": lastDeadlineBank,
        "last_deadline_value": lastDeadlineValue,
        "last_deadline_total_transfers": lastDeadlineTotalTransfers,
    };
}

class Leagues {
    List<Classic> classic;
    List<Classic> h2H;
    Cup cup;
    List<dynamic> cupMatches;

    Leagues({
        required this.classic,
        required this.h2H,
        required this.cup,
        required this.cupMatches,
    });

    factory Leagues.fromJson(Map<String, dynamic> json) => Leagues(
        classic: List<Classic>.from(json["classic"].map((x) => Classic.fromJson(x))),
        h2H: List<Classic>.from(json["h2h"].map((x) => Classic.fromJson(x))),
        cup: Cup.fromJson(json["cup"]),
        cupMatches: List<dynamic>.from(json["cup_matches"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "classic": List<dynamic>.from(classic.map((x) => x.toJson())),
        "h2h": List<dynamic>.from(h2H.map((x) => x.toJson())),
        "cup": cup.toJson(),
        "cup_matches": List<dynamic>.from(cupMatches.map((x) => x)),
    };
}

class Classic {
    int id;
    String name;
    String? shortName;
    DateTime created;
    bool closed;
    dynamic rank;
    dynamic maxEntries;
    LeagueType leagueType;
    Scoring scoring;
    int? adminEntry;
    int startEvent;
    bool entryCanLeave;
    bool entryCanAdmin;
    bool entryCanInvite;
    bool hasCup;
    dynamic cupLeague;
    dynamic cupQualified;
    int entryRank;
    int entryLastRank;

    Classic({
        required this.id,
        required this.name,
        required this.shortName,
        required this.created,
        required this.closed,
        required this.rank,
        required this.maxEntries,
        required this.leagueType,
        required this.scoring,
        required this.adminEntry,
        required this.startEvent,
        required this.entryCanLeave,
        required this.entryCanAdmin,
        required this.entryCanInvite,
        required this.hasCup,
        required this.cupLeague,
        required this.cupQualified,
        required this.entryRank,
        required this.entryLastRank,
    });

    factory Classic.fromJson(Map<String, dynamic> json) => Classic(
        id: json["id"],
        name: json["name"],
        shortName: json["short_name"],
        created: DateTime.parse(json["created"]),
        closed: json["closed"],
        rank: json["rank"],
        maxEntries: json["max_entries"],
        leagueType: leagueTypeValues.map[json["league_type"]]!,
        scoring: scoringValues.map[json["scoring"]]!,
        adminEntry: json["admin_entry"],
        startEvent: json["start_event"],
        entryCanLeave: json["entry_can_leave"],
        entryCanAdmin: json["entry_can_admin"],
        entryCanInvite: json["entry_can_invite"],
        hasCup: json["has_cup"],
        cupLeague: json["cup_league"],
        cupQualified: json["cup_qualified"],
        entryRank: json["entry_rank"],
        entryLastRank: json["entry_last_rank"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "short_name": shortName,
        "created": created.toIso8601String(),
        "closed": closed,
        "rank": rank,
        "max_entries": maxEntries,
        "league_type": leagueTypeValues.reverse[leagueType],
        "scoring": scoringValues.reverse[scoring],
        "admin_entry": adminEntry,
        "start_event": startEvent,
        "entry_can_leave": entryCanLeave,
        "entry_can_admin": entryCanAdmin,
        "entry_can_invite": entryCanInvite,
        "has_cup": hasCup,
        "cup_league": cupLeague,
        "cup_qualified": cupQualified,
        "entry_rank": entryRank,
        "entry_last_rank": entryLastRank,
    };
}

enum LeagueType {
    S,
    X
}

final leagueTypeValues = EnumValues({
    "s": LeagueType.S,
    "x": LeagueType.X
});

enum Scoring {
    C,
    H
}

final scoringValues = EnumValues({
    "c": Scoring.C,
    "h": Scoring.H
});

class Cup {
    List<dynamic> matches;
    Status status;
    dynamic cupLeague;

    Cup({
        required this.matches,
        required this.status,
        required this.cupLeague,
    });

    factory Cup.fromJson(Map<String, dynamic> json) => Cup(
        matches: List<dynamic>.from(json["matches"].map((x) => x)),
        status: Status.fromJson(json["status"]),
        cupLeague: json["cup_league"],
    );

    Map<String, dynamic> toJson() => {
        "matches": List<dynamic>.from(matches.map((x) => x)),
        "status": status.toJson(),
        "cup_league": cupLeague,
    };
}

class Status {
    dynamic qualificationEvent;
    dynamic qualificationNumbers;
    dynamic qualificationRank;
    dynamic qualificationState;

    Status({
        required this.qualificationEvent,
        required this.qualificationNumbers,
        required this.qualificationRank,
        required this.qualificationState,
    });

    factory Status.fromJson(Map<String, dynamic> json) => Status(
        qualificationEvent: json["qualification_event"],
        qualificationNumbers: json["qualification_numbers"],
        qualificationRank: json["qualification_rank"],
        qualificationState: json["qualification_state"],
    );

    Map<String, dynamic> toJson() => {
        "qualification_event": qualificationEvent,
        "qualification_numbers": qualificationNumbers,
        "qualification_rank": qualificationRank,
        "qualification_state": qualificationState,
    };
}

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        reverseMap = map.map((k, v) => MapEntry(v, k));
        return reverseMap;
    }
}
