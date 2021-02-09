import 'package:shared_preferences/shared_preferences.dart';

class SPService {
  static void initFirstAppStart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("isFirstStart", false);
  }

  static Future<bool> isFirstStart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return !prefs.containsKey("isFirstStart");
  }

  static Future<List<String>> getCompanies() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList("companies");
  }

  static Future<bool> addCompany(String newCompany) async {
    List<String> companies = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("companies")) {
      companies = prefs.getStringList("companies");
    }
    companies.add(newCompany);
    return prefs.setStringList("companies", companies);
  }

  static Future<bool> deleteCompany(String data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> companies = [];
    if (prefs.containsKey("companies")) {
      companies = prefs.getStringList("companies");
    }

    companies.remove(data);
    return prefs.setStringList("companies", companies);
  }
}
