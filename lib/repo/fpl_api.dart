import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../constants/constants.dart';
import '../model/bootstrap_model.dart';
import '../model/fixture_model.dart';
import '../model/history_model.dart';
import '../model/league_model.dart';
import '../model/picks_model.dart';
import '../model/player_model.dart';
import '../model/transfer_model.dart';


class FplApi{
  Future<BootStrapModel> fetchBootstrapData() async {
    final response = await http.get(Uri.parse('$base/bootstrap-static/'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return BootStrapModel.fromJson(data);
    } else {
      throw Exception('Failed to fetch bootstrap data');
    }
  }
  
  Future<LeagueModel> fetchLeague() async {
    final response = await http.get(Uri.parse('$base/leagues-classic/679963/standings/'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return LeagueModel.fromJson(data);
    } else {
      throw Exception('Failed to fetch league');
    }
  }

  Future<PicksModel> fetchTeamPicks(int teamId, int gw) async {
    final response = await http.get(Uri.parse('$base/entry/$teamId/event/$gw/picks/'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return PicksModel.fromJson(data);
    } else {
      throw Exception('Failed to fetch team picks');
    }
  }

  Future<HistoryModel> fetchHistory(int teamId) async {
    final response = await http.get(Uri.parse('$base/entry/$teamId/history/'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return HistoryModel.fromJson(data);
    } else {
      throw Exception('Failed to fetch history');
    }
  }

  Future<List<TransferModel>> fetchTransfer(int teamId) async {
    final response = await http.get(Uri.parse('$base/entry/$teamId/transfers/'));
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => TransferModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch transfer');
    }
  }

  Future<PlayerModel> fetchPlayer(int teamId) async {
    final response = await http.get(Uri.parse('$base/entry/$teamId/'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return PlayerModel.fromJson(data);
    } else {
      throw Exception('Failed to fetch player');
    }
  }

  Future<List<FixtureModel>> fetchFixtures() async {
    final response = await http.get(Uri.parse('$base/fixtures/'));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => FixtureModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch fixture');
    }
  }

}

final fplProvider = Provider<FplApi>((ref) => FplApi());