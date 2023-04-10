import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quotes/api_models.dart/quotes.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
//Initialized list

  List<Quote> quoteList = [];
  final _random = Random();

  static const _baseUrl = 'https://zenquotes.io/api/quotes';

  Future<List<Quote>> fetchQuote() async {
    final response = await http.get(Uri.parse(_baseUrl));
    var data = jsonDecode(response.body.toString());

    if (response.statusCode == 200) {
      for (Map<String, dynamic> i in data) {
        quoteList.add(Quote.fromJson(i));
      }
      return quoteList;
    } else {
      return quoteList;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        SizedBox(
          height: 45,
        ),
        Center(child: Text("Quotes", style: TextStyle(fontSize: 40, fontWeight: FontWeight.w400, fontStyle: FontStyle.italic), )),
        Expanded(
          child: FutureBuilder(
              future: fetchQuote(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Text("Loading");
                } else {
                  return ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: quoteList.length,
                      itemBuilder: (context, index) {
                        return Container(
                          height: 300,
                          child: Card(
                              elevation: 50,
                              shadowColor: Colors.purpleAccent.shade400,
                              color: Colors.primaries[
                                      _random.nextInt(Colors.primaries.length)]
                                  [_random.nextInt(9) * 100],
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Text(
                                        "'' " +
                                            quoteList[index].q.toString() +
                                            " ''" +
                                            "\n",
                                        style: TextStyle(
                                            fontSize: 35,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 0.0, left: 12),
                                      child: Text(
                                        "- " +
                                            quoteList[index].a.toString() +
                                            "\n",
                                        style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.w500,
                                            fontStyle: FontStyle.italic),
                                      ),
                                    )
                                  ],
                                ),
                              )),
                        );
                      });
                }
              }),
        )
      ]),
    );
  }
}
