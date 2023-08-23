

import 'package:fantasypl/model/bootstrap_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuple/tuple.dart';

import '../constants/constatnts.dart';
import '../model/league_model.dart';
import '../model/picks_model.dart';
import '../provider/fpl_provider.dart';
import '../widget/shimmer_widget.dart';

class TeamScreen extends ConsumerWidget {
  const TeamScreen( {super.key,required this.teamId,required this.gw,required this.result,});

  final int teamId;
  final int gw;
  final Result result;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final picksdata = ref.watch(teamPicksDataProvider(Tuple2(teamId, gw)));
    final bootstrapdata = ref.watch(bootsrapDataProvider);
    List<Teams> teams = [];
    List playercode = [];
    return Scaffold(
      backgroundColor: dark,
      appBar: _buildAppbar(),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(const Duration(seconds: 1));
            return ref.refresh(teamPicksDataProvider(Tuple2(teamId, gw)));
          },
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                bootstrapdata.when(
                  data: (firstdata) {
                    for(int i = 0 ; i < firstdata.teams!.length; i ++){
                      teams.add(firstdata.teams![i]);
                    }
                    return picksdata.when(
                      skipLoadingOnRefresh: false,
                      data: (seconddata) {
                        for(int i = 0 ; i < seconddata.picks.length; i ++){
                          playercode.add(firstdata.elements!.where((element) => element.id==seconddata.picks[i].element).map((e) => "${e.teamCode}").join(", "));
                        }
                        return Column(
                          children: [
                            seconddata.activeChip != null
                              ? Text("${seconddata.activeChip} Activated",style: titleStyle, )
                              : Container(),
                            _buildTopDetail(seconddata),
                            _buildLabel(),
                            _buildPlayerTile(seconddata, firstdata, teams, playercode)
                          ],
                        );
                      }, 
                      error: (error, stackTrace) => const Text("Error Occured"), 
                      loading: () => const ShimmerWidget()
                    );
                  }, 
                  error: (error, stackTrace) => const Text("Error Occured"), 
                  loading: () => const ShimmerWidget()
                )
              ],
            ),
          ),
        ),  
      ),
    );
  }

  _buildAppbar() {
    return 
      AppBar(
        backgroundColor: primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
        ),
        centerTitle: true,
        title: Text(result.playerName.toString(),style: titleStyle.copyWith(fontWeight: FontWeight.bold),),
      );
  }
  
  _buildTopDetail(PicksModel pickdata) {
    return Container(
      margin: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: primary,
                width: 2
              )
            ),
            child: Center(
              child: Column(
                children: [
                  Text(pickdata.entryHistory['event_transfers']!.toInt() > 1 ? "${result.eventTotal-pickdata.entryHistory['event_transfers_cost']!.toInt()}" : result.eventTotal.toString(),style: titleStyle.copyWith(fontWeight: FontWeight.bold),),
                  const SizedBox(
                    width: 10,
                  ),
                  Text("Points",style: subtitleStyle.copyWith(fontWeight: FontWeight.bold),),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: primary,
                width: 2
              )
            ),
            child: Center(
              child: Column(
                children: [
                  Text("${pickdata.entryHistory['event_transfers']}${pickdata.entryHistory['event_transfers']!.toInt() > 1 ? "(-${pickdata.entryHistory['event_transfers_cost']} pts)" : "" }",style: titleStyle.copyWith(fontWeight: FontWeight.bold),),
                  const SizedBox(
                    width: 10,
                  ),
                  Text("Transfers",style: subtitleStyle.copyWith(fontWeight: FontWeight.bold),),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  _buildLabel() {
    return Row(
      children: [
        Expanded(flex: 4, child: Center(child: Container(height: 2, margin: const EdgeInsets.only(left: 20), color: white,))),
        Expanded(
          flex: 2,
          child: Center(child: Text("Players",style: subtitleStyle,))
        ),
        Expanded(flex: 4, child: Center(child: Container(height: 2,  color: white,))),
        Expanded(
          flex: 2,
          child: Center(child: Text("Points",style: subtitleStyle,))
        ),
        Expanded(flex: 1, child: Center(child: Container(height: 2, margin: const EdgeInsets.only(right: 20), color: white,))),
      ],
    );
  }
  
  _buildPlayerTile(PicksModel seconddata,BootStrapModel  firstdata,List<Teams> teams,List<dynamic> playercode) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: seconddata.picks.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            index == 11
              ? Row(
                // mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(flex: 1, child: Center(child: Container(height: 2, margin: const EdgeInsets.only(left: 20), color: white,))),
                  Expanded(flex: 2, child: Center(child: Text("Substitutes", style: subtitleStyle, ))),
                  Expanded(flex: 5, child: Center(child: Container(height: 2, margin: const EdgeInsets.only(right: 20), color: white,)))
                ],
              )
              : Container(),
            ListTile(
              leading: CircleAvatar(backgroundColor: primary, child:Text(seconddata.picks[index].position.toString(),style: titleStyle,)),
              title: Row(
                children: [
                  Text(firstdata.elements!.where((element) => element.id==seconddata.picks[index].element).map((e) => "${e.webName}").join(", "),style: titleStyle),
                  seconddata.picks[index].isCaptain
                    ? Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: CircleAvatar(
                        radius: 15,
                        backgroundColor: white,
                        child: Text("C", style: titleStyle.copyWith(color: black, fontWeight: FontWeight.bold),),
                      ),
                    )
                    : seconddata.picks[index].isViceCaptain
                      ? Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: CircleAvatar(
                          radius: 15,
                          backgroundColor: white,
                          child: Text("V", style: titleStyle.copyWith(color: black, fontWeight: FontWeight.bold),),
                        ),
                      )
                      : Container()
                ],
              ),
              subtitle: Text(teams.firstWhere((element) => element.code.toString() == playercode[index]).shortName.toString(),style: subtitleStyle, ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(firstdata.elements!.where((element) => element.id==seconddata.picks[index].element).map((e) => "${ seconddata.picks[index].isCaptain? e.eventPoints!*2 :e.eventPoints}").join(", "),style: titleStyle, ),
                  const SizedBox(
                    width: 25,
                  )
                ],
              ),
            ),
          ],
        ); 
      }
    );
  }
}