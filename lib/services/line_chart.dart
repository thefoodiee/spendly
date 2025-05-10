import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:spendly/services/sms_parsing.dart'; // Replace with your actual import

class WeeklySpendChart extends StatefulWidget {
  final List<TransactionInfo> transactions;
  final DateTime currentMonth;

  const WeeklySpendChart({
    super.key,
    required this.transactions,
    required this.currentMonth,
  });

  @override
  _WeeklySpendChartState createState() => _WeeklySpendChartState();
}

class _WeeklySpendChartState extends State<WeeklySpendChart> {
  int currentWeekIndex = 0;

  @override
  void didUpdateWidget(covariant WeeklySpendChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentMonth != widget.currentMonth) {
      setState(() {
        currentWeekIndex = 0;
      });
    }
  }

  List<DateTime> getWeekRange(int weekIndex) {
    DateTime firstDay = DateTime(widget.currentMonth.year, widget.currentMonth.month, 1);
    int offset = firstDay.weekday - 1;
    DateTime start = firstDay.add(Duration(days: weekIndex * 7 - offset));
    DateTime end = start.add(Duration(days: 6));
    return [start, end];
  }

  int getTotalWeeksInMonth() {
    DateTime first = DateTime(widget.currentMonth.year, widget.currentMonth.month, 1);
    DateTime last = DateTime(widget.currentMonth.year, widget.currentMonth.month + 1, 0);
    int daysInMonth = last.day + (first.weekday - 1);
    return (daysInMonth / 7).ceil();
  }

  List<DailySpendData> getWeeklySpend() {
    List<DateTime> range = getWeekRange(currentWeekIndex);
    DateTime start = range[0];
    DateTime end = range[1];

    Map<int, double> dailyTotals = { for (var i = 1; i <= 7; i++) i: 0.0 };

    final filtered = widget.transactions.where((tx) {
      final dt = tx.dateTime;
      return dt != null &&
          !tx.isCredit &&
          dt.isAfter(start.subtract(Duration(days: 1))) &&
          dt.isBefore(end.add(Duration(days: 1)));
    });

  for (var tx in filtered) {
  final dt = tx.dateTime;
  if (dt != null) {
    dailyTotals[dt.weekday] = (dailyTotals[dt.weekday] ?? 0.0) + tx.amount;

  }
}



    const weekDayNames = {
      1: 'Mon',
      2: 'Tue',
      3: 'Wed',
      4: 'Thu',
      5: 'Fri',
      6: 'Sat',
      7: 'Sun',
    };

    return dailyTotals.entries
        .map((e) => DailySpendData(weekDayNames[e.key]!, e.value))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final weeklyData = getWeeklySpend();
    final totalWeeks = getTotalWeeksInMonth();
    final weekRange = getWeekRange(currentWeekIndex);

    return Column(
      children: [
        Text(
          "Week ${currentWeekIndex + 1}: ${DateFormat('dd MMM').format(weekRange[0])} - ${DateFormat('dd MMM').format(weekRange[1])}",
          style: TextStyle(color: Colors.white, fontFamily: 'Lexend'),
        ),
        SizedBox(height: 8),
        Container(
          width: 350,
          height: 250,
          child: SfCartesianChart(
            title: ChartTitle(
              text: 'Weekly Spend',
              textStyle: TextStyle(color: Colors.white, fontFamily: 'Lexend', fontSize: 12),
            ),
            primaryXAxis: CategoryAxis(
              title: AxisTitle(
                text: 'Day',
                textStyle: TextStyle(color: Colors.white, fontFamily: 'Lexend', fontSize: 12),
              ),
              labelStyle: TextStyle(color: Colors.white, fontFamily: 'Lexend'),
            ),
            primaryYAxis: NumericAxis(
              title: AxisTitle(
                text: 'Amount (₹)',
                textStyle: TextStyle(color: Colors.white, fontFamily: 'Lexend', fontSize: 12),
              ),
              labelStyle: TextStyle(color: Colors.white, fontFamily: 'Lexend'),
            ),
            series: <CartesianSeries<DailySpendData, String>>[
              LineSeries<DailySpendData, String>(
                dataSource: weeklyData,
                xValueMapper: (data, _) => data.day,
                yValueMapper: (data, _) => data.amount,
                markerSettings: MarkerSettings(isVisible: true),
                color: Colors.white,
                dataLabelSettings: DataLabelSettings(isVisible: true, color: Colors.white, textStyle: TextStyle(fontFamily: 'Lexend')),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: currentWeekIndex > 0
                  ? () => setState(() => currentWeekIndex--)
                  : null,
              icon: Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 12),
            IconButton(
              onPressed: currentWeekIndex < totalWeeks - 1
                  ? () => setState(() => currentWeekIndex++)
                  : null,
              icon: Icon(
                Icons.arrow_forward_rounded,
                color: Colors.white,),
            ),
          ],
        ),
      ],
    );
  }
}
