

import 'package:fantasypl/model/league_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuple/tuple.dart';
import '../model/bootstrap_model.dart';
import '../model/fixture_model.dart';
import '../model/history_model.dart';
import '../model/picks_model.dart';
import '../model/player_model.dart';
import '../model/transfer_model.dart';
import '../repo/fpl_api.dart';

final leagueDataProvider = FutureProvider<LeagueModel>((ref) => ref.watch(fplProvider).fetchLeague());
final bootsrapDataProvider = FutureProvider<BootStrapModel>((ref) => ref.watch(fplProvider).fetchBootstrapData());
final teamPicksDataProvider = FutureProvider.autoDispose.family<PicksModel,Tuple2 >((ref,arg) => ref.watch(fplProvider).fetchTeamPicks(arg.item1,arg.item2));
final historyDataProvider = FutureProvider.autoDispose.family<HistoryModel,int>((ref,teamId) => ref.watch(fplProvider).fetchHistory(teamId));
final transferDataProvider = FutureProvider.autoDispose.family<List<TransferModel>,int>((ref,teamId) => ref.watch(fplProvider).fetchTransfer(teamId));
final playerDataProvider = FutureProvider.autoDispose.family<PlayerModel,int>((ref,teamId) => ref.watch(fplProvider).fetchPlayer(teamId));
final fixtureDataProvider = FutureProvider<List<FixtureModel>>((ref) => ref.watch(fplProvider).fetchFixtures());

final sortProvider = StateNotifierProvider<SortNotifier,String>((ref) {
  return SortNotifier();
});

class SortNotifier extends StateNotifier<String> {
  SortNotifier(): super('totalpoints');

  void isGwpoints() => state = 'gwpoints';
  void isTotalpoints() => state = 'totalpoints';
}