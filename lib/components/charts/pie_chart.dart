
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../text.dart';



class CustomPieChart extends StatelessWidget {

  final String? chartTitle;
  final List<CustomPieSection> pieSections;

  final TextStyle? titleStyle;
  final TextStyle? sectionTitleStyle;

  final double height;
  final double width;
  final double centerSpaceRadius;
  final Color? backgroundColor;


  final bool addKeySection;


  CustomPieChart({
    super.key,
    this.chartTitle,
    this.titleStyle,
    this.sectionTitleStyle,
    this.pieSections = const [],
    this.height=400,
    this.width=400,
    this.centerSpaceRadius=10,
    this.backgroundColor,
    this.addKeySection = false,
  });


  final List<Color> availableColors = [
    Colors.purple,
    Colors.amber,
    Colors.deepPurple,
    Colors.red.shade400,
    Colors.green,
    Colors.blue,
    Colors.green.shade400,
    Colors.yellow,
    Colors.lightBlue,
    Colors.blue.shade400,
    Colors.redAccent,
    Colors.deepOrange,
    Colors.indigo
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),

      height: height,
      width: width,


      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),

      child: LayoutBuilder(
        builder: (_, __){

          if(!addKeySection) return buildPieChart();


          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              SizedBox(
                height: 400,
                width: 400,
                child: buildPieChart()
              ),


              buildChartKeySection()

            ]
          );

        }
      ),
    );
  }



  Widget buildPieChart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,

      children: [


        if(chartTitle != null) Text(
          chartTitle!,
          style: titleStyle ?? TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16
          ),
        ),

        const SizedBox(height: 12,),


        Expanded(
          flex: 2,

          child: PieChart(
            PieChartData(

              sections: List.generate(
                pieSections.length,
                (int index) => PieChartSectionData(

                  value: pieSections[index].value,
                  title: pieSections[index].title ?? '',
                  showTitle: true,

                  color: availableColors[index % availableColors.length],
                  radius: 100,

                  titleStyle: sectionTitleStyle ?? TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                  )
                )
              ),


              borderData: FlBorderData(
                show: false
              ),

              sectionsSpace: 0,
              centerSpaceRadius: centerSpaceRadius
            )

          ),
        ),

      ],
    );
  }





  Widget buildChartKeySection(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: 8,

      children: List<Widget>.generate(
        pieSections.length,
        (index){
          return Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            spacing: 12,
            children: [

              Container(
                height: 20,
                width: 20,
                color: availableColors[index],
              ),


              CustomText(pieSections[index].title ?? '')
            ],
          );
        }
      )
    );
  }


}



class CustomPieSection{

  double value;
  String? title;

  CustomPieSection({required this.value, this.title});
}

