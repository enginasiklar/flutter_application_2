// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:flutter_application_2/services/api_service.dart';
import 'model/user_model.dart';

List<UserModel>? list_copy;

void convertFutureListToList() async {
  Future<List<UserModel>?> _userModel = (ApiService().getUsers());
  List<UserModel>? list = await _userModel;
  list_copy = list;
}

class PricePoint {
  final double x;
  final double y;
  PricePoint({required this.x, required this.y});
}

List<PricePoint> get pricePoints {
  convertFutureListToList();

  final data = <double>[
    2,
  ];
  print(list_copy);
  for (int i = 0; i < list_copy!.length; i++) {
    double a = double.parse(list_copy![i].close.toString());
    data.add(a);
  }
  return data
      .mapIndexed((index, element) =>
          PricePoint(x: index.toDouble(), y: element.toDouble()))
      .toList();
}
