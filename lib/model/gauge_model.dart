
class Sentiment {
  Sentiment({
    required this.data,
  });

  List<SentData> data;

  factory Sentiment.fromJson(Map<String, dynamic> json) => Sentiment(
    data: List<SentData>.from(json["data"].map((x) => SentData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class SentData {
  SentData({
    required this.value,
    required this.valueClassification,
  });

  String value;
  String valueClassification;

  factory SentData.fromJson(Map<String, dynamic> json) => SentData(
    value: json["value"],
    valueClassification: json["value_classification"],
  );

  Map<String, dynamic> toJson() => {
    "value": value,
    "value_classification": valueClassification,
  };
}