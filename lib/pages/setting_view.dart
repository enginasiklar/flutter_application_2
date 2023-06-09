import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

//TODO: add italian
class SettingViewPage extends StatelessWidget {
  SettingViewPage({super.key});
  final TextEditingController langController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final List<DropdownMenuEntry<Locale>> langEntries =
        <DropdownMenuEntry<Locale>>[];
    for (var element in context.supportedLocales) {
      langEntries.add(DropdownMenuEntry<Locale>(
          value: element, label: element.languageCode));
    }
    return Scaffold(
      appBar: AppBar(title: Text(tr("main.setting"))),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(tr("setting.lang")),
              DropdownMenu<Locale>(
                initialSelection: context.locale,
                controller: langController,
                dropdownMenuEntries: langEntries,
                onSelected: (value) {
                  if (value == null) {
                    context.setLocale(const Locale("en"));
                  } else {
                    context.setLocale(value);
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
