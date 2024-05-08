import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share/share.dart';

import '../controllers/homepage_controller.dart';
import '../helper/database_helper.dart';
import '../models/quotes_model.dart';
import 'dateil.dart';
import 'fev_screen.dart';

class Homepage extends StatelessWidget {
  final QuoteController quoteController = Get.put(QuoteController());
  final dbHelper = DatabaseHelper.instance;

  Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fill,
          image: AssetImage('asset/img/bg.jpg'),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text(
            "Quotes",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white),
          ),
          actions: [
            PopupMenuButton(
              itemBuilder: (context) {
                return <PopupMenuEntry>[
                  PopupMenuItem(
                    child: const Text("Favorite"),
                    onTap: () {
                      Get.to(const FavoritesScreen());
                    },
                  ),
                ];
              },
            ),
          ],
        ),
        body: Obx(
          () {
            if (quoteController.quotes.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return ListView.builder(
                itemCount: quoteController.quotes.length,
                itemBuilder: (context, index) {
                  Quote quote = quoteController.quotes[index];
                  return InkWell(
                    onTap: () {
                      Get.to(
                        QuoteDetail(quote: quote),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.only(top: 10),
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.6),
                        border: BorderDirectional(
                            top: BorderSide(color: Colors.amber, width: 5)),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black38,
                            blurRadius: 7.0,
                            blurStyle: BlurStyle.solid,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: 160,
                            width: double.infinity,
                            padding: const EdgeInsets.only(
                                top: 20, left: 20, right: 20, bottom: 8),
                            margin: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: (quote.id % 2 == 0)
                                  ? Colors.greenAccent.withOpacity(0.4)
                                  : Colors.blueAccent.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  quote.quote,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                const Expanded(
                                  child: SizedBox(
                                    height: 20,
                                  ),
                                ),
                                Text(
                                  '@${quote.author}',
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 50,
                            decoration: BoxDecoration(
                              border: BorderDirectional(
                                  bottom:
                                      BorderSide(width: 5, color: Colors.pink)),
                              color: Colors.white.withOpacity(0.01),
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(15),
                                bottomRight: Radius.circular(15),
                              ),
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    quoteController.addToFavorites(quote);
                                  },
                                  icon: Obx(
                                    () {
                                      return Icon(
                                        quote.isFavorite.value
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        size: 30,
                                      );
                                    },
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    FlutterClipboard.copy(quote.quote)
                                        .then((_) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text('Quote copied'),
                                        ),
                                      );
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.copy,
                                    size: 30,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    Share.share(quote.quote);
                                  },
                                  icon: const Icon(
                                    Icons.share_outlined,
                                    size: 30,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
