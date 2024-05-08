import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share/share.dart';
import '../controllers/homepage_controller.dart';
import '../models/quotes_model.dart';

class QuoteDetail extends StatefulWidget {
  final Quote quote;

  QuoteDetail({super.key, required this.quote});

  @override
  State<QuoteDetail> createState() => _QuoteDetailState();
}

class _QuoteDetailState extends State<QuoteDetail> {
  final controller = Get.put(QuoteDetailController());

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
          
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.chevron_left_outlined,
              size: 30,
            ),
          ),
          backgroundColor: Colors.white.withOpacity(0.7),
          centerTitle: true,
          title: const Hero(
            tag: 'Quotes',
            child: Text(
              "Quote",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,),
            ),
          ),
        ),
        body: ListView(
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black38,
                    blurRadius: 5.0,
                    blurStyle: BlurStyle.solid,
                  ),
                ],
                color: Colors.white.withOpacity(0.6),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(20),
                    child: Image(
                      image: AssetImage('asset/img/quote-logo.png'),
                      height: 50,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Text(
                          widget.quote.quote,
                          style: const TextStyle(
                              fontSize: 17,
                              color: Colors.black,
                              letterSpacing: 1,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 40),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(
                          '@${widget.quote.author}',
                          style: const TextStyle(
                              fontSize: 17,
                              color: Colors.black,
                              letterSpacing: 1,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.orangeAccent.withOpacity(0.4),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () {
                            controller.toggleLike();
                          },
                          icon: Obx(
                            () => Icon(
                              controller.isLiked.value
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              size: 30,
                              color:
                                  controller.isLiked.value ? Colors.red : null,
                            ),
                          ),
                        ),
                        Obx(
                          () => Text(
                            '${controller.likeCount}',
                            style: const TextStyle(fontSize: 17),
                          ),
                        ),
                        const SizedBox(width: 10),
                        IconButton(
                          onPressed: () {
                            FlutterClipboard.copy(widget.quote.quote).then((_) {
                              ScaffoldMessenger.of(context).showSnackBar(
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
                            Share.share(widget.quote.quote);
                          },
                          icon: const Icon(
                            Icons.share,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.all(10),
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.6),
                borderRadius: BorderRadius.circular(15),
              ),
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
    );
  }
}
