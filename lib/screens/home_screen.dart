import 'package:fantasypl/model/league_model.dart';
import 'package:fantasypl/provider/fpl_provider.dart';
import 'package:fantasypl/screens/team_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/constatnts.dart';
import '../widget/shimmer_widget.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref ) {
    final leagueData = ref.watch(leagueDataProvider);
    final bootstrapData = ref.watch(bootsrapDataProvider);
    final sortData = ref.watch(sortProvider);
    return Scaffold(
      backgroundColor: dark,
      appBar: _buildAppbar(ref, context),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(const Duration(seconds: 1));
            return ref.refresh(leagueDataProvider);
          },
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: Center(child: Text("Players", style: subtitleStyle )) 
                    ),
                    Expanded(
                      flex: 1,
                      child: Text("Gw Point", style: subtitleStyle, maxLines: 2, textAlign: TextAlign.center, ) 
                    ),
                    Expanded(
                      flex: 1,
                      child: Text("Total Point", style: subtitleStyle, maxLines: 2, textAlign: TextAlign.center,  ),
                    ),
                  ],
                ),
                bootstrapData.when(
                  data: (data1) {
                    return leagueData.when(
                      skipLoadingOnRefresh: false,
                      data: (data) {
                        final totalPoint = data.standings.results;
                        final List<Result> sortGwPoint = List.from(totalPoint);
                        sortGwPoint.sort((a, b) => b.eventTotal.compareTo(a.eventTotal));
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: sortData == 'gwpoints'? sortGwPoint.length : totalPoint.length,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: CircleAvatar(backgroundColor: primary, child: Text(sortData == 'gwpoints'? '${index+1}' : totalPoint[index].rank.toString(),style: titleStyle, ) ),
                              title: Text(sortData == 'gwpoints'? sortGwPoint[index].entryName.replaceAll("ï¿½", "�") : totalPoint[index].entryName.replaceAll("ï¿½", "�"),style: titleStyle, ),
                              subtitle: Text(sortData == 'gwpoints'? sortGwPoint[index].playerName : totalPoint[index].playerName, style: subtitleStyle, ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(sortData == 'gwpoints'? sortGwPoint[index].eventTotal.toString() : totalPoint[index].eventTotal.toString(),style: titleStyle),
                                  const SizedBox(
                                    width: 25,
                                  ),
                                  Text(sortData == 'gwpoints'? sortGwPoint[index].total.toString() : totalPoint[index].total.toString(), style: titleStyle),
                                ],
                              ),
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => 
                                  TeamScreen(
                                    teamId: sortData == 'gwpoints'? sortGwPoint[index].entry : totalPoint[index].entry,
                                    gw: data1.events!.where((element) => element.isCurrent == true).map((e) => e.id).toList().first!.toInt(),
                                    result: sortData == 'gwpoints'? sortGwPoint[index] : totalPoint[index],
                                  ),)
                                );
                              },
                            );
                          },
                        );
                      },
                      error: (error, stackTrace) {
                        return const Text("Error Occured");
                      }, 
                      loading: () => const ShimmerWidget()
                    );
                  }, 
                  error: (error, stackTrace) {
                    return const Text("Error Occured");
                  }, 
                  loading: () => const ShimmerWidget()
                )
                ],
            ),
          ),
        )
      )
    );
  }
  
  _buildAppbar(WidgetRef ref,BuildContext context) {
    final leagueData = ref.watch(leagueDataProvider);
    return 
      AppBar(
        backgroundColor: primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
        ),
        centerTitle: true,
        title: leagueData.when(
          data: (data) => Text(data.league.name.toString(),style: titleStyle.copyWith(fontWeight: FontWeight.bold), ),
          error: (error, stackTrace) => const Text(""),
          loading: () => const Text("....."),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: dark.withOpacity(0.8),
                  elevation: 10,
                  shadowColor: white.withOpacity(0.5),
                  title: Text("Sort by :", style: titleStyle,),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        onTap: () {
                          ref.read(sortProvider.notifier).isGwpoints();
                          Navigator.pop(context);
                          return ref.refresh(leagueDataProvider);
                        },
                        title: Text("Latest Gw Points", style: subtitleStyle,),
                      ),
                      ListTile(
                        onTap: () {
                          ref.read(sortProvider.notifier).isTotalpoints();
                          Navigator.pop(context);
                          return ref.refresh(leagueDataProvider);
                        },
                        title: Text("Total Points", style: subtitleStyle,),
                      ),
                    ],
                  ),
                ),
              );
            },
            icon: const Icon(Icons.sort_rounded,color: white, )
          )

        ],
      );
  }
}

