import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share/share.dart';

import '../controllers/homepage_controller.dart';
import '../helper/database_helper.dart';
import '../models/quotes_model.dart';
import 'dateil.dart';

class Homepage extends StatelessWidget {
  final controller = Get.put(QuoteDetailController());
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
          backgroundColor: Colors.white.withOpacity(0.7),
          title: const Text(
            "Quotes",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          ),
        ),
        drawer: Drawer(
          backgroundColor: Colors.white.withOpacity(0.8),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: [
                const SizedBox(
                  height: 20,
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Align(
                    alignment: AlignmentDirectional.topStart,
                    child: CircleAvatar(
                      radius: 35,
                      backgroundImage: NetworkImage(
                        'https://static.vecteezy.com/system/resources/previews/019/896/008/original/male-user-avatar-icon-in-flat-design-style-person-signs-illustration-png.png',
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () {
                    Get.toNamed('/favorite');
                  },
                  child: Container(
                    height: 50,
                    color: Colors.black.withOpacity(0.7),
                    child: const Row(
                      children: [
                        SizedBox(
                          width: 20,
                        ),
                        Icon(
                          Icons.favorite,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          'Favorite',
                          style: TextStyle(
                              fontSize: 20,
                              letterSpacing: 1,
                              color: Colors.white),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 40,
                        width: 40,
                        child: Image(
                          image: AssetImage('asset/img/facebook.png'),
                          height: 30,
                        ),
                      ),
                      SizedBox(width: 20),
                      SizedBox(
                        height: 40,
                        width: 40,
                        child: Image(
                          image: AssetImage('asset/img/instagram.png'),
                          height: 30,
                        ),
                      ),
                      SizedBox(width: 20),
                      SizedBox(
                        height: 40,
                        width: 40,
                        child: Image(
                          image: AssetImage('asset/img/whatsapp.png'),
                          height: 30,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
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
                    child: Padding(
                      padding: const EdgeInsets.only(
                          bottom: 8, top: 8, left: 10, right: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.6),
                          border: const BorderDirectional(
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
                                          color: quote.isFavorite.value
                                              ? Colors.red
                                              : null,
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
