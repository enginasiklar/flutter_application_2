import 'package:flutter/material.dart';
import 'package:flutter_application_2/model/predictions_short_data.dart';
import 'package:flutter_application_2/model/stock_model.dart';
import 'package:flutter_application_2/pages/search/search_model.dart';
import 'package:flutter_application_2/pages/stock_page.dart';

import '../../model/main_model.dart';

class SearchViewPage extends StatefulWidget {
  const SearchViewPage({Key? key});
  @override  State<SearchViewPage> createState() => _SearchViewPageState();}
class _SearchViewPageState extends State<SearchViewPage> {
  TextEditingController searchTextController = TextEditingController();
  List<Stock> _auxStockList = [];
  @override  void initState() {
    _auxStockList.addAll(Stock.stockListFromMainData(MainModel.data));
    super.initState();  }
  @override  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: TextField(
          controller: searchTextController,
          decoration: const InputDecoration(labelText: 'Search'),
          onChanged: (value) {setState(() { _auxStockList = SearchModel.getListFromQuery(value);});},),),
      body: Column( children: [ Expanded(child: ListView.separated(
              itemCount: _auxStockList.length, itemBuilder: (context, index) { return ListTile(
                  title: Text(_auxStockList[index].ticker), subtitle: Text(_auxStockList[index].name),
                  trailing: SizedBox( height: 50,width: 80,
                    child: FutureBuilder( future: PredictionsData.getChangedValue(_auxStockList[index].ticker),
                      initialData: '#',builder: (BuildContext context, AsyncSnapshot snapshot) {
                        final percentageChange = MainModel.data[_auxStockList[index].ticker]?.todayValue != null &&
                            MainModel.data[_auxStockList[index].ticker]?.yesterdayValue != null
                            ? ((MainModel.data[_auxStockList[index].ticker]?.todayValue ?? 0) -
                            (MainModel.data[_auxStockList[index].ticker]?.yesterdayValue ?? 0)) /
                            (MainModel.data[_auxStockList[index].ticker]?.yesterdayValue ?? 0) * 100  : 0;
                        Color textColor = percentageChange < 0 ? Colors.red : Colors.green;
                        return Text( '${percentageChange.toStringAsFixed(2)}%',
                          style: TextStyle(color: textColor, fontSize: 15),  );     }, ),),
                  onTap: () { Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                      return StockPage(stockCode: _auxStockList[index].ticker, stockName: _auxStockList[index].name,);}));},);},
              separatorBuilder: (context, index) => Divider(), ),    ),   ],      ),    );  }}


