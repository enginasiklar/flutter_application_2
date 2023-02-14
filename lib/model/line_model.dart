import 'dart:convert';

List<LineData> lineDataFromJson(String str) =>
    List<LineData>.from(json.decode(str).map((x) => LineData.fromJson(x)));

String lineDataToJson(List<LineData> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LineData {
  LineData({required this.date, required this.close, required this.prediction});

  String date;
  double close;
  double prediction;
  factory LineData.fromJson(Map<String, dynamic> json) {
    String date = '';
    double close = 0;
    double prediction = 0;
    if (json.containsKey('date')) {
      date = json['date'];
    }
    if (json.containsKey('close')) {
      close = json['close'];
    }
    if (json.containsKey('prediction')) {
      prediction = json['prediction'];
    }
    return LineData(
      date: date,
      close: close,
      prediction: prediction,
    );
  }

  Map<String, dynamic> toJson() =>
      {"date": date, "close": close, "prediction": prediction};
}
