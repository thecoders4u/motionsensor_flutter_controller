import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart'
    as http; // add the http plugin in pubspec.yaml file.
import 'package:http/http.dart';
import 'allclasses.dart';
import 'package:quiver/async.dart';

class Services {
  static const TEMP = 'https://the5miles.com/actions.php';

  static int start = 60;
  static int current = 60;
  static Uri ROOT = Uri.parse(TEMP);
  static const _CREATE_TABLE_ACTION = 'CREATE_TABLE';
  static const _GET_ALL_ACTION = 'GET_ALL_DEFAULT_PLACES';
  static const GET_USER_SETTINGS = 'GET_USER_SETTINGS';
  static const SAVE_SETTINGS = 'SAVE_SETTINGS';
  static const _ADD_EMP_ACTION = 'ADD_';
  static const _ADD_CUSTOMER = 'ADD_CUSTOMER';
  static const _LOG_CUSTOMER = 'LOGIN_CUSTOMER';
  static const _UPDATE_EMP_ACTION = 'UPDATE_EMP';
  static const _DELETE_EMP_ACTION = 'DELETE_EMP';
  static const _GET_ALL_CUSTOM = 'GET_ALL_DEFCUSTOM';
  static const _UPDATE_SETTINGS = 'UPDATE_USER_SETTINGS';
  static late List<UserSettings> allsettings = [];
  static late List<Customer> realcustomer = [];

  static late List<Alert> myalerts = [];
  static late List<Alert> falsealerts = [];
  static late List<Alert> objectalerts = [];
  static late List<Alert> criminalalerts = [];
  static late List<Alert> motionalerts = [];
  static late List<DataRow> motionrows = [];
  static late List<DataRow> objectrows = [];
  static late List<DataRow> criminalrows = [];
  static late List<DataRow> falserows = [];


  static late List<Evidence> myevidence = [];

  static late Map<String, dynamic> currentsettings = {};
  static late Map<dynamic, dynamic> cameramessages = {};

  // Method to create the table Employees.
  static Future<String> createTable() async {
    try {
      // add the parameters to pass to the request.
      var map = <String, dynamic>{};
      map['action'] = _CREATE_TABLE_ACTION;
      final response = await http.post(ROOT, body: map);
      print('Create Table Response: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }
  static Future<String> setAlertToFalse(String alertid) async {
    try {

      // add the parameters to pass to the request.
      var map = <String, dynamic>{};
      map['action'] = 'FALSE_ALERTS';
      map['alertid'] = alertid;
      final response = await http.post(ROOT, body: map);
      print('Create Table Response: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }


  static Future<List<Employee>> getEmployees() async {
    try {
      var map = <String, dynamic>{};
      map['action'] = _GET_ALL_ACTION;
      final response = await post(ROOT, body: map);
      print('getEmployees Response: ${response.body}');
      print('hello4');
      List<Employee> data = parseResponse(response.body);
      print(data);
      return data;
    } catch (e) {
      print(e);
      return <Employee>[]; // return an empty list on exception/error
    }
  }
  static Future<List<Alert>> getAlerts(String customerid) async {
    try {
      var map = <String, dynamic>{};
      map['action'] = 'GET_ALERTS';
      map['customerid'] = customerid;
      final response = await post(ROOT, body: map);
      print('getAlerts Response: ${response.body}');
      print('hello4');
      List<Alert> data = parseAlertResponse(response.body);
      print(data);
      return data;
    } catch (e) {
      print(e);
      return <Alert>[]; // return an empty list on exception/error
    }
  }
  static Future<List<UserSettings>> getUserSettings() async {
    try {
      var map = <String, dynamic>{};
      map['action'] = GET_USER_SETTINGS;
      final response = await post(ROOT, body: map);
      print('getUserSetings Response: ${response.body}');
      print('hello4');
      List<UserSettings> data = parseSettingsResponse(response.body);
      print(data);
      return data;
    } catch (e) {
      print(e);
      return <UserSettings>[]; // return an empty list on exception/error
    }
  }
  static Future<String> saveSettings(Map<String, dynamic> mappy) async{
    try{
      final response = await post(ROOT, body: mappy);
      String result = 'saving settings:' + response.body;
      print(result);
      return result;
    }
    catch(e){
      return 'failed';
    }
  }
  static Future<List<DefaultPlace>> getsetPlaces(
      String region, String district) async {
    try {
      var map = <String, dynamic>{};
      if (region != '' || district != '') {
        map['action'] = _GET_ALL_CUSTOM;
        map['region'] = region;
        map['district'] = district;
      } else {
        map['action'] = _GET_ALL_ACTION;
      }
      final response = await post(ROOT, body: map);
      print('getsetPlaces Response: ${response.body}');
      List<DefaultPlace> data = parseDefResponse(response.body);
      return data;
    } catch (e) {
      print(e);
      return <DefaultPlace>[];
    }
  }

  static List<Employee> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Employee>((json) => Employee.fromJson(json)).toList();
  }
  static List<Evidence> parseEviResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Evidence>((json) => Evidence.fromJson(json)).toList();
  }

  static List<UserSettings> parseSettingsResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<UserSettings>((json) => UserSettings.fromJson(json))
        .toList();
  }

  static List<DefaultPlace> parseDefResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<DefaultPlace>((json) => DefaultPlace.fromJson(json))
        .toList();
  }

  static List<Customer> parseCustomerResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Customer>((json) => Customer.fromJson(json)).toList();
  }
  static List<Alert> parseAlertResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Alert>((json) => Alert.fromJson(json)).toList();
  }

