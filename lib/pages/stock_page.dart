import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/model/predictions_short_data.dart';
import 'package:flutter_application_2/pages/stock_data_page.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import '../model/stock_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//TODO a better and more customizable graph required to change the last stick to different color to signify it being the prediction
//TODO more memory efficient graph data loading using the time constrained calling of api
/*TODO:
  get chartData outside the build function for more efficiency
  get the initial data once with a constant date days(now-10, now)
  fetch ata from API only using submit button
*/
class StockPage extends StatefulWidget { const StockPage({super.key, required this.stockCode, required this.stockName});
  final String stockCode;final String stockName; @override State<StockPage> createState() => _StockPageState();}

final CollectionReference favorites = FirebaseFirestore.instance.collection('favorites');
class _StockPageState extends State<StockPage> {
  late Future<List<StockData>> _chartData;
  final TrackballBehavior _trackballBehavior = TrackballBehavior(enable: true,
    activationMode: ActivationMode.singleTap,
    tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
    shouldAlwaysShow: true,);
  late TooltipBehavior _tooltipBehavior;
  late DateTime _startDate;
  late DateTime _endDate;
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  bool _showLineChart = false;
  ZoomPanBehavior zoomPanBehavior = ZoomPanBehavior(
    enableDoubleTapZooming: true, enablePanning: true, enablePinching: true,);
  var db = FirebaseFirestore.instance;
  final userID = FirebaseAuth.instance.currentUser?.uid;
  List<List<StockData>> chartsTimes = [[], [], []];
  int chartTimesIndex = 0;

  @override void initState() {
    super.initState();
    _tooltipBehavior = TooltipBehavior(enable: true,);
    _chartData = PredictionsData.getStockData(widget.stockCode);
  }

  addFavorite() {
    final data = {"userID": userID, "tickerID": widget.stockCode,};
    db.collection("favorites").add(data);
  }

