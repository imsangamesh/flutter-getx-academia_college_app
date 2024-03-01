import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newbie/core/constants/constants.dart';
import 'package:newbie/core/constants/pref_keys.dart';
import 'package:newbie/core/helpers/app_data.dart';
import 'package:newbie/core/themes/app_colors.dart';
import 'package:newbie/core/themes/app_text_styles.dart';
import 'package:newbie/core/utils/popup.dart';
import 'package:newbie/core/widgets/my_dropdown_wrapper.dart';
import 'package:newbie/data/college_data.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GraphRanges {
  int sem, marks;
  GraphRanges(this.sem, this.marks);
}

class ResultAnalyticss extends StatelessWidget {
  const ResultAnalyticss({Key? key}) : super(key: key);

  List<GraphRanges> cie1Mapper() => [
        GraphRanges(1, 30),
        GraphRanges(2, 50),
        GraphRanges(3, 20),
        GraphRanges(4, 35),
        GraphRanges(5, 45),
        GraphRanges(6, 15),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student Result Analytics')),
      body: Padding(
        padding: const EdgeInsets.only(top: 50, right: 10, left: 10),
        child: SizedBox(
          height: 400,
          child: SfCartesianChart(
            tooltipBehavior: TooltipBehavior(enable: true),
            margin: const EdgeInsets.only(right: 5),
            series: <ChartSeries>[
              LineSeries<GraphRanges, int>(
                enableTooltip: true,
                dataSource: cie1Mapper(),
                color: AppColors.prim,
                xValueMapper: (GraphRanges range, _) => range.sem,
                yValueMapper: (GraphRanges range, _) => range.marks,
                dataLabelSettings: const DataLabelSettings(isVisible: true),
                markerSettings: MarkerSettings(
                  isVisible: true,
                  borderWidth: 2,
                  width: 10,
                  borderColor: AppColors.prim,
                  color: AppColors.oppScaffold,
                  height: 10,
                ),
              ),
            ],
            primaryXAxis: CategoryAxis(
              edgeLabelPlacement: EdgeLabelPlacement.shift,
              axisLine: const AxisLine(color: Colors.transparent, width: 1),
              majorGridLines: const MajorGridLines(width: 0),
              majorTickLines: const MajorTickLines(width: 0),
            ),
            primaryYAxis: NumericAxis(
              axisLine: const AxisLine(color: Colors.transparent, width: 1),
              majorGridLines: const MajorGridLines(width: 0),
              majorTickLines: const MajorTickLines(width: 0),
              plotBands: const <PlotBand>[],
            ),
          ),
        ),
      ),
    );
  }
}

class ResultAnalytics extends StatefulWidget {
  const ResultAnalytics({super.key});

  @override
  State<ResultAnalytics> createState() => _ResultAnalyticsState();
}

class _ResultAnalyticsState extends State<ResultAnalytics> {
  //
  final usn = AppData.fetchData()['usn'];

  final semesters = RxList<String>();
  final selectedSem = ''.obs;
  final areSemsFetched = false.obs;

  final subjectsData = <String, dynamic>{}.obs;
  final subjectsGraphData = <String, List<GraphData>>{}.obs;

  /// ----------------------------------- `fetch Available SEMESTERS`
  Future<void> fetchSemesters() async {
    try {
      final resultSnap = await fire.collection(FireKeys.result).get();
      final sems = resultSnap.docs
          .where((each) => each.id.startsWith(usn))
          .map((each) => each.id.split('-').last)
          .toList();

      semesters(sems);
      selectedSem(sems.first);
      areSemsFetched(true);

      await fetchSubjectsForSelectedSem();
    } on FirebaseException catch (e) {
      Popup.alert(e.code, e.message.toString());
    } catch (e) {
      Popup.general();
    }
  }

  /// ----------------------------------- `fetch SUBJECTS for Selected_SEM`
  Future<void> fetchSubjectsForSelectedSem() async {
    try {
      final subSnap = await fire
          .collection(FireKeys.result)
          .doc('$usn-${selectedSem()}')
          .get();
      final subData = subSnap.data() ?? {};

      subjectsData(subData);
      configureGraphData();
    } on FirebaseException catch (e) {
      Popup.alert(e.code, e.message.toString());
    } catch (e) {
      Popup.general();
    }
  }

  /// ----------------------------------- `Configure to GRAPH DATA`
  void configureGraphData() {
    const examTypes = CollegeData.exams;
    final finalGraphData = <String, List<GraphData>>{};

    for (var eachType in examTypes) {
      final List<GraphData> dataList = [];

      for (var eachSub in subjectsData.entries) {
        dataList.add(GraphData(eachSub.key, eachSub.value[eachType] ?? 0.0));
      }

      finalGraphData[eachType] = dataList;
    }

    log('FINAL DATA: $finalGraphData');
    subjectsGraphData(finalGraphData);
  }

  @override
  void initState() {
    super.initState();
    fetchSemesters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Result Analytics'),
        actions: [
          IconButton(
            onPressed: fetchSemesters,
            icon: const Icon(Icons.circle),
          ),
        ],
      ),
      body: Obx(
        () => Padding(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                /// -------------------------------------- `semester`
                if (areSemsFetched())
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: MyDropDownWrapper(
                      DropdownButton(
                        dropdownColor: AppColors.listTile,
                        underline: MyDropDownWrapper.transparentDivider,
                        isExpanded: true,
                        iconSize: 30,
                        icon: const Icon(Icons.arrow_drop_down),
                        value: selectedSem(),
                        items: semesters
                            .map((String each) => DropdownMenuItem(
                                  value: each,
                                  child: Text(
                                    '  $each semester',
                                    style: selectedSem() == each
                                        ? AppTStyles.subHeading
                                        : null,
                                  ),
                                ))
                            .toList(),
                        onChanged: (String? newValue) async {
                          selectedSem(newValue!);
                          await fetchSubjectsForSelectedSem();
                        },
                      ),
                    ),
                  ),

                ...subjectsGraphData.entries
                    .map((e) => ResultAnalysisGraph(e.key, e.value))
                    .toList()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GraphData {
  final String label;
  final double value;

  GraphData(this.label, this.value);
}

class ResultAnalysisGraph extends StatelessWidget {
  const ResultAnalysisGraph(this.examType, this.graphData, {super.key});

  final String examType;
  final List<GraphData> graphData;

  double get maxYValue => examType == 'SEE'
      ? 100
      : examType == 'Assignment'
          ? 10
          : 20;

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      tooltipBehavior: TooltipBehavior(
        enable: true,
        canShowMarker: false,
        header: examType,
      ),
      legend: Legend(
        isVisible: true,
        textStyle: AppTStyles.subHeading,
        position: LegendPosition.bottom,
      ),
      series: <ChartSeries>[
        ColumnSeries<GraphData, String>(
          legendItemText: examType,
          enableTooltip: true,
          dataSource: graphData,
          xValueMapper: (data, _) => data.label,
          yValueMapper: (data, _) => data.value,
          color: AppColors.prim,
          width: 0.4,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(7),
            topRight: Radius.circular(7),
          ),
          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
          ),
        )
      ],
      primaryXAxis: CategoryAxis(
        majorGridLines: const MajorGridLines(color: Colors.transparent),
        majorTickLines: const MajorTickLines(color: Colors.transparent),
      ),
      primaryYAxis: NumericAxis(maximum: maxYValue),
    );
  }
}
