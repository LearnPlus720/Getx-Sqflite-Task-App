import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class ThemeService{
    final _box = GetStorage();
    final _key = 'isDarkMode';
    _savethemeToBox(bool isDarkMode) => _box.write(_key, isDarkMode);
    // if this is a value return true if not return false
    bool _loadThemeFromBox() => _box.read(_key)??false;

    // if true make it dark mode else light mode
    ThemeMode get theme => _loadThemeFromBox()?ThemeMode.dark:ThemeMode.light;

    void switchTheme(){
        Get.changeThemeMode(_loadThemeFromBox()?ThemeMode.light:ThemeMode.dark);
        _savethemeToBox(!_loadThemeFromBox());

    }

    bool iSDarkTheme(){
        return _box.read(_key)??false;
    }

}