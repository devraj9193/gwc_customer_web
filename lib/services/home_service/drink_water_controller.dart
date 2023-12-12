import 'package:flutter/cupertino.dart';

import '../../screens/home_screens/new_home_screen/home_widgets/drop_widget.dart';
import '../../screens/home_screens/water_intake/water_level_screen.dart';
import '../../screens/home_screens/water_intake/water_level_time.dart';
import '../../utils/app_config.dart';

enum VolumeType { ml, ltr }

const String _nofill = "assets/images/gmg/glass.png";
const String _filled = "assets/images/gmg/glass_filled.png";

class DrinkWaterController extends ChangeNotifier {
  final _pref = AppConfig().preferences;

  bool _showAddIcon = true;
  bool _showResetButton = true;
  bool get showAddIcon => _showAddIcon;
  bool get showResetButton => _showResetButton;

  int _targetMl = 0;
  int get targetMl => _targetMl;

  VolumeType _unit = VolumeType.ml;
  VolumeType get unit => _unit;

  int _oldConsumedWater = 0;

  int _currentMl = 0;
  int get currentMl => _currentMl;

  String _addTime = '';
  String get addTime => _addTime;

  int _remainingMl = 0;
  int get remainingMl => _remainingMl;

  /// how mush completed %
  double _waterProgress = -0.0;
  double get waterProgress => _waterProgress;

  /// glass quantity
  int _measureGlass = 0;
  int get measureGlass => _measureGlass;

  /// this is for showing number of glass
  int _totalGlass = 0;
  int get totalGlass => _totalGlass;

  /// for extra glass quantity
  int _remainingWaterLevelInExtraGlass = 0;
  int get remainingWaterLevelInExtraGlass => _remainingWaterLevelInExtraGlass;

  List<WaterProgressModel> _waterConsumedProgress = [];
  List<WaterProgressModel> get waterConsumedProgress => _waterConsumedProgress;

  List<String> _selectedTimeList = [];
  List<String> get selectedTimeList => _selectedTimeList;

  resetAllDetails() {
    _showAddIcon = true;
    clearLocalData(target);
    clearLocalData(glass_qunt);
    clearLocalData(current);
    clearLocalData(remain);
    clearLocalData(lvl_progress);
    clearLocalData(addSelectedTime);
    _totalGlass = 0;
    getLocalData();
    notifyListeners();
  }

  setTraget(int target1) {
    _targetMl = target1;
    _oldConsumedWater = 0;
    _currentMl = 0;
    print("before current: $_currentMl");
    clearLocalData(glass_qunt);
    clearLocalData(current);
    print("after current: $_currentMl");
    clearLocalData(lvl_progress);

    _showAddIcon = false;

    setValueToLocal(target, _targetMl.toDouble());
    _setRemaining();
    _setProgress();
    notifyListeners();
  }

  _setRemaining() {
    _remainingMl = (_targetMl - _currentMl < 0 ? 0 : _targetMl - _currentMl);
    setValueToLocal(remain, _remainingMl.toDouble());
    notifyListeners();
  }

  _setProgress() {
    var percentage = _targetMl > 0 ? _currentMl / _targetMl * 100 : 100.0;
    _waterProgress = (percentage > 100.0 ? 100.0 : percentage) / 100.0;

    print("%1: $percentage");
    print("before progressss1: $_waterProgress");

    _waterProgress = 1.0 - _waterProgress;

    print("progressss1: $_waterProgress");

    setValueToLocal(lvl_progress, _waterProgress);

    notifyListeners();
  }

  setTotalGlassFromQuant(int no) {
    _measureGlass = no;

    setValueToLocal(glass_qunt, _measureGlass.toDouble());

    if (_targetMl % no == 0) {
      _totalGlass = (_targetMl / no).round();
      _remainingWaterLevelInExtraGlass = 0;
    } else {
      _remainingWaterLevelInExtraGlass = _targetMl % no;
      _totalGlass = _targetMl ~/ no + 1;
    }
    updateWaterConsumeList();
    notifyListeners();
  }

  addConsumedWater(int consumedWater) {
    print("oldml: $_oldConsumedWater");
    _currentMl = consumedWater;
    _currentMl += _oldConsumedWater;
    _oldConsumedWater = _currentMl;
    print("_currentMl: $_currentMl");
    setValueToLocal(current, _currentMl.toDouble());
    _setRemaining();
    _setProgress();
    updateWaterConsumeList();
    notifyListeners();
  }

  updateWaterConsumeList() {
    _waterConsumedProgress.clear();
    waterConsumedProgress.clear();
    for (int i = 1;
        i <=
            ((_remainingWaterLevelInExtraGlass == 0)
                ? totalGlass
                : totalGlass - 1);
        i++) {
      _waterConsumedProgress.add(WaterProgressModel(
          qty: _measureGlass,
          path: (_getCompletedGlass(index: i) == true) ? _filled : _nofill,
          isCompleted: (_getCompletedGlass(index: i) == true) ? true : false,
          waterLevel: _getGlassProgress(index: i)));
    }
    if (_remainingWaterLevelInExtraGlass != 0) {
      _waterConsumedProgress.add(WaterProgressModel(
          qty: _remainingWaterLevelInExtraGlass,
          path: _getCompletedGlass(isExtraGlass: true) ? _filled : _nofill,
          isCompleted: false,
          waterLevel: _getGlassProgress(isExtraGlass: true)));
    }
  }

