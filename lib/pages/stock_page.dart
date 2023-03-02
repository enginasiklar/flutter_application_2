import 'package:flutter/material.dart';
import 'package:flutter_application_2/model/predictions_short_data.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import '../model/stock_model.dart';
import '../services/api_service.dart';

//TODO more memory efficient graph data loading using the time constrained calling of api
/*TODO:
  get chartData outside the build function for more efficiency
  get the initial data once with a constant date days(now-10, now)
  fetch ata from API only using submit button
*/
class StockPage extends StatefulWidget {
  const StockPage(
      {super.key, required this.stockCode, required this.stockName});
  final String stockCode;
  final String stockName;
  @override
  State<StockPage> createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {
  late Future<List<StockData>> _chartData;

  final TrackballBehavior _trackballBehavior =
      TrackballBehavior(enable: true, activationMode: ActivationMode.singleTap);

  late DateTime _startDate;
  late DateTime _endDate;

  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _chartData = ApiService().fetchStockData(widget.stockCode);
  }

  List<List<StockData>> chartsTimes = [[], [], []];
  int chartTimesIndex = 0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.stockName),
        ),
        body: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: startDateController,
                      decoration: const InputDecoration(
                        labelText: 'Start Date',
                      ),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2001),
                            //DateTime.now() - not to allow to choose before today.
                            lastDate: DateTime.now());
                        if (pickedDate == null) return;
                        setState(() {
                          _startDate = pickedDate;
                          startDateController.text =
                              "${_startDate.year}-${_startDate.month.toString().padLeft(2, '0')}-${_startDate.day.toString().padLeft(2, '0')}";
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: endDateController,
                      decoration: const InputDecoration(
                        labelText: 'End Date',
                      ),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2001),
                            //DateTime.now() - not to allow to choose before today.
                            lastDate: DateTime.now());
                        if (pickedDate == null) return;
                        setState(() {
                          _endDate = pickedDate;
                          endDateController.text =
                              "${_endDate.year}-${_endDate.month.toString().padLeft(2, '0')}-${_endDate.day.toString().padLeft(2, '0')}";
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    child: const Text('Submit'),
                    onPressed: () {
                      setState(() {
                        _chartData = ApiService().fetchStockDataTimed(
                            widget.stockCode, _startDate, _endDate);
                      });
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<List<StockData>>(
                future: _chartData,
                builder: (BuildContext context,
                    AsyncSnapshot<List<StockData>> snapshot) {
                  if (snapshot.hasData) {
                    List<StockData> chartSampleData =
                        snapshot.data!.map((data) {
                      return StockData(
                          date: data.date,
                          lowPrice: data.lowPrice,
                          highPrice: data.highPrice,
                          openingPrice: data.openingPrice,
                          closingPrice: data.closingPrice);
                    }).toList();
                    chartsTimes[0] = chartSampleData;
                    chartsTimes[1] = StockData.getWeekly(chartSampleData);
                    chartsTimes[2] = StockData.getMonthly(chartsTimes[1]);
                    return SfCartesianChart(
                      zoomPanBehavior: ZoomPanBehavior(
                          enableDoubleTapZooming: true, enablePanning: true),
                      trackballBehavior: _trackballBehavior,
                      series: <CandleSeries>[
                        CandleSeries<StockData, DateTime>(
                            dataSource: chartsTimes[chartTimesIndex],
                            name: widget.stockCode,
                            xValueMapper: (StockData sales, _) => sales.date,
                            lowValueMapper: (StockData sales, _) =>
                                sales.lowPrice,
                            highValueMapper: (StockData sales, _) =>
                                sales.highPrice,
                            openValueMapper: (StockData sales, _) =>
                                sales.openingPrice,
                            closeValueMapper: (StockData sales, _) =>
                                sales.closingPrice)
                      ],
                      primaryXAxis: DateTimeAxis(
                          dateFormat: DateFormat.MMM(),
                          majorGridLines: const MajorGridLines(width: 0)),
                      primaryYAxis: NumericAxis(
                          numberFormat:
                              NumberFormat.simpleCurrency(decimalDigits: 0)),
                    );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  PredictionsShortData.getPredictedPrice(widget.stockCode),
                  const Divider(),
                  Expanded(
                    child: PredictionsShortData.getChangeLastMonth(
                        widget.stockCode, true),
                  ),
                ],
              ),
            ),
            ButtonBar(
              alignment: MainAxisAlignment.center,
              buttonPadding: const EdgeInsets.all(15),
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      chartTimesIndex = 0;
                    });
                  },
                  icon: Text(
                    "D",
                    style: TextStyle(
                      fontSize: 18,
                      color: chartTimesIndex == 0 ? Colors.green : null,
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      setState(() {
                        chartTimesIndex = 1;
                      });
                    },
                    icon: Text(
                      "W",
                      style: TextStyle(
                        fontSize: 18,
                        color: chartTimesIndex == 1 ? Colors.green : null,
                      ),
                    )),
                IconButton(
                    onPressed: () {
                      setState(() {
                        chartTimesIndex = 2;
                      });
                    },
                    icon: Text(
                      "M",
                      style: TextStyle(
                        fontSize: 18,
                        color: chartTimesIndex == 2 ? Colors.green : null,
                      ),
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
