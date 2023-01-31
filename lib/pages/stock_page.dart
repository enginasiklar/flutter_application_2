import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import '../model/stock_model.dart';
import '../services/api_service.dart';

//TODO more memory efficient graph data loading using the time constrained calling of api

class stockPage extends StatefulWidget {
  const stockPage({super.key});

  @override
  _stockPageState createState() => _stockPageState();
}

class _stockPageState extends State<stockPage> {
  late Future<List<StockData>> _chartData;
  final TrackballBehavior _trackballBehavior =
      TrackballBehavior(enable: true, activationMode: ActivationMode.singleTap);
  String _stockCode = 'AAPL'; // default stock code
  final List<Stock> _stockList = [
    Stock('AAPL', 'Apple Inc.'),
    Stock('AMZN', 'Amazon.com Inc.'),
    Stock('GOOG', 'Alphabet Inc.'),
    Stock('MSFT', 'Microsoft Corporation'),
    Stock('EBAY', 'Ebay Inc.'),
    Stock('ADBE', 'Adobe Inc.'),
    Stock('TSLA', 'Tesla Inc.'),
  ]; // list of stocks
  bool _stockListVisible = false; // visibility of stock list
  String _filter = '';

  @override
  void initState() {
    super.initState();
    _chartData = ApiService().fetchStockData(_stockCode);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Column(children: <Widget>[
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                decoration:
                    const InputDecoration(labelText: 'Enter stock code'),
                onChanged: (value) {
                  _filter = value.toLowerCase();
                  setState(() {
                    _stockListVisible = true;
                  });
                },
                onTap: () {
                  setState(() {
                    _stockListVisible = !_stockListVisible;
                  });
                },
              ),
            ),
          ],
        ),
      ),
      _stockListVisible
          ? Expanded(
              child: ListView.builder(
              itemCount: _stockList
                  .where((stock) =>
                      stock.name.toLowerCase().contains(_filter) ||
                      stock.ticker.toLowerCase().contains(_filter))
                  .toList()
                  .length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_stockList
                      .where((stock) =>
                          stock.name.toLowerCase().contains(_filter) ||
                          stock.ticker.toLowerCase().contains(_filter))
                      .toList()[index]
                      .ticker),
                  subtitle: Text(_stockList
                      .where((stock) =>
                          stock.name.toLowerCase().contains(_filter) ||
                          stock.ticker.toLowerCase().contains(_filter))
                      .toList()[index]
                      .name),
                  onTap: () {
                    setState(() {
                      _stockCode = _stockList
                          .where((stock) =>
                              stock.name.toLowerCase().contains(_filter) ||
                              stock.ticker.toLowerCase().contains(_filter))
                          .toList()[index]
                          .ticker;
                      _chartData = ApiService().fetchStockData(_stockCode);
                      _stockListVisible = false;
                    });
                  },
                );
              },
            ))
          : Container(),
      Expanded(
          child: FutureBuilder<List<StockData>>(
        future: _chartData,
        builder:
            (BuildContext context, AsyncSnapshot<List<StockData>> snapshot) {
          if (snapshot.hasData) {
            List<StockData> chartSampleData = snapshot.data!.map((data) {
              return StockData(
                  date: data.date,
                  lowPrice: data.lowPrice,
                  highPrice: data.highPrice,
                  openingPrice: data.openingPrice,
                  closingPrice: data.closingPrice);
            }).toList();
            return SfCartesianChart(
              zoomPanBehavior: ZoomPanBehavior(
                  enableDoubleTapZooming: true, enablePanning: true),
              title: ChartTitle(text: _stockCode),
              trackballBehavior: _trackballBehavior,
              series: <CandleSeries>[
                CandleSeries<StockData, DateTime>(
                    dataSource: chartSampleData,
                    name: _stockCode,
                    xValueMapper: (StockData sales, _) => sales.date,
                    lowValueMapper: (StockData sales, _) => sales.lowPrice,
                    highValueMapper: (StockData sales, _) => sales.highPrice,
                    openValueMapper: (StockData sales, _) => sales.openingPrice,
                    closeValueMapper: (StockData sales, _) =>
                        sales.closingPrice)
              ],
              primaryXAxis: DateTimeAxis(
                  dateFormat: DateFormat.MMM(),
                  majorGridLines: const MajorGridLines(width: 0)),
              primaryYAxis: NumericAxis(
                  numberFormat: NumberFormat.simpleCurrency(decimalDigits: 0)),
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return const CircularProgressIndicator();
        },
      ))
    ])));
  }
}
