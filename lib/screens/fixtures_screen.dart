import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:intl/intl.dart';
import '../constants/constants.dart';
import '../model/bootstrap_model.dart';
import '../model/fixture_model.dart';
import '../provider/fpl_provider.dart';
import '../widget/custom_appbar.dart';
import '../widget/shimmer_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';
class FixturesScreen extends ConsumerStatefulWidget {
  const FixturesScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FixturesScreenState();
}

class _FixturesScreenState extends ConsumerState<FixturesScreen> {


  int currentGw = 0;
  List<List<FixtureModel>> gwFixtures = [];
  List<DateTime> dates= [];

  @override
  Widget build(BuildContext context) {
    final bootstrapData = ref.watch(bootsrapDataProvider);
    final fixtureData = ref.watch(fixtureDataProvider);
    final currentGwData = ref.watch(currentGWProvider);
    return Scaffold(
      backgroundColor: dark,
      appBar: CustomAppbar(title: Text("Fixtures",style: titleStyle.copyWith(color: dark, fontWeight: FontWeight.bold), ),),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(const Duration(seconds: 1));
            return ref.refresh(fixtureDataProvider);
          },
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: bootstrapData.when(
              data: (firstdata) {
                // ref.read(currentGWProvider.notifier).getcurrentGw(firstdata.events!.where((element) => element.isNext == true).map((e) => e.id).first!.toInt());
                currentGw = currentGwData != 0 ? currentGwData : firstdata.events!.where((element) => element.isNext == true).map((e) => e.id).first!.toInt();
                return fixtureData.when(
                  skipLoadingOnRefresh: false,
                  data: (seconddata) {
                    List<DateTime> alldates = [];
                    for (var i = 0; i < seconddata.length; i++) {
                      if (seconddata[i].event == currentGw) {
                        alldates.add(seconddata[i].kickoffTime);
                      }
                    }
                    dates = removeSameDayDuplicates(alldates);
                    return Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        _buildCarousel(),
                        // Text("Gameweek $currentGw",style: titleStyle, ),
                        const SizedBox(
                          height: 10,
                        ),
                        ...List.generate(
                          seconddata.where((element) => element.event == currentGw).length,
                          (index) => _buildTeamContainer(firstdata, seconddata.where((element) => element.event == currentGw).toList(), index)
                        )
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
          ),
        ) 
      ),
    );
  }

  _buildCarousel() {
    return Container(    
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.transparent,
        gradient: LinearGradient(
          colors: [dark.withOpacity(0.6),Colors.transparent, dark.withOpacity(0.6)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: const [0.1,0.5,0.9]
        )
      ),
      child: CarouselSlider(
        items: List.generate(38, (index) => 
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: index +1 == currentGw 
                ? const GradientBoxBorder(
                  gradient: LinearGradient(colors: [torquise, primary]),
                  width: 1.6
                )
                : Border.all(width: 0)
            ),
            child: Text("Gameweek ${index + 1}",style: titleStyle,)
          ),
        ), 
        options: CarouselOptions(
          reverse: false,
          height: 50,
          viewportFraction: 0.4,
          enableInfiniteScroll: false,
          initialPage: currentGw - 1,
          enlargeCenterPage: true,
          onPageChanged: (index, reason) {
            ref.read(currentGWProvider.notifier).getcurrentGw(index + 1);
            // return ref.refresh(fixtureDataProvider);
          },
        )
      ),
    );
  }

  int? previousDay;

  _buildTeamContainer(BootStrapModel firstdata, List<FixtureModel> seconddata, int index) {
    DateTime currentDate = seconddata[index].kickoffTime.toLocal();
    int currentDay = currentDate.day;
    bool showDate = previousDay == null || previousDay != currentDay;
    previousDay = currentDay;
    return Column(
      children: [
      if (showDate)
        Text(
          DateFormat.MMMMEEEEd().format(currentDate),
          style: titleStyle,
        ),
        Container(
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
                    Text(firstdata.teams!.firstWhere((element) => element.id == seconddata[index].teamH).name.toString(), style: subtitleStyle.copyWith(fontWeight: FontWeight.bold),),
                    const SizedBox(
                      width: 10,
                    )
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
                  child: seconddata[index].teamHScore == -1 && seconddata[index].teamAScore == -1
                    ? Text(DateFormat.jm().format(seconddata[index].kickoffTime.toLocal()),style: subtitleStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 14,), )
                    : Text("${seconddata[index].teamHScore} - ${seconddata[index].teamAScore}",style: subtitleStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 14,), )
                ) 
              ),
              Expanded(
                flex: 5,
                child: Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    Text(firstdata.teams!.firstWhere((element) => element.id == seconddata[index].teamA).name.toString(), style: subtitleStyle.copyWith(fontWeight: FontWeight.bold),),
                  ],
                ),
              ),
              
            ],
          ),
        ),
      ],
    );
  }
  removeSameDayDuplicates(List<DateTime> dateList) {
    Map<String, DateTime> uniqueDates = {};

    for (var date in dateList) {
      String dateString = DateFormat('yyyy-MM-dd').format(date);

      if (!uniqueDates.containsKey(dateString)) {
        uniqueDates[dateString] = date;
      }
    }

    return uniqueDates.values.toList();
  }

}