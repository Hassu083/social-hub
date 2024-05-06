import 'package:socialhub/common_widgets/logo.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Chart extends StatelessWidget {
  Function() onClick;
  Chart({Key? key, required this.onClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          GestureDetector(child: SocialHub(factor: 0.6,color: const Color(0xFF2697FF),),onTap: onClick,),
          PieChart(
            PieChartData(
                centerSpaceRadius: 70,
                startDegreeOffset: -90,
                sections: data
            ),
          ),
        ],
      ),
    );
  }
}
List<PieChartSectionData> data = [
  PieChartSectionData(
      value: 25,
      radius: 25,
      showTitle: false,
      color: Colors.amber
  ),
  PieChartSectionData(
      value: 22,
      showTitle: false,
      radius: 22,
      color: Colors.green
  ),
  PieChartSectionData(
      value: 19,
      radius: 20,
      showTitle: false,
      color: Colors.red
  ),
  PieChartSectionData(
      value: 19,
      radius: 20,
      showTitle: false,
      color: const Color(0xFF2A2D3E)
  ),
];
