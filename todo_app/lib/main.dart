import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:todo_app/db/db_helper.dart';
import 'package:todo_app/services/theme_services.dart';
import 'package:todo_app/ui/theme.dart';

import 'ui/pages/home_page.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();  // it is important because of async
  await DBHelper.initDB();
  await GetStorage.init();
  runApp(const MyApp());
  //NotifyHelper().initializeNotification();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: Themes.light,
      darkTheme: Themes.dark,   // Class name with static property
      themeMode: ThemeServices().theme,   // object of class with getter property
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: const HomePage(),

      //home: const NotificationScreen(payload: "title|description|5/1/2022",),
    );
  }
}