  Future<void> removeFavorite() async {
    final snapshot = await db.collection("favorites").where(
        "userID", isEqualTo: userID).where(
        "tickerID", isEqualTo: widget.stockCode).get();
    for (final doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  Future<bool> checkIfFavorite() async {
    final snapshot = await db.collection("favorites").where(
        "userID", isEqualTo: userID).where(
        "tickerID", isEqualTo: widget.stockCode).get();
    return snapshot.docs.isNotEmpty;
  }

  @override Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text(widget.stockName), actions: [
      IconButton(onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (BuildContext context) =>
              StockDataPage(widget.stockCode),),);
      }, tooltip: "Information", icon: const Icon(Icons.info_outline),),
      StreamBuilder<User?>(stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          final isLoggedIn = snapshot.hasData;
          final user = FirebaseAuth.instance.currentUser;
          return isLoggedIn && user != null ? FutureBuilder<bool>(
            future: checkIfFavorite(), builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else {
              final isFavorite = snapshot.data ?? false;
              return IconButton(onPressed: () async {
                if (isFavorite) {
                  await removeFavorite();
                } else {
                  await addFavorite();
                }
                setState(() {});
              },
                tooltip: "Favorite",
                icon: isFavorite ? const Icon(Icons.star_rounded) : const Icon(
                    Icons.star_border_rounded),);
            }
          },) : const SizedBox.shrink();
        },
      ),
      Switch(activeColor: const Color.fromARGB(200, 255, 120, 120),
        value: _showLineChart,
        onChanged: (value) {
          setState(() {
            _showLineChart = !_showLineChart;
          });
        },),
      IconButton(onPressed: () async {
        await PredictionsData.forceRefreshData(widget.stockCode);
        setState(() {
          _chartData = PredictionsData.getStockData(widget.stockCode);
        });
      },
        tooltip: "Refresh data", icon: const Icon(Icons.refresh),),
    ],), body: _buildChart(),);
  }

  Widget _buildChart() {
    return Column(children: <Widget>[
      Expanded(flex: 1, child: datesSetBar(),),
      const SizedBox(height: 20),
      Expanded(flex: 6,
        child: Stack(children: [
          _showLineChart ? _buildLineChart() : _buildCandleChart(),
        ],),),
      const SizedBox(height: 20),
      Expanded(flex: 1,
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          Container(padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10),),
            child: buttonsDWM(),),
          Container(padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10),),
            child: buildZoomBarChart(),),
        ],),),
    ],);
  }

  Widget _buildCandleChart() {
    return Expanded(child: FutureBuilder<List<StockData>>(
      future: _chartData,
      builder: (BuildContext context, AsyncSnapshot<List<StockData>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData && snapshot.data != null) {
          List<StockData> chartSampleData = snapshot.data!.where((
              data) => data != null).map((data) {
            return StockData(date: data.date,
              openingPrice: data.openingPrice,
              closingPrice: data.closingPrice,
              predictedPrice: data.predictedPrice,);
          }).toList();
          chartsTimes[0] = chartSampleData;
          chartsTimes[1] = StockData.getWeekly(chartSampleData);
          chartsTimes[2] = StockData.getMonthly(chartsTimes[1]);
          return SfCartesianChart(zoomPanBehavior: zoomPanBehavior,
            trackballBehavior: _trackballBehavior,
            /*onTooltipRender: (TooltipArgs args) {
                List<dynamic>? chartdata = args.dataPoints;
                StockData dataPoint = chartdata![args.pointIndex];

                // Format date for the tooltip
                String formattedDate = DateFormat('d MMM yyyy').format(dataPoint.date);

                // Calculate prediction difference and percentage
                double predictionDiff = (dataPoint.openingPrice.round() - dataPoint.closingPrice.round()).abs() as double;
                double predictionPercentage = ((dataPoint.openingPrice - dataPoint.closingPrice) * 100 / dataPoint.openingPrice).abs();

                // Set the header to the formatted date
                args.header = formattedDate;

                // Set the text to include prediction and actual value change and their percentages
                args.text = 'Prediction Diff: ${predictionDiff.toStringAsFixed(2)}\n'
                    'Prediction Percentage: ${predictionPercentage.toStringAsFixed(2)}%\n'
                    'Predicted Price: ${dataPoint.predictedPrice.toStringAsFixed(2)}\n'
                    'Opening Price: ${dataPoint.openingPrice.toStringAsFixed(2)}\n'
                    'Closing Price: ${dataPoint.closingPrice.toStringAsFixed(2)}';
              }, */
            series: [
              CandleSeries<StockData, DateTime>(
                dataSource: chartsTimes[chartTimesIndex],
                name: widget.stockCode,
                xValueMapper: (StockData sales, _) => sales.date,
                lowValueMapper: (StockData sales, _) => sales.closingPrice,
                highValueMapper: (StockData sales, _) => sales.openingPrice,
                openValueMapper: (StockData sales, _) => sales.openingPrice,
                closeValueMapper: (StockData sales, _) => sales.closingPrice,),
              LineSeries<StockData, DateTime>(
                dataSource: chartsTimes[chartTimesIndex],
                name: "Prediction difference",
                xValueMapper: (StockData data, _) => data.date,
                yValueMapper: (StockData data, _) {
                  return (data.openingPrice.round() - data.closingPrice.round())
                      .abs();
                },
                color: Colors.red.shade100,
                legendItemText: "Prediction difference",),
              LineSeries<StockData, DateTime>(
                dataSource: chartsTimes[chartTimesIndex],
                name: "Prediction percentage",
                xValueMapper: (StockData data, _) => data.date,
                yValueMapper: (StockData data, _) {
                  return ((data.openingPrice - data.closingPrice) * 100 /
                      data.openingPrice).abs();
                },
                color: Colors.blue.shade100,
                legendItemText: "Prediction percentage",),
              LineSeries<StockData, DateTime>(
                dataSource: chartsTimes[chartTimesIndex],
                name: "Predicted Price",
                xValueMapper: (StockData data, _) => data.date,
                yValueMapper: (StockData data, _) => data.predictedPrice ?? 0,
                color: Colors.green.shade100,
                legendItemText: "Predicted Price",),
            ],
            primaryXAxis: DateTimeAxis(dateFormat: DateFormat('MMM dd, yyyy'),
              majorGridLines: const MajorGridLines(width: 0),),
            primaryYAxis: NumericAxis(
              numberFormat: NumberFormat.simpleCurrency(decimalDigits: 0),),);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        } else {
          Future.delayed(const Duration(seconds: 1), () {
            setState(() {});
          });
          return const Center(child: CircularProgressIndicator());
        }
      },),);
  }

  Widget _buildLineChart() {
    return Expanded(child: FutureBuilder<List<StockData>>(future: _chartData,
      builder: (BuildContext context, AsyncSnapshot<List<StockData>> snapshot) {
        if (snapshot.hasData) {
          final List<StockData> chartData = snapshot.data!;
          return SfCartesianChart(legend: Legend(isVisible: true),
            zoomPanBehavior: zoomPanBehavior,
            trackballBehavior: _trackballBehavior,
            series: <LineSeries>[LineSeries<StockData, DateTime>(
              dataSource: chartData,
              name: "Predicted Price",
              xValueMapper: (StockData data, _) => data.date,
              yValueMapper: (StockData data, _) => data.closingPrice,
              color: Colors.red.shade200,
              legendItemText: "Predicted Price",),
              LineSeries<StockData, DateTime>(dataSource: chartData,
                name: "Real Price",
                xValueMapper: (StockData data, _) => data.date,
                yValueMapper: (StockData data, _) => data.openingPrice,
                color: Colors.green,
                legendItemText: "Real Price",),
              LineSeries<StockData, DateTime>(dataSource: chartData,
                name: "Prediction difference",
                xValueMapper: (StockData data, _) => data.date,
                yValueMapper: (StockData data, _) {
                  return (data.openingPrice.round() - data.closingPrice.round())
                      .abs();
                },
                color: Colors.red.shade100,
                legendItemText: "Prediction difference",),
              LineSeries<StockData, DateTime>(dataSource: chartData,
                name: "Prediction percentage",
                xValueMapper: (StockData data, _) => data.date,
                yValueMapper: (StockData data, _) {
                  return ((data.openingPrice - data.closingPrice) * 100 /
                      data.openingPrice).abs();
                },
                color: Colors.blue.shade100,
                legendItemText: "Prediction percentage",)
            ],
            primaryXAxis: DateTimeAxis(dateFormat: DateFormat.MMM(),
              majorGridLines: const MajorGridLines(width: 0),),
            primaryYAxis: NumericAxis(
              numberFormat: NumberFormat.simpleCurrency(decimalDigits: 0),),);
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },),);
  }

  Widget datesSetBar() {
    return Container(padding: const EdgeInsets.all(10),
      child: Row(children: [
        Expanded(child: TextField(controller: startDateController,
          decoration: const InputDecoration(labelText: 'Start Date',),
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2001),
                lastDate: DateTime.now());
            if (pickedDate == null) return;
            setState(() {
              _startDate = pickedDate;
              startDateController.text =
              "${_startDate.year}-${_startDate.month.toString().padLeft(
                  2, '0')}-${_startDate.day.toString().padLeft(2, '0')}";
            });
          },),),
        Expanded(child: TextField(controller: endDateController,
          decoration: const InputDecoration(labelText: 'End Date',),
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2001),
                lastDate: DateTime.now());
            if (pickedDate == null) return;
            setState(() {
              _endDate = pickedDate;
              endDateController.text =
              "${_endDate.year}-${_endDate.month.toString().padLeft(
                  2, '0')}-${_endDate.day.toString().padLeft(2, '0')}";
            });
          },),),
        const SizedBox(width: 10),
        ElevatedButton(child: const Text('Submit'),
          onPressed: () {
            setState(() {
              _chartData = PredictionsData.getStockDataDates(
                  widget.stockCode, _startDate, _endDate);
            });
          },),
      ],),);
  }

  Widget buildZoomBarChart() {
    return ButtonBar(
      buttonPadding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 0),
      alignment: MainAxisAlignment.center,
      children: [
        IconButton(onPressed: () {
          zoomPanBehavior.zoomIn();
        },
          icon: const Text("+",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),),
        IconButton(onPressed: () {
          zoomPanBehavior.reset();
        },
          icon: const Text("o",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),),
        IconButton(onPressed: () {
          zoomPanBehavior.zoomOut();
        },
          icon: const Text("-",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),),
      ],);
  }

  Widget buttonsDWM() {
    return ButtonBar(alignment: MainAxisAlignment.center,
      buttonPadding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 0),
      children: [
        IconButton(onPressed: () {
          setState(() {
            chartTimesIndex = 0;
          });
        },
          icon: Text("D", style: TextStyle(fontSize: 18,
            color: chartTimesIndex == 0 ? Colors.green : null,),),),
        IconButton(onPressed: () {
          setState(() {
            chartTimesIndex = 1;
          });
        },
            icon: Text("W", style: TextStyle(fontSize: 18,
              color: chartTimesIndex == 1 ? Colors.green : null,),)),
        IconButton(onPressed: () {
          setState(() {
            chartTimesIndex = 2;
          });
        },
            icon: Text("M", style: TextStyle(fontSize: 18,
              color: chartTimesIndex == 2 ? Colors.green : null,),))
      ],);
  }
}