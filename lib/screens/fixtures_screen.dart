import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../constants/constants.dart';
import '../model/bootstrap_model.dart';
import '../model/fixture_model.dart';
import '../provider/fpl_provider.dart';
import '../widget/custom_appbar.dart';
import '../widget/shimmer_widget.dart';

class FixturesScreen extends ConsumerWidget {
  FixturesScreen({super.key});

  int currentGw = 0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bootstrapData = ref.watch(bootsrapDataProvider);
    final fixtureData = ref.watch(fixtureDataProvider);
    return Scaffold(
      backgroundColor: dark,
      appBar: CustomAppbar(title: Text("Fixtures",style: titleStyle.copyWith(color: dark, fontWeight: FontWeight.bold), ),),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: bootstrapData.when(
            data: (firstdata) {
              currentGw = firstdata.events!.where((element) => element.isNext == true).map((e) => e.id).first!.toInt();
              return fixtureData.when(
                data: (seconddata) {
                  return
                  Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Text("Gameweek $currentGw",style: titleStyle, ),
                      const SizedBox(
                        height: 10,
                      ),
                      ...List.generate(seconddata.where((element) => element.event == currentGw).length, (index) => _buildTeamContainer(firstdata, seconddata, index))
                    ],
                  );
                }, 
                error: (error, stackTrace) {
                  return  Text(error.toString(),style: titleStyle);
                }, 
                loading: () => const ShimmerWidget()
              );
            },
            error: (error, stackTrace) {
              return  Text(error.toString(),style: titleStyle);
            }, 
            loading: () => const ShimmerWidget()
          ),
        ) 
      ),
    );
  }
  
  _buildTeamContainer(BootStrapModel firstdata, List<FixtureModel> seconddata, int index) {
    List<FixtureModel> currentGwdata = seconddata.where((element) => element.event == currentGw).toList();
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
      padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 10),
      decoration: BoxDecoration(
        color: white.withOpacity(0.4),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(firstdata.teams!.firstWhere((element) => element.id == currentGwdata[index].teamH).name.toString(), style: subtitleStyle.copyWith(fontWeight: FontWeight.bold),),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: white.withOpacity(0.4),
                borderRadius: BorderRadius.circular(20)
              ),
              child: Text(DateFormat.jm().format(currentGwdata[index].kickoffTime.toLocal()),style: subtitleStyle.copyWith(fontWeight: FontWeight.bold), ),
            ) 
          ),
          Expanded(
            flex: 5,
            child: Row(
              children: [
                Text(firstdata.teams!.firstWhere((element) => element.id == currentGwdata[index].teamA).name.toString(), style: subtitleStyle.copyWith(fontWeight: FontWeight.bold),),
              ],
            ),
          ),
          
        ],
      ),
    );
  }
}