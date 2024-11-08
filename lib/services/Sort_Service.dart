import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:magixcart/constant/Url.dart';
import 'package:magixcart/model/AllProducts.dart'; 

class SortService {
  
  final String baseUrl = Url().baseUrl;
  Future<List<Product>> fetchSortedProducts(String sortOrder) async {
    
    final response = await http.get(
      Uri.parse('https://fakestoreapi.com/products?sort=$sortOrder'),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((product) => Product.fromJson(product)).toList();
    } else {
      throw Exception('Failed to load sorted products');
    }
  }
}
