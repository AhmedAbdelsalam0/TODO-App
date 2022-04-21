import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeServices {

  final GetStorage _box = GetStorage();
  final _key = "isDarkMode";

  _saveThemeToBox(bool isDarkMode) =>
    _box.write(_key, isDarkMode);


  bool _loadThemeFromBox()
     => _box.read<bool>(_key) ?? false;  // if it is null then return false


  ThemeMode get theme => _loadThemeFromBox()? ThemeMode.dark : ThemeMode.light;

  void switchTheme(){
    Get.changeThemeMode( _loadThemeFromBox() ? ThemeMode.light : ThemeMode.dark);
    // if _loadThemeFromBox() is true , then it is dark ,, so switch to light ...
    _saveThemeToBox(!_loadThemeFromBox());  // then save the new value
  }



}
