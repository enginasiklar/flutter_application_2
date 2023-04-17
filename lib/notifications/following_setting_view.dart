import 'package:flutter/material.dart';
import 'package:flutter_application_2/notifications/followed_stock_model.dart';
import 'package:provider/provider.dart';

class FollowingSettingView {
  static double _currentValue = 0.0;
  static showAlertDialog(BuildContext context, String title, String code) {
    var aux = FollowedStocksModel()
        .items
        .where((element) => element.stockCode == code)
        .first
        .limitValue;
    if (aux != null) {
      _currentValue = aux;
    } else {
      _currentValue = 1;
    }
    // set up the button
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        Provider.of<FollowedStocksModel>(context, listen: false)
            .updateLimitValue(code, (_currentValue * 10).round() / 10);
        Navigator.of(context).pop();
      },
    );
    Widget cancleButton = TextButton(
      child: const Text("CANCLE"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Column(
        children: [
          Text(title),
          const SizedBox(
            height: 5,
          ),
          const Text(
            "Change the notification minimum value:",
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
      content: StatefulBuilder(
        builder: (BuildContext context, setState) {
          return SizedBox(
            height: 90,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  ((_currentValue * 10).round() / 10).toString(),
                  style: const TextStyle(fontSize: 20),
                ),
                Slider(
                  value: _currentValue,
                  max: 10,
                  divisions: 50,
                  // label: ((currentValue * 10).round() / 10).toString(),
                  onChanged: (value) {
                    setState(
                      () {
                        _currentValue = value;
                      },
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
      actions: [
        okButton,
        cancleButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
