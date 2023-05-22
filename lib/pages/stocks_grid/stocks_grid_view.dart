import 'package:flutter/material.dart';
import 'package:flutter_application_2/pages/stock_page.dart';
import 'package:flutter_application_2/pages/stocks_grid/stocks_grid_model.dart';
import '../../model/main_model.dart';

class StocksGridView extends StatelessWidget { StocksGridView({Key? key});
  final List<StocksGrid> data = StocksGrid.getData(MainModel.data);
  @override  Widget build(BuildContext context) {
    return Column(children: [SizedBox(height: 20), // Add space at the top
        const Padding(padding: EdgeInsets.all(15.0), child: Text("Most Popular Stocks",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),),),
        const Divider(), // Add a separating line
        Expanded(child: GridView.builder(gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 150,),
            itemCount: data.length,itemBuilder: (BuildContext context, int index) {
              return GestureDetector(onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                    return StockPage(stockCode: data[index].stock.ticker, stockName: data[index].stock.name,);}));},
                child: Card(margin: const EdgeInsets.all(5),
                  color: data[index].color,child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text(data[index].name),
                      Text('${data[index].percentage.toStringAsFixed(2)}%',  ),  ], ),),);},),),],);}}


