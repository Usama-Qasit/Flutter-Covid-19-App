import 'dart:convert';

import 'package:covid_tracker_app/Models/World_states_model.dart';
import 'package:covid_tracker_app/Services/utilities/app-url.dart';
import 'package:http/http.dart' as http;

class StatesServices{

  Future<WorldStatesModel> fetchWorldStatesRecords()async{

    final response = await http.get(Uri.parse(AppUrl.worldSatesApi));

    if(response.statusCode == 200){
      var data = jsonDecode(response.body);
      return WorldStatesModel.fromJson(data);
    }else{
      throw Exception('Error');
    }

  }

  Future<List<dynamic>> countriesListApi()async{

    var data;
    var response = await http.get(Uri.parse(AppUrl.countriesList));
    if(response.statusCode == 200){
       data= jsonDecode(response.body);
      return data;
    }else{
      throw Exception('Error');

    }
  }
}