  _getCompletedGlass({int? index, bool isExtraGlass = false}) {
    print("_getCompletedGlass");
    if (!isExtraGlass) {
      if (_targetMl >= _currentMl) {
        print(_measureGlass * index! <= _currentMl);
        return (_measureGlass * index <= _currentMl);
      } else {
        return true;
      }
    } else {
      return true;
    }
  }

  static const target = "target";
  static const current = "current";
  static const remain = "remain";
  static const lvl_progress = "progress";

  static const glass_qunt = "glass_qunt";
  static const waterConsumedString = "water_consumed";

  static const addSelectedTime = "addSelectedTime";

  setValueToLocal(String key, double value) {
    _pref!.setDouble(key, value);
  }

  setTimeValueToLocal(String key, String value) {
    _pref!.setString(key, value);
  }

  clearLocalData(String key) {
    if (checkKeyExist(key)) {
      _pref!.remove(key).then((value) {
        print("$key removed");
        print(checkKeyExist(key));
      });
    }
  }

  getValueFromLocal(String key) {
    return _pref!.getDouble(key);
  }

  getTimeValueFromLocal(String key) {
    return _pref!.getString(key);
  }

  checkKeyExist(String key) {
    return _pref!.containsKey(key);
  }

  getLocalData() {
    print(checkKeyExist(target));
    print(getValueFromLocal(target));
    if (checkKeyExist(target)) {
      _targetMl = getValueFromLocal(target).toInt();
    } else {
      _targetMl = 0;
    }
    if (checkKeyExist(current)) {
      _oldConsumedWater = getValueFromLocal(current).toInt();
      _currentMl = getValueFromLocal(current).toInt();
    } else {
      _oldConsumedWater = 0;
      _currentMl = 0;
    }
    if (checkKeyExist(remain)) {
      _remainingMl = getValueFromLocal(remain).toInt();
    } else {
      _remainingMl = 0;
    }
    if (checkKeyExist(lvl_progress)) {
      _waterProgress = getValueFromLocal(lvl_progress);
    } else {
      _waterProgress = 1.0;
    }
    if (checkKeyExist(glass_qunt)) {
      _measureGlass = getValueFromLocal(glass_qunt).toInt();
      setTotalGlassFromQuant(_measureGlass);
    } else {
      _measureGlass = 0;
    }

    if(checkKeyExist(addSelectedTime)){
      _addTime = getTimeValueFromLocal(addSelectedTime);
    }

    if (_targetMl != 0) {
      _showAddIcon = false;
    }

    print("targetMl:  $targetMl");
    print(current);
    print(remain);
    print(lvl_progress);

    // updateWaterConsumeList();
  }

  _getGlassProgress({int? index, bool isExtraGlass = false}) {
    print("_getGlassProgress: $_currentMl $_measureGlass");
    if (_currentMl == 0) {
      return 1.0;
    } else {
      if (!isExtraGlass) {
        if (_currentMl > _measureGlass) {
          if (_currentMl % _measureGlass == 0) {
            return 0.0;
          } else {
            int _cnt = (_currentMl / _measureGlass).toInt();
            if (index! <= _cnt) {
              print("if $index");
              return 0.0;
            }
            // to fill the half of the glass if there is a remainder when divided
            else if (index == _cnt + 1) {
              print("elif $index _cnt++: $_cnt");
              int _incompleteGlass = (_currentMl % _measureGlass).toInt();
              return _setGlassProgress(_incompleteGlass, _measureGlass);
            } else {
              print("else $index");
              return 1.0;
            }
          }
        } else {
          //if _current < glass qty
          if (index == 1) {
            return _setGlassProgress(_currentMl, _measureGlass);
          } else {
            return 1.0;
          }
        }
      } else {
        if (_currentMl > _targetMl) {
          return 0.0;
        } else if (_remainingWaterLevelInExtraGlass >=
            (_targetMl - _currentMl)) {
          int _incompleteGlass = (_targetMl - _currentMl).toInt();
          return _setGlassProgress(
              _incompleteGlass, _remainingWaterLevelInExtraGlass);
        } else {
          return 1.0;
        }
        // int _cnt = _currentMl % _measureGlass
      }
    }
  }

  _setGlassProgress(num value, int targetValue) {
    var percentage = value > 0 ? value / targetValue * 100 : 100.0;
    double _glassProgress = (percentage > 100.0 ? 100.0 : percentage) / 100.0;

    print("incompleted: $value");
    print("%1 glass: $percentage");
    print("before progressss1 glass: $_glassProgress");

    _glassProgress = 1.0 - _glassProgress;

    print("_glassProgress: $_glassProgress");

    return _glassProgress;
  }

  DrinkWaterController() {
    print("constructor");
    print("totalGlasss: $_totalGlass");
    getLocalData();
    updateWaterConsumeList();
  }

  //  Timer Controller  //
  resetTimeDetails() {
    _showResetButton = true;
    clearLocalData(addSelectedTime);
    getLocalData();
    notifyListeners();
  }

  setTimeTarget(String selectedTime) {
    _addTime = selectedTime;

    _showResetButton = false;

    setTimeValueToLocal(addSelectedTime, _addTime);
    updateSelectedTimeList();
    notifyListeners();
  }

  addConsumedTime(String consumedTime) {
    print("oldml: $_oldConsumedWater");
    _addTime = consumedTime;
    setTimeValueToLocal(addSelectedTime, _addTime);
    _setRemaining();
    _setProgress();
    updateSelectedTimeList();
    notifyListeners();
  }

  updateSelectedTimeList() {
    _selectedTimeList.clear();
    selectedTimeList.clear();
    _selectedTimeList.add(
        _addTime
    );
  }
}
