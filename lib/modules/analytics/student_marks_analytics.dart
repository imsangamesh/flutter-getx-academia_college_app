import 'package:flutter/material.dart';
import 'package:newbie/core/themes/my_colors.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GraphRanges {
  int sem, marks;
  GraphRanges(this.sem, this.marks);
}

class StudentMarksAnalytics extends StatelessWidget {
  const StudentMarksAnalytics({Key? key}) : super(key: key);

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
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Marks Analytics'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.circle),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 50, right: 10, left: 10),
        child: SizedBox(
          height: size.height * 0.35,
          child: SfCartesianChart(
            tooltipBehavior: TooltipBehavior(enable: true),
            margin: const EdgeInsets.only(right: 5),
            series: <ChartSeries>[
              LineSeries<GraphRanges, int>(
                enableTooltip: true,
                dataSource: cie1Mapper(),
                color: ThemeColors.darkPrim,
                xValueMapper: (GraphRanges range, _) => range.sem,
                yValueMapper: (GraphRanges range, _) => range.marks,
                dataLabelSettings: const DataLabelSettings(isVisible: true),
                markerSettings: MarkerSettings(
                  isVisible: true,
                  borderWidth: 2,
                  width: 10,
                  borderColor: ThemeColors.shade100,
                  color: ThemeColors.shade100,
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
