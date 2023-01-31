import 'package:flutter/material.dart';
import 'package:flutter_application_2/model/stock_model.dart';
import 'package:flutter_application_2/pages/stock_page.dart';

class SearchViewPage extends StatefulWidget {
  const SearchViewPage({super.key});

  @override
  State<SearchViewPage> createState() => _SearchViewPageState();
}

class _SearchViewPageState extends State<SearchViewPage> {
  TextEditingController searchTextController = TextEditingController();
  final List<Stock> _stockList = [
    Stock('AAPL', 'Apple Inc.'),
    Stock('AMZN', 'Amazon.com Inc.'),
    Stock('GOOG', 'Alphabet Inc.'),
    Stock('MSFT', 'Microsoft Corporation'),
    Stock('EBAY', 'Ebay Inc.'),
    Stock('ADBE', 'Adobe Inc.'),
    Stock('TSLA', 'Tesla Inc.'),
  ];
  List<Stock> _auxStockList = [];
  @override
  void initState() {
    _auxStockList.addAll(_stockList);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchTextController,
          decoration: const InputDecoration(labelText: 'Search'),
          onChanged: (value) {
            setState(() {
              _auxStockList = getListFromQuery(value);
            });
          },
        ),
      ),
      body: Column(children: [
        Expanded(
          child: ListView.builder(
            itemCount: _auxStockList.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(_auxStockList[index].ticker),
                subtitle: Text(_auxStockList[index].name),
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (BuildContext context) {
                    // return const stockPage();
                    return StockPage(
                      stockCode: _auxStockList[index].ticker,
                      stockName: _auxStockList[index].name,
                    );
                  }));
                },
              );
            },
          ),
        )
      ]),
    );
  }

  List<Stock> getListFromQuery(String query) {
    return _stockList
        .where((element) =>
            element.ticker.contains(RegExp(query, caseSensitive: false)) ||
            element.name.contains(RegExp(query, caseSensitive: false)))
        .toList();
  }
}
