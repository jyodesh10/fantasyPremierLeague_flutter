import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../constants/constatnts.dart';
import '../model/bootstrap_model.dart';
import '../model/league_model.dart';
import '../model/picks_model.dart';


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

}

final fplProvider = Provider<FplApi>((ref) => FplApi());