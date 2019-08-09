// Flutter code sample for material.AppBar.1

// This sample shows an [AppBar] with two simple actions. The first action
// opens a [SnackBar], while the second action navigates to a new page.

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:audioplayers/audio_cache.dart';
import 'package:dio/dio.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

void main() => runApp(MyApp());

/// This Widget is the main application widget.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        DisplayCard.routeName: (context) => DisplayCard(),
      },
      debugShowCheckedModeBanner: false,
      title: 'GRE words',
      home: Home(),
      color: Colors.white,
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class DisplayCard extends StatefulWidget {
//  final Map title;
//  DisplayCard() {}
  static const routeName = '/displayCard';

  @override
  _DisplayCardState createState() => _DisplayCardState();
}

class _DisplayCardState extends State<DisplayCard> {
  Future<String> loadJson(path) async {
    return await rootBundle.loadString(path);
  }

  Future<void> writeToFile(String data, String path) {
    try {
      return File('test.mp3').writeAsString(data, mode: FileMode.write);
    } catch (e) {
      print('here $e');
    }
  }

  Future<void> download() async {
    Dio dio = Dio();

    String url =
        "https://translate.google.com/translate_tts?ie=UTF-8&q=dhanush%20is%20my%20name&tl=en&client=tw-ob";
    try {
      String dir = (await getApplicationDocumentsDirectory()).path;
      Response res = await dio.get(url);
      await writeToFile(res.data.toString(), '$dir/test.mp3');
      final player = AudioCache();
      player.play('$dir/test.mp3');
    } catch (e) {
      print('HEy $e');
    }
  }

  bool status = false;
  Map<String, dynamic> meanings;
  @override
  void initState() {
    super.initState();
    download();
    this.loadJson('assets/clean_dict.json').then((value) {
      // Run extra code here
      setState(() {
        meanings = jsonDecode(value);
        status = true;
//        print(meanings);
      });
    }, onError: (error) {
      print(error);
    });
  }

  void fetchData(String word) {
    return;
  }

  void speak(String word) {
    fetchData('hey');
  }

  @override
  Widget build(BuildContext context) {
    final ScreenArguments args = ModalRoute.of(context).settings.arguments;
    int count = 0;
    List<Widget> pageBuilder() {
      return args.words.map((word) {
        count++;
        return Container(
          margin: EdgeInsets.all(40),
//          color: Colors.white,
          child: FlipCard(
            direction: FlipDirection.HORIZONTAL, // default
            front: Column(
              children: <Widget>[
                FlatButton(
                  child: Icon(
                    Icons.volume_up,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    speak(word);
                  },
                ),
                Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 70),
                    child: Text(word,
                        style: TextStyle(
                            fontFamily: 'Montserrat Light',
                            fontSize: 40,
                            color: Colors.white)),
                  ),
                ),
                SizedBox(
                  height: 100,
                ),
                Center(
                  child: Text(count.toString(),
                      style: TextStyle(
                          fontFamily: 'Montserrat Light',
                          fontSize: 25,
                          color: Colors.white)),
                )
              ],
            ),
            back: Center(
              child: Container(
                child: Text(
                  meanings[word].join('\n\n'),
                  style: TextStyle(
                      fontFamily: 'Montserrat Light',
                      fontSize: 20,
                      color: Colors.white),
                ),
              ),
            ),
          ),
        );
      }).toList();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Center(
          child: Text(
            args.category,
            style: TextStyle(fontFamily: 'Montserrat Light', fontSize: 20),
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 140, horizontal: 30),
        color: Colors.purple,
        child: PageView(
          children: status
              ? pageBuilder()
              : <Widget>[
                  Image(
                    image: AssetImage('assets/loader.gif'),
                  ),
                ],
        ),
      ),
    );
  }
}

class ScreenArguments {
  final String category;
  final List<dynamic> words;
//  final Map<String, dynamic> meanings;

  ScreenArguments(this.category, this.words);
}

class _HomeState extends State<Home> {
  Future<String> loadJson(path) async {
    return await rootBundle.loadString(path);
  }

  bool status = false;

  Map<String, dynamic> decks;
//  Map<String, dynamic> meanings;
  @override
  void initState() {
    super.initState();

    this.loadJson('assets/words.json').then((value) {
      // Run extra code here
      setState(() {
        decks = jsonDecode(value);
        status = true;
//        print(decks);
      });
    }, onError: (error) {
      print(error);
    });
//    this.loadJson('assets/clean_dict.json').then((value) {
//      // Run extra code here
//      setState(() {
//        meanings = jsonDecode(value);
//        print(meanings);
//      });
//    }, onError: (error) {
//      print(error);
//    });
  }

//  @override
//  void dispose() {
//    _assetsAudioPlayer = null;
//    super.dispose();
//  }

  List<Widget> getDecks() {
    return decks.keys.map((keyname) {
      return Card(
//        shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(50)),
        margin: EdgeInsets.symmetric(vertical: 20, horizontal: 5),
        child: FlatButton(
          padding: EdgeInsets.symmetric(vertical: 70, horizontal: 50),
          child: Text(
            keyname,
            style: TextStyle(fontFamily: 'Pricedown', fontSize: 30),
          ),
          color: Colors.white,
          onPressed: () {
            Navigator.pushNamed(
              context,
              DisplayCard.routeName,
              arguments: ScreenArguments(
                keyname,
                decks[keyname],
//                meanings,
              ),
            );
          },
        ),
      );
    }).toList();
  }

  bool toggle = false;
  List option = ['Deck', 'All'];
  int choice = 0;

  @override
  Widget build(BuildContext context) {
//    if (toggle) {
//      return Scaffold(
//        appBar: AppBar(
//          backgroundColor: Colors.purple,
//          title: Center(
//            child: Text(
//              'Magoosh GRE vocab',
//              style: TextStyle(fontFamily: 'Montserrat Light', fontSize: 20),
//            ),
//          ),
//        ),
//        body: Container(
//            color: Colors.purple,
//            child: ListView(
//              shrinkWrap: true,
//              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
//              children: status
//                  ? [
//                      Card(
//                        color: Colors.purple,
//                        child: SwitchListTile(
//                          title: Center(child: Text(option[choice])),
//                          value: toggle,
//                          onChanged: (bool value) {
//                            setState(() {
//                              toggle = value;
//                              choice = (choice + 1) % 2;
//                            });
//                          },
////                          secondary: const Icon(Icons.lightbulb_outline),
//                        ),
//                      )
//                    ]
//                  : <Widget>[
//                      Image(
//                        image: AssetImage('assets/loader.gif'),
//                      ),
//                    ],
//            )),
//      );
//    }
//
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Center(
          child: Text(
            'Magoosh GRE vocab',
            style: TextStyle(fontFamily: 'Montserrat Light', fontSize: 20),
          ),
        ),
      ),
      body: Container(
          color: Colors.purple,
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
            children: status
                ? getDecks()
                : <Widget>[
                    Image(
                      image: AssetImage('assets/loader.gif'),
                    ),
                  ],
          )),
    );
  }
}
//this preceedes getDecks() call to be concat with the list
/*
* [
                      Card(
                        color: Colors.purple,
                        child: SwitchListTile(
                          title: Center(child: Text(option[choice])),
                          value: toggle,
                          onChanged: (bool value) {
                            setState(() {
                              toggle = value;
                              choice = (choice + 1) % 2;
                            });
                          },
//                          secondary: const Icon(Icons.lightbulb_outline),
                        ),
                      )
                    ] +
* */
