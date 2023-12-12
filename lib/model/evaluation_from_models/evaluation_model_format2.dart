import 'dart:convert';

class EvaluationModelFormat2{
  String vegNonVegVegan;
  String? vegNonVegVeganOther;
  String earlyMorning;
  String breakfast;
  String midDay;
  String lunch;
  String evening;
  String dinner;
  String postDinner;
  String digesion;
  String diet;
  String foodAllergy;
  String intolerance;
  String cravings;
  String dislikeFood;
  String glasses_per_day;
  String habits;
  String? habits_other;
  String mealPreference;
  String? mealPreferenceOther;
  String hunger;
  String? hungerOther;
  String bowelPattern;
  String? bowelPatterOther;
  String? part;

  EvaluationModelFormat2(
      {
        required this.vegNonVegVegan,
        this.vegNonVegVeganOther,
        required this.earlyMorning,
        required this.breakfast,
        required this.midDay,
        required this.lunch,
        required this.evening,
        required this.dinner,
        required this.postDinner,
        required this.digesion,
      required this.diet,
      required this.foodAllergy,
      required this.intolerance,
      required this.cravings,
      required this.dislikeFood,
      required this.glasses_per_day,
      required this.habits,
      this.habits_other,
      required this.mealPreference,
      this.mealPreferenceOther,
      required this.hunger,
      this.hungerOther,
      required this.bowelPattern,
      this.bowelPatterOther,
        this.part,
      });

  Map<String, dynamic> toMap() {
    final Map<String, String> data = new Map<String, String>();
    data['veg_nonveg_vegan'] = this.vegNonVegVegan;
    if(vegNonVegVeganOther!.isNotEmpty) data['veg_nonveg_vegan_other'] = this.vegNonVegVeganOther!;
    data['early_morning'] = this.earlyMorning;
    data['breakfast'] = this.breakfast;
    data['mid_day'] = this.midDay;
    data['lunch'] = this.lunch;
    data['evening'] = this.evening;
    data['dinner'] = this.dinner;
    data['post_dinner'] = this.postDinner;

    data['mention_if_any_food_affects_your_digesion'] = this.digesion;
    data['any_special_diet'] = this.diet;
    data['any_food_allergy'] = this.foodAllergy;
    data['any_intolerance'] = this.intolerance;
    data['any_severe_food_cravings'] = this.cravings;
    data['any_dislike_food'] = this.dislikeFood;
    data['no_galsses_day'] = this.glasses_per_day;
    data['any_habbit_or_addiction[]'] = this.habits;
    if(habits_other!.isNotEmpty) data['any_habbit_or_addiction_other'] = this.habits_other!;
    data['after_meal_preference'] = this.mealPreference;
    if(mealPreferenceOther!.isNotEmpty) data['after_meal_preference_other'] = this.mealPreferenceOther!;
    data['hunger_pattern'] = this.hunger;
    if(hungerOther!.isNotEmpty) data['hunger_pattern_other'] = this.hungerOther!;
    data['bowel_pattern'] = this.bowelPattern;
    if(bowelPatterOther!.isNotEmpty) data['bowel_pattern_other'] = this.bowelPatterOther!;
    data['part'] = this.part!;
    return data;
  }

  factory EvaluationModelFormat2.fromMap(Map<String, dynamic> map) {
    return EvaluationModelFormat2(
      vegNonVegVegan: map['vegNonVegVegan'] as String,
      vegNonVegVeganOther: map['veg_nonveg_vegan_other'] as String,
      earlyMorning: map['earlyMorning'] as String,
      breakfast: map['breakfast'] as String,
      midDay: map['midDay'] as String,
      lunch: map['lunch'] as String,
      evening: map['evening'] as String,
      dinner: map['dinner'] as String,
      postDinner: map['postDinner'] as String,
      digesion: map['digesion'] as String,
      diet: map['diet'] as String,
      foodAllergy: map['foodAllergy'] as String,
      intolerance: map['intolerance'] as String,
      cravings: map['cravings'] as String,
      dislikeFood: map['dislikeFood'] as String,
      glasses_per_day: map['glasses_per_day'] as String,
      habits: map['habits'] as String,
      habits_other: map['habits_other'] as String,
      mealPreference: map['mealPreference'] as String,
      mealPreferenceOther: map['mealPreferenceOther'] as String,
      hunger: map['hunger'] as String,
      hungerOther: map['hungerOther'] as String,
      bowelPattern: map['bowelPattern'] as String,
      bowelPatterOther: map['bowelPatterOther'] as String,
      part : map['part'] as String
    );
  }

}