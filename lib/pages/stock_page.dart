import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/model/predictions_short_data.dart';
import 'package:flutter_application_2/notifications/followed_stock_model.dart';
import 'package:flutter_application_2/pages/stock_data_page.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import '../model/main_model.dart';
import '../model/stock_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

//TODO a better and more customizable graph required to change the last stick to different color to signify it being the prediction
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

final CollectionReference favorites =
    FirebaseFirestore.instance.collection('favorites');

class _StockPageState extends State<StockPage> {
  late Future<List<StockData>> _chartData;

  final TrackballBehavior _trackballBehavior = TrackballBehavior(
    enable: true,
    activationMode: ActivationMode.singleTap,
    tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
    shouldAlwaysShow: true,
  );

  late DateTime _startDate;
  late DateTime _endDate;

  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  bool _showLineChart = false;
  ZoomPanBehavior zoomPanBehavior = ZoomPanBehavior(
    enableDoubleTapZooming: true,
    enablePanning: true,
    enablePinching: true,
  );


  @override
  void initState() {
    super.initState();
    _chartData = PredictionsData.getStockData(widget.stockCode);
  }

  var db = FirebaseFirestore.instance;
  final userID = FirebaseAuth.instance.currentUser?.uid;

  addFavorite() {
    // Add a new document with a generated id.
    final data = {
      "userID": userID,
      "tickerID": widget.stockCode,
    };
    db.collection("favorites").add(data);
  }