  static Map<String, dynamic> parser(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Success>((json) => Success.fromJson(json));
  }

  // Method to add employee to the database...
  static Future<String> addEmployee(String firstName, String lastName) async {
    try {
      var map = <String, dynamic>{};
      map['action'] = _ADD_EMP_ACTION;
      map['first_name'] = firstName;
      map['last_name'] = lastName;
      final response = await http.post(ROOT, body: map);
      print('addEmployee Response: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }


  static Future<String> addCustomer(
      String name,
      String phoneNumber,
      int location,
      String street,
      String info,
      String password,
      String email) async {
    print(location);
    int randomNo = Random().nextInt(500000);
    var map = <String, dynamic>{};
    map['action'] = _ADD_CUSTOMER;
    map['customer_name'] = name;
    map['customer_phone'] = phoneNumber;
    map['customer_pass'] = password;
    map['customer_email'] = email;
    map['location_id'] = location.toString();
    map['customer_id'] = randomNo.toString();
    map['street'] = street;
    map['info'] = info;
    print('ieej');
    final response = await http.post(ROOT, body: map);
    print('ijd');
    print('addCustomer Response: ${response.body}');
    if (200 == response.statusCode) {
      print('ijf');
      return response.body;
    } else {
      return "error";
    }
  }

  static Future<List<Customer>> logCustomer(
      String email, String password) async {
    try {
      var map = <String, dynamic>{};
      map['action'] = _LOG_CUSTOMER;
      map['email'] = email;
      map['password'] = password;
      final response = await post(ROOT, body: map);
      print('logCustomer Response: ${response.body}');
      print('hello4');
      List<Customer> data = parseCustomerResponse(response.body);
      print('printed');
      return data;
    } catch (e) {
      return <Customer>[];
    }
  }

  static Future<String> updateSettings(
      String days, String starttime, String endtime, String customerid) async {
    try {
      var map = <String, dynamic>{};
      map['action'] = _UPDATE_SETTINGS;
      map['customerid'] = customerid;
      map['starttime'] = starttime;
      map['endtime'] = endtime;
      map['days'] = days;
      final response = await http.post(ROOT, body: map);
      print('updateSettings Response: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }

  // Method to update an Employee in Database...
  static Future<String> updateEmployee(
      String empId, String firstName, String lastName) async {
    try {
      var map = <String, dynamic>{};
      map['action'] = _UPDATE_EMP_ACTION;
      map['emp_id'] = empId;
      map['first_name'] = firstName;
      map['last_name'] = lastName;
      final response = await http.post(ROOT, body: map);
      print('updateEmployee Response: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }

  // Method to Delete an Employee from Database...
  static Future<String> deleteEmployee(String empId) async {
    try {
      var map = <String, dynamic>{};
      map['action'] = _DELETE_EMP_ACTION;
      map['emp_id'] = empId;
      final response = await http.post(ROOT, body: map);
      print('deleteEmployee Response: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error"; // returning just an "error" string to keep this simple...
    }
  }
}
