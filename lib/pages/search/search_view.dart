import 'package:flutter/material.dart';
import 'package:flutter_application_2/model/stock_model.dart';
import 'package:flutter_application_2/pages/search/search_model.dart';
import 'package:flutter_application_2/pages/stock_page.dart';
import 'package:flutter_application_2/pages/change_in_data.dart';

class SearchViewPage extends StatefulWidget {
  const SearchViewPage({super.key});

  @override
  State<SearchViewPage> createState() => _SearchViewPageState();
}

class _SearchViewPageState extends State<SearchViewPage> {
  TextEditingController searchTextController = TextEditingController();

  List<Stock> _auxStockList = [];
  @override
  void initState() {
    _auxStockList.addAll(Stock.stockList);
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
              _auxStockList = SearchModel.getListFromQuery(value);
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
                trailing: SizedBox(
                  height: 50,
                  width: 115,
                  child: StockChange.getChangeWidget(
                    index.toDouble() + 1,
                    index.toDouble() - 2,
                  ),
                ),
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
}
