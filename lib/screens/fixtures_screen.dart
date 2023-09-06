import 'package:fantasypl/screens/standing_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
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
  int nowGw = 0;
  List<List<FixtureModel>> gwFixtures = [];
  List<DateTime> dates= [];
  final CarouselController _carouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    final bootstrapData = ref.watch(bootsrapDataProvider);
    final fixtureData = ref.watch(fixtureDataProvider);
    final currentGwData = ref.watch(currentGWProvider);
    return Scaffold(
      backgroundColor: dark,
      appBar: CustomAppbar(
        title: Text("Fixtures",style: titleStyle.copyWith(color: dark, fontWeight: FontWeight.bold),),
        sufixWidget: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Row(
            children: [
              TextButton(
                onPressed: (){
                  ref.read(currentGWProvider.notifier).getcurrentGw(nowGw-1);
                  _carouselController.animateToPage(nowGw-1);
                }, 
                child: Text("Current GW", style: subtitleStyle.copyWith(color: dark), )),
              bootstrapData.when(
                data: (data) => IconButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => StandingScreen(gw: data.events!.where((element) => element.isNext == true).map((e) => e.id).first!.toInt()-1), ));
                  }, 
                  icon: const Icon(Icons.bar_chart)
                ), 
                error: (error, stackTrace) => Container(), 
                loading: () => Shimmer.fromColors(baseColor: baseColor, highlightColor: highlightColor, child: const CircleAvatar(radius: 12)),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () { return ref.refresh(fixtureDataProvider);},child: const Icon(Icons.refresh_outlined), ),
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
                nowGw = firstdata.events!.where((element) => element.isNext == true).map((e) => e.id).first!.toInt();
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
                        _buildCarousel(currentGwData),
                        // Text("Gameweek $currentGw",style: titleStyle, ),
                        const SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onHorizontalDragEnd: (DragEndDetails details) {
                            if (details.primaryVelocity! > 0) {
                              if(currentGw != 1 ){
                                ref.read(currentGWProvider.notifier).getcurrentGw(currentGw - 1);
                                _carouselController.previousPage(
                                  curve: Curves.linearToEaseOut
                                );
                              }
                            } else if (details.primaryVelocity! < 0) {
                              if(currentGw != 38){
                                ref.read(currentGWProvider.notifier).getcurrentGw(currentGw + 1);
                                _carouselController.nextPage(
                                  curve: Curves.linearToEaseOut
                                );
                              }
                            }
                          },
                          child: Column(
                            children: List.generate(
                              seconddata.where((element) => element.event == currentGw).length,
                              (index) => _buildTeamContainer(firstdata, seconddata.where((element) => element.event == currentGw).toList(), index)
                            )
                          ),
                        )
                      ],
                    );
                  }, 
                  error: (error, stackTrace) {
                    return  Text(error.toString(),style: titleStyle);
                  }, 
                  loading: () => const FixtureShimmerWidget()
                );
              },
              error: (error, stackTrace) {
                return  Text(error.toString(),style: titleStyle);
              }, 
              loading: () => const FixtureShimmerWidget()
            ),
          ),
        ) 
      ),
    );
  }

  _buildCarousel(currentGwData) {
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
        carouselController: _carouselController,
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
        GestureDetector(
          onTap: () {
            showbottomsheet(firstdata, seconddata, index);
          },
          child: Container(
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
                      Text(firstdata.teams!.firstWhere((element) => element.id == seconddata[index].teamH).name.toString(), style: subtitleStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 12 ),),
                      const SizedBox(
                        width: 10,
                      ),
                      Image.network("https://resources.premierleague.com/premierleague/badges/t${firstdata.teams!.firstWhere((element) => element.id == seconddata[index].teamH).code}.png",
                        loadingBuilder: (context, child, loadingProgress) => loadingProgress==null ? child : const TeamImageShimmerWidget(),
                        errorBuilder: (context, error, stackTrace) => Image.asset("assets/logo.png",height: 80,width: 60,color: Colors.grey, colorBlendMode: BlendMode.darken,),
                        height: 30,
                        width: 30,
                      ),
                      const SizedBox(width: 10,)
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
                      Image.network("https://resources.premierleague.com/premierleague/badges/t${firstdata.teams!.firstWhere((element) => element.id == seconddata[index].teamA).code}.png",
                        loadingBuilder: (context, child, loadingProgress) => loadingProgress==null ? child : const TeamImageShimmerWidget(),
                        errorBuilder: (context, error, stackTrace) => Image.asset("assets/logo.png",height: 80,width: 60,color: Colors.grey, colorBlendMode: BlendMode.darken,),
                        height: 30,
                        width: 30,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(firstdata.teams!.firstWhere((element) => element.id == seconddata[index].teamA).name.toString(), style: subtitleStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 12),),
                    ],
                  ),
                ),
                
              ],
            ),
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
  
  void showbottomsheet(BootStrapModel firstdata, List<FixtureModel> seconddata, index) {
    showModalBottomSheet(
      context: context, 
      elevation: 5,
      isScrollControlled: true,
      useSafeArea: false,
      backgroundColor: dark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      builder: (context) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  width: 100,
                  height: 3,
                  color: white,
                ),
                const SizedBox(
                  height: 10,
                ),
                seconddata[index].stats.isNotEmpty 
                  ? ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: seconddata[index].stats.length,
                    itemBuilder: (context, statsindex) => Column(
                      children: [
                        seconddata[index].stats[statsindex].a.isNotEmpty || seconddata[index].stats[statsindex].h.isNotEmpty
                          ? 
                          Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            color: white.withOpacity(0.2),
                            child: Text(seconddata[index].stats[statsindex].identifier.replaceAll(RegExp(r'_'), ' ').toUpperCase(), style: subtitleStyle.copyWith(fontWeight: FontWeight.bold))
                          )
                          : Container(),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: List.generate(
                                  seconddata[index].stats[statsindex].identifier == "bps" 
                                    ? 5
                                    : seconddata[index].stats[statsindex].h.length, (hindex) => 
                                  Text(
                                    "${firstdata.elements!.firstWhere((element) => element.id == seconddata[index].stats[statsindex].h[hindex].element).webName}${seconddata[index].stats[statsindex].h[hindex].value == 1 ? "" : "(${seconddata[index].stats[statsindex].h[hindex].value.toString()})"}", style: subtitleStyle, )
                                )
                              )
                            ),
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: List.generate(
                                  seconddata[index].stats[statsindex].identifier == "bps" 
                                    ? 5
                                    : seconddata[index].stats[statsindex].a.length , (aindex) => 
                                  Text("${firstdata.elements!.firstWhere((element) => element.id==seconddata[index].stats[statsindex].a[aindex].element ).webName}${seconddata[index].stats[statsindex].a[aindex].value == 1 ? "" : "(${seconddata[index].stats[statsindex].a[aindex].value})"}", style: subtitleStyle, )
                                )
                              )
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                  : Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          color: white.withOpacity(0.2),
                          child: 
                          Row(
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
                  )
              ],
            ),
          ),
        );
      }, 
    );
  }

}