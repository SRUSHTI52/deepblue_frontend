import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/category_model.dart';

class EducationService {
  static Future<List<Category>> loadCategories() async {
    final jsonString =
    await rootBundle.loadString('assets/data/education_content.json');
    final data = jsonDecode(jsonString);

    return (data['categories'] as List)
        .map((e) => Category.fromJson(e))
        .toList();
  }
}
