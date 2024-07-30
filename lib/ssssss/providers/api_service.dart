import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:http/http.dart' as http;

import 'package:proj/ssssss/providers/shopping_model.dart';

class ApiService{
Future<List<ProductsModel>?> getProducts() async{
  final url=Uri.parse("https://dummyjson.com/products");

 final response= await http.get(url);
 if(response.statusCode==200 || response.statusCode==201){
  final List result= jsonDecode(response.body)["products"];
  return result.map(((e)=>ProductsModel.fromJson(e))).toList();
 }
 else{
  debugPrint("error occured in getting api response[ApiService]");
  return null;
 }
 

}

}
final apiProvider= Provider<ApiService>((ref){     // providers ApiService class
  return ApiService();
});

final productsProvider=FutureProvider<List<ProductsModel>?>((ref){ // gets data using apiprovider
 return ref.read(apiProvider).getProducts();      // gets getProducts method of ApiService class using apiProvider 
});