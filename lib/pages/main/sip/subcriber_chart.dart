import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:easy_pel/pages/main/sip/subscriber_series.dart';
import 'package:intl/intl.dart';

class SubscriberChart extends StatelessWidget {
  final List<SubscriberSeries> data;
  final String title;

  SubscriberChart({required this.data, required this.title});

  @override
  Widget build(BuildContext context) {
    List<charts.Series<SubscriberSeries, String>> series = [
      charts.Series(
        id: "Subscribers",
        data: data,
        domainFn: (SubscriberSeries series, _) => series.year,
        measureFn: (SubscriberSeries series, _) => series.subscribers,
        colorFn: (SubscriberSeries series, _) => series.barColor
      )
    ];

    final valueFormatter =
        charts.BasicNumericTickFormatterSpec.fromNumberFormat(
            NumberFormat.compact());

    return Container(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              Text(
               title,
              ),
              Expanded(
                child: charts.BarChart(series, animate: true, primaryMeasureAxis: charts.NumericAxisSpec(
                  
                  tickFormatterSpec: valueFormatter,

                // dateTimeFactory: const charts.LocalDateTimeFactory(),
              )),
              )
            ],
          ),
        ),
      ),
    );
  }
}