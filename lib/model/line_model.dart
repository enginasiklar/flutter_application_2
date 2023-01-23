
import 'dart:convert';

List<LineData> LineDataFromJson(String str) =>
    List<LineData>.from(json.decode(str).map((x) => LineData.fromJson(x)));

String LineDataToJson(List<LineData> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LineData {
  LineData({
    required this.date,required this.close,required this.prediction
  });

  String date;
  double close;
  double prediction;
  factory LineData.fromJson(Map<String, dynamic> json) => LineData(
      date: json['date'],
      close: json['close'],
      prediction:json['prediction'],
  );

  Map<String, dynamic> toJson() => {
    "date": date,
    "close": close,
    "prediction": prediction
  };
}

