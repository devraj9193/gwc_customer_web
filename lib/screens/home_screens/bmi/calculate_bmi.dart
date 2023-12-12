import 'dart:math';

class CalculateBmi {
  final int height;
  final int weight;
  final String gender;
  final int age;

  CalculateBmi({
    required this.gender,
    required this.age,
    required this.height,
    required this.weight,
  });

  double _bmi = 0.0;
  double bmr = 0.0;

  String calculate() {
    _bmi = weight / pow(height / 100, 2);
    print(_bmi);
    return _bmi.toStringAsFixed(1);
  }

  String calculateBmr() {
    if (gender == "male") {
      bmr = 88.362 + (13.397 * weight) + (4.799 * height) - (5.677 * age);

      return bmr.toStringAsFixed(1);
    } else if (gender == "female") {
      bmr = 447.593 + (9.247 * weight) + (3.098 * height) - (4.330 * age);
      return bmr.toStringAsFixed(1);
    }else{
      return "";
    }

  }

  String getResult() {
    if (_bmi >= 25) {
      return 'Overweight';
    } else if (_bmi >= 18.5) {
      return 'Normal';
    } else {
      return 'Underweight';
    }
  }

  String getComment() {
    if (_bmi >= 25) {
      return 'You have higher than normal weight\nPlease excercie more often.';
    } else if (_bmi >= 18.5) {
      return 'Awesome! You have a healthy body. Stay happy.';
    } else {
      return 'You have lower than normal weight\nPlease eat well.';
    }
  }
}
