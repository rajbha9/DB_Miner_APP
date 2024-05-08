import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../helper/api_helper.dart';
import '../helper/database_helper.dart';
import '../models/quotes_model.dart';
class QuoteController extends GetxController {
  var quotes = <Quote>[].obs;

  @override
  void onInit() {
    fetchData();
    super.onInit();
  }

  void addToFavorites(Quote quote) {
    quote.isFavorite.toggle();

    if (quote.isFavorite.value) {
      DatabaseHelper.instance.insertQuote(quote);
    } else {
      DatabaseHelper.instance.deleteQuote(quote.id);
    }
  }

  void fetchData() async {
    var fetchedQuotes = await APIHelper.apiHelper.fetchedQuote();
    if (fetchedQuotes != null) {
      var quotesFromDB = await DatabaseHelper.instance.getQuotes();
      for (var quote in fetchedQuotes) {
        var isFavorite = quotesFromDB.any((dbQuote) => dbQuote.id == quote.id);
        quote.isFavorite = isFavorite.obs;
      }
      quotes.assignAll(fetchedQuotes);
    }
  }
}

class QuoteDetailController extends GetxController {
  var isLiked = false.obs;
  var likeCount = 0.obs;

  void toggleLike() {
    isLiked.value = !isLiked.value;
    if (isLiked.value) {
      likeCount.value++;
    } else {
      likeCount.value--;
    }
  }
}
