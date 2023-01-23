// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:flutter_application_2/model/line_model.dart';
import 'package:flutter_application_2/services/api_service.dart';
import 'model/user_model.dart';

class PricePoint {
  final double x;
  final double y;
  PricePoint({required this.x, required this.y});
}

Future<List<PricePoint>> getPricePoints() async {
  final data = <double>[
    2,
  ];
  List<UserModel> numbers = await ApiService().getUsers();
  for (int i = 0; i < numbers.length; i++) {
    double a = double.parse(numbers[i].value.toString());
    data.add(a);
  }
  return data
      .mapIndexed(
          (index, element) => PricePoint(x: index.toDouble(), y: element))
      .toList();
}


Future<List<Map<String, dynamic>>> getPredictionPoints() async {
  List<Map<String, dynamic>> datePriceList = [];
  List<LineData> numbers = await ApiService().getLineData();
  for (int i = 0; i < numbers.length; i++) {
    String a = numbers[i].date.toString();
    double b = double.parse(numbers[i].prediction.toString());

    datePriceList.add({
      'date': a,
      'prediction': b
    });

  }

  return datePriceList;
}