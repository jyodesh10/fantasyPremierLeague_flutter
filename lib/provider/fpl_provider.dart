

import 'package:fantasypl/model/league_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuple/tuple.dart';
import '../model/bootstrap_model.dart';
import '../model/picks_model.dart';
import '../repo/fpl_api.dart';

final leagueDataProvider = FutureProvider<LeagueModel>((ref) => ref.watch(fplProvider).fetchLeague());
final bootsrapDataProvider = FutureProvider<BootStrapModel>((ref) => ref.watch(fplProvider).fetchBootstrapData());
final teamPicksDataProvider = FutureProvider.autoDispose.family<PicksModel,Tuple2 >((ref,arg) => ref.watch(fplProvider).fetchTeamPicks(arg.item1,arg.item2));

final sortProvider = StateNotifierProvider<SortNotifier,String>((ref) {
  return SortNotifier();
});

class SortNotifier extends StateNotifier<String> {
  SortNotifier(): super('totalpoints');

  void isGwpoints() => state = 'gwpoints';
  void isTotalpoints() => state = 'totalpoints';
}