  Future<void> removeFavorite() async {

    final snapshot = await db
        .collection("favorites")
        .where("userID", isEqualTo: userID)
        .where("tickerID", isEqualTo: widget.stockCode)
        .get();

    for (final doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  Future<bool> checkIfFavorite() async {
    final snapshot = await db
        .collection("favorites")
        .where("userID", isEqualTo: userID)
        .where("tickerID", isEqualTo: widget.stockCode)
        .get();

    return snapshot.docs.isNotEmpty;
  }

  List<List<StockData>> chartsTimes = [[], [], []];
  int chartTimesIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.stockName),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) =>
                      StockDataPage(widget.stockCode),
                ),
              );
            },
            tooltip: "Information",
            icon: const Icon(Icons.info_outline),
          ),
          StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              final isLoggedIn = snapshot.hasData;
              final user = FirebaseAuth.instance.currentUser;

              return isLoggedIn && user != null
                  ? FutureBuilder<bool>(
                future: checkIfFavorite(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else {
                    final isFavorite = snapshot.data ?? false;

                    return IconButton(
                      onPressed: () async {
                        if (isFavorite) {
                          await removeFavorite();
                        } else {
                          await addFavorite();
                        }

                        setState(() {});
                      },
                      tooltip: "Favorite",
                      icon: isFavorite
                          ? const Icon(Icons.star_rounded)
                          : const Icon(Icons.star_border_rounded),
                    );
                  }
                },
              )
                  : const SizedBox
                  .shrink(); // Hide the button if user is not logged in
            },
          ),
          Switch(
            activeColor: const Color.fromARGB(200, 255, 120, 120),
            value: _showLineChart,
            onChanged: (value) {
              setState(() {
                _showLineChart = !_showLineChart;
              });
            },
          ),
          IconButton(
            onPressed: () async {
              await PredictionsData.forceRefreshData(widget.stockCode);
              setState(() {
                _chartData = PredictionsData.getStockData(widget.stockCode);
              });
            },
            tooltip: "Refresh data",
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: _buildChart(),
    );
  }

  Widget _buildChart() {
    return Column(
      children: <Widget>[
        datesSetBar(),
        buildZoomBarChart(),
        buttonsDWM(),
      ],
    );
  }

  Widget buildZoomBarChart() {
    return Expanded(
      child: Stack(
        children: [
          _showLineChart ? _buildLineChart() : _buildCandleChart(),
          Positioned(
            top: 10,
            right: 10,
            child: ButtonBar(
              buttonPadding: const EdgeInsets.all(0),
              children: [
                IconButton(
                    onPressed: () {
                      zoomPanBehavior.zoomIn();
                    },
                    icon: const Text(
                      "+",
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    )),
                IconButton(
                    onPressed: () {
                      zoomPanBehavior.reset();
                    },
                    icon: const Text(
                      "o",
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    )),
                IconButton(
                    onPressed: () {
                      zoomPanBehavior.zoomOut();
                    },
                    icon: const Text(
                      "-",
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildLineChart() {
    return Expanded(
      child: FutureBuilder<List<StockData>>(
        future: _chartData,
        builder: (BuildContext context,
            AsyncSnapshot<List<StockData>> snapshot) {
          if (snapshot.hasData) {
            final List<StockData> chartData = snapshot.data!;
            return SfCartesianChart(
              legend: Legend(isVisible: true),
              zoomPanBehavior: zoomPanBehavior,
              trackballBehavior: _trackballBehavior,
              series: <LineSeries>[
                LineSeries<StockData, DateTime>(
                  dataSource: chartData,
                  name: "Predicted Price",
                  xValueMapper: (StockData data, _) => data.date,
                  yValueMapper: (StockData data, _) => data.closingPrice,
                  color: Colors.red.shade200,
                  legendItemText: "Predicted Price",
                ),
                LineSeries<StockData, DateTime>(
                  dataSource: chartData,
                  name: "Real Price",
                  xValueMapper: (StockData data, _) => data.date,
                  yValueMapper: (StockData data, _) => data.openingPrice,
                  color: Colors.green,
                  legendItemText: "Real Price",
                ),
                LineSeries<StockData, DateTime>(
                  dataSource: chartData,
                  name: "Prediction difference",
                  xValueMapper: (StockData data, _) => data.date,
                  yValueMapper: (StockData data, _) {
                    return (data.openingPrice.round() -
                        data.closingPrice.round())
                        .abs();
                  },
                  color: Colors.red.shade100,
                  legendItemText: "Prediction difference",
                ),
                LineSeries<StockData, DateTime>(
                  dataSource: chartData,
                  name: "Prediction percentage",
                  xValueMapper: (StockData data, _) => data.date,
                  yValueMapper: (StockData data, _) {
                    return ((data.openingPrice - data.closingPrice) *
                        100 /
                        data.openingPrice)
                        .abs();
                  },
                  color: Colors.blue.shade100,
                  legendItemText: "Prediction percentage",
                )
              ],
              primaryXAxis: DateTimeAxis(
                dateFormat: DateFormat.MMM(),
                majorGridLines: const MajorGridLines(width: 0),
              ),
              primaryYAxis: NumericAxis(
                numberFormat: NumberFormat.simpleCurrency(decimalDigits: 0),
              ),
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget datesSetBar() {
    return Container(
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
                  "${_startDate.year}-${_startDate.month.toString().padLeft(
                      2, '0')}-${_startDate.day.toString().padLeft(2, '0')}";
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
                  "${_endDate.year}-${_endDate.month.toString().padLeft(
                      2, '0')}-${_endDate.day.toString().padLeft(2, '0')}";
                });
              },
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            child: const Text('Submit'),
            onPressed: () {
              setState(() {
                _chartData = PredictionsData.getStockDataDates(
                    widget.stockCode, _startDate, _endDate)
                // ApiService().fetchStockDataTimed(
                //     widget.stockCode, _startDate, _endDate)
                    ;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCandleChart() {
    return Expanded(
      child: FutureBuilder<List<StockData>>(
        future: _chartData,
        builder: (BuildContext context,
            AsyncSnapshot<List<StockData>> snapshot) {
          if (snapshot.hasData) {
            List<StockData> chartSampleData = snapshot.data!.map((data) {
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
              zoomPanBehavior: zoomPanBehavior,
              trackballBehavior: _trackballBehavior,
              series: [
                CandleSeries<StockData, DateTime>(
                    dataSource: chartsTimes[chartTimesIndex],
                    name: widget.stockCode,
                    xValueMapper: (StockData sales, _) => sales.date,
                    lowValueMapper: (StockData sales, _) => sales.lowPrice,
                    highValueMapper: (StockData sales, _) => sales.highPrice,
                    openValueMapper: (StockData sales, _) => sales.openingPrice,
                    closeValueMapper: (StockData sales, _) =>
                    sales.closingPrice),
                LineSeries<StockData, DateTime>(
                  dataSource: chartsTimes[chartTimesIndex],
                  name: "Prediction difference",
                  xValueMapper: (StockData data, _) => data.date,
                  yValueMapper: (StockData data, _) {
                    return (data.openingPrice.round() -
                        data.closingPrice.round())
                        .abs();
                  },
                  color: Colors.red.shade100,
                  legendItemText: "Prediction difference",
                ),
                LineSeries<StockData, DateTime>(
                  dataSource: chartsTimes[chartTimesIndex],
                  name: "Prediction percentage",
                  xValueMapper: (StockData data, _) => data.date,
                  yValueMapper: (StockData data, _) {
                    return ((data.openingPrice - data.closingPrice) *
                        100 /
                        data.openingPrice)
                        .abs();
                  },
                  color: Colors.blue.shade100,
                  legendItemText: "Prediction percentage",
                )
              ],
              primaryXAxis: DateTimeAxis(
                  dateFormat: DateFormat.MMM(),
                  majorGridLines: const MajorGridLines(width: 0)),
              primaryYAxis: NumericAxis(
                  numberFormat: NumberFormat.simpleCurrency(decimalDigits: 0)),
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget buttonsDWM() {
    return ButtonBar(
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
    );
  }
}


