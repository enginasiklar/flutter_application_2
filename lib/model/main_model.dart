class MainModel {
  MainModel({
    required this.firstDate,
    required this.lastDate,
    required this.lastMonthPred,
    required this.lastMonthValue,
    required this.lastWeekPred,
    required this.lastWeekValue,
    required this.name,
    required this.todayPred,
    required this.todayValue,
    required this.yesterdayPred,
    required this.yesterdayValue,
  });

  final String firstDate;
  final String lastDate;
  final double? lastMonthPred;
  final double lastMonthValue;
  final double? lastWeekPred;
  final double lastWeekValue;
  final String name;
  final double? todayPred;
  final double todayValue;
  final double? yesterdayPred;
  final double yesterdayValue;

  factory MainModel.fromJson(Map<String, dynamic> json) {
    return MainModel(
      firstDate: json['firstDate'] ?? '',
      lastDate: json['lastDate'] ?? '',
      lastMonthPred: json['lastMonthPred']?.toDouble(),
      lastMonthValue: json['lastMonthValue'].toDouble(),
      lastWeekPred: json['lastWeekPred']?.toDouble(),
      lastWeekValue: json['lastWeekValue'].toDouble(),
      name: json['name'] ?? '',
      todayPred: json['todayPred']?.toDouble(),
      todayValue: json['todayValue'].toDouble(),
      yesterdayPred: json['yesterdayPred']?.toDouble(),
      yesterdayValue: json['yesterdayValue'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstDate': firstDate,
      'lastDate': lastDate,
      'lastMonthPred': lastMonthPred,
      'lastMonthValue': lastMonthValue,
      'lastWeekPred': lastWeekPred,
      'lastWeekValue': lastWeekValue,
      'name': name,
      'todayPred': todayPred,
      'todayValue': todayValue,
      'yesterdayPred': yesterdayPred,
      'yesterdayValue': yesterdayValue,
    };
  }

  static Map<String, MainModel>? _data;

  static set data(Map<String, MainModel> data) {
    _data = data;
  }

  static Map<String, MainModel> get data {
    if (_data == null) {
      throw Exception('MainData has not been initialized.');
    }
    return _data!;
  }
}


