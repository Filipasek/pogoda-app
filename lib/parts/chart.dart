import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class WeatherChart extends StatefulWidget {
  final chartData;
  final altColors;
  WeatherChart({@required this.chartData, this.altColors});
  @override
  _WeatherChartState createState() => _WeatherChartState();
}

class _WeatherChartState extends State<WeatherChart> {
  List<Color> gradientColorsAlternative = [
    const Color.fromRGBO(122, 87, 209, 1),
    const Color.fromRGBO(243, 129, 129, 1),
  ];
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 3, //TODO: long setup
          child: Padding(
            padding: const EdgeInsets.only(
                right: 10.0, left: 10.0, top: 10, bottom: 2),
            child: LineChart(
              mainData(widget.altColors),
            ),
          ),
        ),
      ],
    );
  }

  LineChartData mainData(bool alternativeColors) {
    List<Color> gradientColorsBooleaned =
        alternativeColors ? gradientColorsAlternative : gradientColors;
    return LineChartData(
      gridData: FlGridData(
        show: false,
        drawVerticalLine: false,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            // color: const Color(0xff37434d),
            color: Colors.yellow,
            // color: ,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            // color: const Color(0xff37434d),
            color: Colors.red,
            strokeWidth: 1,
          );
        },
      ),
      lineTouchData: LineTouchData(
        enabled: true,
        // getTouchedSpotIndicator: (barData, spotIndexes) => '',
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Theme.of(context).primaryColor,
          fitInsideHorizontally: true,
          getTooltipItems: (List<LineBarSpot> touchedSpots) {
            // print(touchedSpots[0].barIndex);
            // return [];
            // if (touchedSpots == null) {
            //   return null;
            // }

            return touchedSpots.map((LineBarSpot touchedSpot) {
              if (touchedSpot == null) {
                return null;
              }
              final TextStyle textStyle = TextStyle(
                color: Theme.of(context).textTheme.headline5!.color,
                fontWeight: FontWeight.normal,
                fontSize: 14,
              );
              return LineTooltipItem(
                  touchedSpot.y.toString() + '°C', textStyle);
            }).toList();
          },
        ),
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (value) => TextStyle(
            color: Theme.of(context).textTheme.bodyText2!.color,
            fontWeight: FontWeight.normal,
            fontSize: 14,
          ),
          // textStyle: TextStyle(
          //   color: Theme.of(context).textTheme.bodyText2.color,
          //   fontWeight: FontWeight.normal,
          //   fontSize: 14,
          // ),
          getTitles: (value) {
            if (value.toInt() % 2 == 1 && value.toInt() != 23) {
              return time(
                  stime: widget.chartData[value.toInt()]['tillDateTime']
                      .toString());
            } else if (value.toInt() == 23) {
              return time(
                  stime: widget.chartData[value.toInt()]['tillDateTime']
                      .toString(),
                  full: false);
            } else {
              return '';
            }
          },
          margin: 5,
        ),
        leftTitles: SideTitles(
          showTitles: false,
        ),
      ),
      borderData: FlBorderData(
          show: false,
          border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      maxX: 23,
      // minY: 0,
      // maxY: 30,
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(0, ((widget.chartData[0]['values'][5]["value"] * 10).round() / 10)),
            FlSpot(1, ((widget.chartData[1]['values'][5]["value"] * 10).round() / 10)),
            FlSpot(2, ((widget.chartData[2]['values'][5]["value"] * 10).round() / 10)),
            FlSpot(3, ((widget.chartData[3]['values'][5]["value"] * 10).round() / 10)),
            FlSpot(4, ((widget.chartData[4]['values'][5]["value"] * 10).round() / 10)),
            FlSpot(5, ((widget.chartData[5]['values'][5]["value"] * 10).round() / 10)),
            FlSpot(6, ((widget.chartData[6]['values'][5]["value"] * 10).round() / 10)),
            FlSpot(7, ((widget.chartData[7]['values'][5]["value"] * 10).round() / 10)),
            FlSpot(8, ((widget.chartData[8]['values'][5]["value"] * 10).round() / 10)),
            FlSpot(9, ((widget.chartData[9]['values'][5]["value"] * 10).round() / 10)),
            FlSpot(10, ((widget.chartData[10]['values'][5]["value"] * 10).round() / 10)),
            FlSpot(11, ((widget.chartData[11]['values'][5]["value"] * 10).round() / 10)),
            FlSpot(12, ((widget.chartData[12]['values'][5]["value"] * 10).round() / 10)),
            FlSpot(13, ((widget.chartData[13]['values'][5]["value"] * 10).round() / 10)),
            FlSpot(14, ((widget.chartData[14]['values'][5]["value"] * 10).round() / 10)),
            FlSpot(15, ((widget.chartData[15]['values'][5]["value"] * 10).round() / 10)),
            FlSpot(16, ((widget.chartData[16]['values'][5]["value"] * 10).round() / 10)),
            FlSpot(17, ((widget.chartData[17]['values'][5]["value"] * 10).round() / 10)),
            FlSpot(18, ((widget.chartData[18]['values'][5]["value"] * 10).round() / 10)),
            FlSpot(19, ((widget.chartData[19]['values'][5]["value"] * 10).round() / 10)),
            FlSpot(20, ((widget.chartData[20]['values'][5]["value"] * 10).round() / 10)),
            FlSpot(21, ((widget.chartData[21]['values'][5]["value"] * 10).round() / 10)),
            FlSpot(22, ((widget.chartData[22]['values'][5]["value"] * 10).round() / 10)),
            FlSpot(23, ((widget.chartData[23]['values'][5]["value"] * 10).round() / 10)),
          ],
          isCurved: true,
          colors: gradientColorsBooleaned,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors: gradientColorsBooleaned
                .map((color) => color.withOpacity(0.3))
                .toList(),
          ),
        ),
      ],
    );
  }

  String time({required String stime, bool full = false}) {
    int h = int.parse(
            stime.substring(stime.indexOf("T") + 1, stime.indexOf("T") + 3)) +
        2;
    String minute =
        stime.substring(stime.indexOf("T") + 4, stime.indexOf("T") + 6);
    String hour = h >= 24 ? (h - 24).toString() : h.toString();
    // return '$hour:$minute';
    return full ? '$hour:$minute' : hour;
  }
}
