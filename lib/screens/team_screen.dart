

import 'package:fantasypl/model/bootstrap_model.dart';
import 'package:fantasypl/widget/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuple/tuple.dart';
import 'package:gradient_borders/gradient_borders.dart';
import '../constants/constants.dart';
import '../model/history_model.dart';
import '../model/league_model.dart';
import '../model/picks_model.dart';
import '../model/transfer_model.dart';
import '../provider/fpl_provider.dart';
import '../widget/shimmer_widget.dart';

class TeamScreen extends ConsumerWidget {
  TeamScreen( {super.key,required this.teamId,required this.gw,required this.result,});

  final int teamId;
  final int gw;
  final Result result;
  List<Elements> allplayers = [];
  List<Elements> goalkeepers = [];
  List<Elements> defenders = [];
  List<Elements> midfielders = [];
  List<Elements> forwards = [];
  List<Elements> bench = [];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final picksdata = ref.watch(teamPicksDataProvider(Tuple2(teamId, gw)));
    final bootstrapdata = ref.watch(bootsrapDataProvider);
    final historydata = ref.watch(historyDataProvider(teamId));
    final transferdata = ref.watch(transferDataProvider(teamId));
    final playerdata = ref.watch(playerDataProvider(teamId));
    List<Teams> teams = [];
    List playercode = [];
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: dark,
        appBar: _buildAppbar(context),
        body: SafeArea(
          child: Column(
            children: [
              TabBar(
                labelColor: white,
                labelStyle: subtitleStyle.copyWith(fontWeight: FontWeight.bold),
                unselectedLabelStyle: subtitleStyle,
                unselectedLabelColor: white,
                indicatorColor: lightgreen,
                dividerColor: dark, 
                tabs: const [
                  Tab(
                    text: "Points",
                  ),
                  Tab(
                    text: "Details",
                  ),
                ]
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildPointTab(ref, bootstrapdata, teams, picksdata, playercode),
                    _buildDetailTab(ref, bootstrapdata, historydata, transferdata)
                  ]
                )

              ),
            ],
          ),  
        ),
      ),
    );
  }

  _buildAppbar(context) {
    return CustomAppbar(
      title: Text(result.playerName.toString(),style: titleStyle.copyWith(color: dark, fontWeight: FontWeight.bold),) ,
      prefixWidget: IconButton(onPressed: () { Navigator.pop(context); }, icon: const Icon(Icons.arrow_back_ios_new_rounded, color: dark, )),
    );
  }

  _buildPointTab(WidgetRef ref, AsyncValue<BootStrapModel> bootstrapdata, List<Teams> teams, AsyncValue<PicksModel> picksdata, List<dynamic> playercode) {
    return RefreshIndicator(
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
                    goalkeepers.clear();
                    defenders.clear();
                    midfielders.clear();
                    forwards.clear();
                    bench.clear();
                    for(int i = 0 ; i < firstdata.elements!.length ; i ++){
                      for(int j = 0 ; j < seconddata.picks.length; j ++){
                        playercode.add(firstdata.elements!.where((element) => element.id==seconddata.picks[j].element).map((e) => "${e.teamCode}").join(", "));
                        if(firstdata.elements![i].elementType==1 && firstdata.elements![i].id == seconddata.picks[j].element){
                          goalkeepers.add(firstdata.elements![i]);
                        }
                        if(firstdata.elements![i].elementType==2 && firstdata.elements![i].id == seconddata.picks[j].element){
                          defenders.add(firstdata.elements![i]);
                        }
                        if(firstdata.elements![i].elementType==3 && firstdata.elements![i].id == seconddata.picks[j].element){
                          midfielders.add(firstdata.elements![i]);
                        }
                        if(firstdata.elements![i].elementType==4 && firstdata.elements![i].id == seconddata.picks[j].element){
                          forwards.add(firstdata.elements![i]);
                        }
                      }
                    }
                    for(int j = 0 ; j < seconddata.picks.length; j ++){
                      if (j != 11 && j != 12 && j != 13 && j != 14) {
                        bench.addAll(firstdata.elements!.where((element) => element.id==seconddata.picks[j].element).map((e) => e));
                      }
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
                  error: (error, stackTrace) =>  Text("Error Occured",style: titleStyle,), 
                  loading: () => const ShimmerWidget()
                );
              }, 
              error: (error, stackTrace) =>  Text("Error Occured",style: titleStyle,), 
              loading: () => const ShimmerWidget()
            )
          ],
        ),
      ),
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
              border: const GradientBoxBorder(
                gradient: LinearGradient(colors: [torquise, primary]),
                width: 2
              ),
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
              border: const GradientBoxBorder(
                gradient: LinearGradient(colors: [torquise, primary]),
                width: 2
              ),
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
    return Column(
      children: [
        _buildPlayerContainer(
          goalkeepers.firstWhere((element) => element.id == seconddata.picks[0].element ).code, 
          goalkeepers.firstWhere((element) => element.id == seconddata.picks[0].element ).webName, 
          goalkeepers.firstWhere((element) => element.id == seconddata.picks[0].element ).eventPoints
        ),
        //defenders
        Wrap(
          runSpacing: 10,
          spacing: 10,
          children: List.generate(defenders.length , (index) => 
            bench.contains(defenders[index])
              ? _buildPlayerContainer(defenders[index].code, defenders[index].webName, defenders[index].eventPoints)
              : Container(),
          )
        ),
        //Mids
        Wrap(
          runSpacing: 10,
          spacing: 10,
          children: List.generate(midfielders.length , (index) => 
            bench.contains(midfielders[index])
              ? _buildPlayerContainer(midfielders[index].code, midfielders[index].webName, midfielders[index].eventPoints)
              : Container()
          ),
        ),
        //Forwards
        Wrap(
          runSpacing: 10,
          spacing: 10,
          children: List.generate(forwards.length , (index) => 
            bench.contains(forwards[index])
              ? _buildPlayerContainer(forwards[index].code, forwards[index].webName, forwards[index].eventPoints)
              : Container()
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        //subs
        Row(
          // mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(flex: 1, child: Center(child: Container(height: 2, margin: const EdgeInsets.only(left: 20), color: white,))),
            Expanded(flex: 2, child: Center(child: Text("Bench", style: subtitleStyle, ))),
            Expanded(flex: 5, child: Center(child: Container(height: 2, margin: const EdgeInsets.only(right: 20), color: white,)))
          ],
        ),
        Row(
          children: [
            const SizedBox(width: 10,),
            _buildPlayerContainer(
              goalkeepers.firstWhere((element) => element.id == seconddata.picks[11].element).code, 
              goalkeepers.firstWhere((element) => element.id == seconddata.picks[11].element).webName, 
              goalkeepers.firstWhere((element) => element.id == seconddata.picks[11].element).eventPoints
            ),
            const Spacer(),
            Wrap(
              spacing: 10,
              children: List.generate(3, (index) => 
                _buildPlayerContainer(
                  firstdata.elements!.firstWhere((element) => element.id == seconddata.picks[index==0? 12 : index==1? 13 : 14].element).code, 
                  firstdata.elements!.firstWhere((element) => element.id == seconddata.picks[index==0? 12 : index==1? 13 : 14].element).webName, 
                  firstdata.elements!.firstWhere((element) => element.id == seconddata.picks[index==0? 12 : index==1? 13 : 14].element).eventPoints,
                )
              ),
            ),
            const SizedBox(width: 10,),
          ],
        )
      ],
    ); 
  }

  _buildDetailTab(WidgetRef ref, AsyncValue<BootStrapModel> bootstrapdata, AsyncValue<HistoryModel> historydata, AsyncValue<List<TransferModel>> transferdata ) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            historydata.when(
              data: (data) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Current Season", style: titleStyle,),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        border: TableBorder.all(
                          color: white,
                          width: 1
                        ),
                        headingRowColor: MaterialStatePropertyAll(white.withOpacity(0.3)),
                        headingRowHeight: 40,
                        dataRowHeight: 40,
                        columns: <DataColumn>[
                          DataColumn(
                            tooltip: "Gameweek",
                            label: Expanded(
                              child: Text("GW", style: subtitleStyle.copyWith(fontWeight: FontWeight.bold))
                            ),
                          ),
                          DataColumn(
                            tooltip: "Points",
                            label: Expanded(
                              child: Text("Pts", style: subtitleStyle.copyWith(fontWeight: FontWeight.bold))
                            ),
                          ),
                          DataColumn(
                            tooltip: "Total Points",
                            label: Expanded(
                              child: Text("T.Pts", style: subtitleStyle.copyWith(fontWeight: FontWeight.bold))
                            ),
                          ),
                          DataColumn(
                            tooltip: "Rank",
                            label: Expanded(
                              child: Text("Rank", style: subtitleStyle.copyWith(fontWeight: FontWeight.bold))
                            ),
                          ),
                          DataColumn(
                            tooltip: "Overall Rank",
                            label: Expanded(
                              child: Text("O.R", style: subtitleStyle.copyWith(fontWeight: FontWeight.bold))
                            ),
                          ),
                          DataColumn(
                            tooltip: "Bank",
                            label: Expanded(
                              child: Text("Bank", style: subtitleStyle.copyWith(fontWeight: FontWeight.bold))
                            ),
                          ),
                          DataColumn(
                            tooltip: "Team Value",
                            label: Expanded(
                              child: Text("T.V", style: subtitleStyle.copyWith(fontWeight: FontWeight.bold))
                            ),
                          ),
                        ],
                        rows: <DataRow>[
                          ...List.generate(data.current.length, (index) =>
                            DataRow(
                              cells: <DataCell>[
                                DataCell(Text(data.current[index]['event'].toString(), style: subtitleStyle,)),
                                DataCell(Text(data.current[index]['points'].toString(), style: subtitleStyle)),
                                DataCell(Text(data.current[index]['total_points'].toString(), style: subtitleStyle)),
                                DataCell(Text(data.current[index]['rank'] ==null ? "---" : data.current[index]['rank'].toString(), style: subtitleStyle,)),
                                DataCell(Text(data.current[index]['overall_rank'].toString(), style: subtitleStyle)),
                                DataCell(Text(addDecimal(data.current[index]['bank'].toString()), style: subtitleStyle)),
                                DataCell(Text(addDecimal(data.current[index]['value'].toString()), style: subtitleStyle)),
                              ],
                            )
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 30,),
                    Text("Past Season", style: titleStyle,),
                    Table(
                      border: TableBorder.all(
                        color: white,
                        width: 1
                      ),
                      children: <TableRow>[
                        TableRow(
                          children: [
                            Container(
                              color: white.withOpacity(0.3),
                              padding: const EdgeInsets.all(12),
                              child: Text("Season", style: subtitleStyle.copyWith(fontWeight: FontWeight.bold))
                            ),
                            Container(
                              color: white.withOpacity(0.3),
                              padding: const EdgeInsets.all(12),
                              child: Text("Total Points", style: subtitleStyle.copyWith(fontWeight: FontWeight.bold))
                            ),
                            Container(
                              color: white.withOpacity(0.3),
                              padding: const EdgeInsets.all(12),
                              child: Text("Rank", style: subtitleStyle.copyWith(fontWeight: FontWeight.bold))
                            ),
                          ]
                        ),
                        ...List.generate(data.past.length, (index) =>
                          TableRow(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                child: Text(data.past[index].seasonName, style: subtitleStyle)
                              ),
                              Container(
                                padding: const EdgeInsets.all(12),
                                child: Text(data.past[index].totalPoints.toString(), style: subtitleStyle)
                              ),
                              Container(
                                padding: const EdgeInsets.all(12),
                                child: Text(data.past[index].rank.toString(), style: subtitleStyle)
                              ),
                            ]
                          ),
                        )
                      ],
                    )
                  ],
                );
              }, 
              error: (error, stackTrace) => Text(error.toString(),style: titleStyle,), 
              loading: () => const ShimmerWidget(),
            ),
            const SizedBox(height: 30,),
            bootstrapdata.when(
              data: (firstdata) {
                return transferdata.when(
                  data: (data) {
                    return Column(
                      children: [
                        Text("Gameweek $gw", style: titleStyle,),
                        const SizedBox(height: 10,),
                        Table(
                          border: TableBorder.all(
                            color: white,
                            width: 1
                          ),
                          children: [
                            TableRow(
                              children: [
                                Container(
                                  color: white.withOpacity(0.3),
                                  padding: const EdgeInsets.all(12),
                                  child: Text("IN", style: subtitleStyle.copyWith(fontWeight: FontWeight.bold))
                                ),
                                Container(
                                  color: white.withOpacity(0.3),
                                  padding: const EdgeInsets.all(12),
                                  child: Text("OUT", style: subtitleStyle.copyWith(fontWeight: FontWeight.bold))
                                ),
                              ]
                            ),
                            ...List.generate(data.length, (index) =>
                              TableRow(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    child: Text(
                                      firstdata.elements!.firstWhere((element) => element.id!.toInt()==data[index].elementIn ).webName.toString(), 
                                      style: subtitleStyle)
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    child: Text(
                                      firstdata.elements!.firstWhere((element) => element.id!.toInt()==data[index].elementOut).webName.toString(), 
                                      style: subtitleStyle)
                                  ),
                                ]
                              )
                            )
                          ],
                        ),
                      ],
                    );
                  }, 
                  error: (error, stackTrace) => Text(error.toString(),style: titleStyle, ), 
                  loading: () => const ShimmerWidget(),
                );
              }, 
              error: (error, stackTrace) => Text(error.toString(),style: titleStyle,), 
              loading: () => const ShimmerWidget(),
            )
          ],
        ),
      ),
    );
  }

  
  String addDecimal (str) {
    String originalNumberString = str;
    double originalNumber = double.parse(originalNumberString);

    double formattedNumber = originalNumber / 10;

    return formattedNumber.toStringAsFixed(1);
  }
  
  _buildPlayerContainer(imgCode,name,club) {
    return Column(
      children: [
        Image.network(
          "https://resources.premierleague.com/premierleague/photos/players/110x140/p$imgCode.png",
          loadingBuilder: (context, child, loadingProgress) => loadingProgress==null ? child : const ImageShimmerWidget(),
          errorBuilder: (context, error, stackTrace) => Image.asset("assets/logo.png",height: 80,width: 60,color: Colors.grey, colorBlendMode: BlendMode.darken,),
          height: 80,
          width: 60,
        ),
        Container(
          width: 70,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(8),topRight: Radius.circular(8)),
            color: Colors.grey.shade500,
          ),
          child:Center(child: Text("$name",style: subtitleStyle.copyWith(fontSize: 12.5, fontWeight: FontWeight.bold ),maxLines: 1, overflow: TextOverflow.ellipsis, )),
        ),
        Container(
          width: 70,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(8),bottomRight: Radius.circular(8)),
            color: Colors.grey.shade600,
          ),          
          child:Center(child: Text("$club",style: subtitleStyle,)),
        ),
      ],
    );
  }
}