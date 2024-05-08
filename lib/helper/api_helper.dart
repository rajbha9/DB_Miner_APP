import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../models/quotes_model.dart';

class APIHelper {
  APIHelper._();

  static final APIHelper apiHelper = APIHelper._();

  Future<List<Quote>?> fetchedQuote() async {
    String api = "https://dummyjson.com/quotes";

    http.Response response = await http.get(Uri.parse(api));

    if (response.statusCode == 200) {
      String data = response.body;

      Map decodedData = jsonDecode(data);

      List quotes = decodedData['quotes'];

      return quotes
          .map(
            (e) => Quote(
          id: e['id'],
          quote: e['quote'],
          author: e['author'],
          isFavorite: false.obs,
        ),
      )
          .toList();
    }
    return null;
  }
}
