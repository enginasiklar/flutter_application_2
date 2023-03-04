import 'package:flutter/material.dart';
import 'package:flutter_application_2/model/predictions_short_data.dart';
import 'package:flutter_application_2/model/stock_model.dart';
import 'package:flutter_application_2/pages/predict_grid/predict_grid_model.dart';
import 'package:flutter_application_2/pages/search/search_model.dart';
import 'package:flutter_application_2/pages/stock_page.dart';

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
                  width: 80,
                  child: FutureBuilder(
                    future: PredictionsShortData.getChangedValue(
                        _auxStockList[index].ticker),
                    initialData: '#',
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.data.toString().contains("#")) {
                        return Text(
                          "${snapshot.data}",
                          style: TextStyle(color: PredictGrid.blue),
                        );
                      } else if (snapshot.data.toString().contains("-")) {
                        return Text(
                          "${snapshot.data}%",
                          style: const TextStyle(
                              color: PredictGrid.red, fontSize: 15),
                        );
                      } else {
                        return Text(
                          "${snapshot.data}%",
                          style: const TextStyle(
                              color: PredictGrid.green, fontSize: 15),
                        );
                      }
                    },
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
