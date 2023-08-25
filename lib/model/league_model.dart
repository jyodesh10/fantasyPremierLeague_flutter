// To parse this JSON data, do
//
//     final leagueModel = leagueModelFromJson(jsonString);

import 'dart:convert';

LeagueModel leagueModelFromJson(String str) => LeagueModel.fromJson(json.decode(str));

String leagueModelToJson(LeagueModel data) => json.encode(data.toJson());

class LeagueModel {
    NewEntries newEntries;
    DateTime lastUpdatedData;
    League league;
    NewEntries standings;

    LeagueModel({
        required this.newEntries,
        required this.lastUpdatedData,
        required this.league,
        required this.standings,
    });

    factory LeagueModel.fromJson(Map<String, dynamic> json) => LeagueModel(
        newEntries: NewEntries.fromJson(json["new_entries"]),
        lastUpdatedData: DateTime.parse(json["last_updated_data"]),
        league: League.fromJson(json["league"]),
        standings: NewEntries.fromJson(json["standings"]),
    );

    Map<String, dynamic> toJson() => {
        "new_entries": newEntries.toJson(),
        "last_updated_data": lastUpdatedData.toIso8601String(),
        "league": league.toJson(),
        "standings": standings.toJson(),
    };
}

class League {
    int id;
    String name;
    DateTime created;
    bool closed;
    dynamic maxEntries;
    String leagueType;
    String scoring;
    int adminEntry;
    int startEvent;
    String codePrivacy;
    bool hasCup;
    dynamic cupLeague;
    dynamic rank;

    League({
        required this.id,
        required this.name,
        required this.created,
        required this.closed,
        required this.maxEntries,
        required this.leagueType,
        required this.scoring,
        required this.adminEntry,
        required this.startEvent,
        required this.codePrivacy,
        required this.hasCup,
        required this.cupLeague,
        required this.rank,
    });

    factory League.fromJson(Map<String, dynamic> json) => League(
        id: json["id"],
        name: json["name"],
        created: DateTime.parse(json["created"]),
        closed: json["closed"],
        maxEntries: json["max_entries"] ?? 0,
        leagueType: json["league_type"],
        scoring: json["scoring"],
        adminEntry: json["admin_entry"],
        startEvent: json["start_event"],
        codePrivacy: json["code_privacy"],
        hasCup: json["has_cup"],
        cupLeague: json["cup_league"] ?? 0,
        rank: json["rank"] ?? 0,
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "created": created.toIso8601String(),
        "closed": closed,
        "max_entries": maxEntries,
        "league_type": leagueType,
        "scoring": scoring,
        "admin_entry": adminEntry,
        "start_event": startEvent,
        "code_privacy": codePrivacy,
        "has_cup": hasCup,
        "cup_league": cupLeague,
        "rank": rank,
    };
}

class NewEntries {
    bool hasNext;
    int page;
    List<Result> results;

    NewEntries({
        required this.hasNext,
        required this.page,
        required this.results,
    });

    factory NewEntries.fromJson(Map<String, dynamic> json) => NewEntries(
        hasNext: json["has_next"],
        page: json["page"],
        results: List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "has_next": hasNext,
        "page": page,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
    };
}

class Result {
    int id;
    int eventTotal;
    String playerName;
    int rank;
    int lastRank;
    int rankSort;
    int total;
    int entry;
    String entryName;

    Result({
        required this.id,
        required this.eventTotal,
        required this.playerName,
        required this.rank,
        required this.lastRank,
        required this.rankSort,
        required this.total,
        required this.entry,
        required this.entryName,
    });

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        eventTotal: json["event_total"],
        playerName: json["player_name"],
        rank: json["rank"],
        lastRank: json["last_rank"],
        rankSort: json["rank_sort"],
        total: json["total"],
        entry: json["entry"],
        entryName: json["entry_name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "event_total": eventTotal,
        "player_name": playerName,
        "rank": rank,
        "last_rank": lastRank,
        "rank_sort": rankSort,
        "total": total,
        "entry": entry,
        "entry_name": entryName,
    };
}
