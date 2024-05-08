import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share/share.dart';

import '../helper/database_helper.dart';
import '../models/quotes_model.dart';
import 'dateil.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({
    super.key,
  });

  @override
  FavoritesScreenState createState() => FavoritesScreenState();
}

class FavoritesScreenState extends State<FavoritesScreen> {
  final dbHelper = DatabaseHelper.instance;
  late List<Quote> favoriteQuotes;

  @override
  void initState() {
    favoriteQuotes = [];
    super.initState();
    _getFavoriteQuotes();
  }

  Future<void> _getFavoriteQuotes() async {
    final quotes = await dbHelper.getQuotes();
    setState(() {
      favoriteQuotes = quotes.map((quote) {
        return Quote(
          id: quote.id,
          quote: quote.quote,
          author: quote.author,
          isFavorite: false.obs,
        );
      }).toList();
    });
  }

  Future<void> _deleteQuote(int id) async {
    await dbHelper.deleteQuote(id);
    setState(() {
      favoriteQuotes.firstWhere((quote) => quote.id == id).isFavorite;
      favoriteQuotes.removeWhere((quote) => quote.id == id);
    });
  }

  Future<void> _showDeleteConfirmationDialog(int id) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this quote?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.black),
              ),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red.shade300),
              ),
              onPressed: () {
                _deleteQuote(id);

                Navigator.of(context).pop();
              },
              child: const Text(
                'Delete',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fill,
          image: AssetImage('asset/img/bg.jpg'),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.white.withOpacity(0.7),
          title: const Text("Favorite Quotes"),
        ),
        body: favoriteQuotes.isEmpty
            ? const Center(
                child: Text("No favorite quotes yet."),
              )
            : ListView.builder(
                itemCount: favoriteQuotes.length,
                itemBuilder: (context, index) {
                  final quote = favoriteQuotes[index];
                  return Padding(
                    padding: const EdgeInsets.only(
                        bottom: 8, top: 8, left: 10, right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            Get.to(QuoteDetail(quote: quote));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.6),
                              border: BorderDirectional(
                                top: BorderSide(color: Colors.amber, width: 9),
                              ),
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
                                  margin: const EdgeInsets.only(
                                      left: 5, right: 5, bottom: 5),
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
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        '@${quote.author}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 50,
                                  decoration: BoxDecoration(
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
                                          size: 20,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          Share.share(quote.quote);
                                        },
                                        icon: const Icon(
                                          Icons.share,
                                          size: 20,
                                        ),
                                      ),
                                      const Spacer(),
                                      IconButton(
                                        onPressed: () {
                                          _showDeleteConfirmationDialog(quote.id);
                                        },
                                        icon: const Icon(Icons.delete),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
