import 'package:flutter/cupertino.dart';

class CheckState extends ChangeNotifier{
  bool _isChanged = false;
  bool get isChanged => _isChanged;

  bool _oldValue = false;

  setValue(bool value){
    _isChanged = value;
    _oldValue = _isChanged;
    notifyListeners();
  }

  updateValue(value){
    print("chkstate updated");
    _isChanged = value;
    updateWhenChange();
  }


  updateWhenChange(){
    if(_oldValue != _isChanged){
      _oldValue = _isChanged;
      notifyListeners();
    }
  }
}