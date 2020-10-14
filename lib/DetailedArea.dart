import 'dart:io';
import 'package:flutter/material.dart';
import 'util/Areas.dart';
import 'package:webfeed/domain/rss_feed.dart';
import 'package:audioplayers/audioplayers.dart';
import 'Util/NewsModel.dart';
import 'package:./http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class DetailedArea extends StatefulWidget {
  final Area selectedArea;
  DetailedArea(this.selectedArea);

  State<StatefulWidget> createState() {
    return DetailedAreaState(selectedArea);
  }
}

class DetailedAreaState extends State<DetailedArea>
    with WidgetsBindingObserver {
  List<Color> _colors = [];
  int listsizes = 10;
  bool playing = false;

  generateColors() {
    _colors = List.generate(
        listsizes, (int index) => Colors.blue[700]); // here 10 is items.length
  }

  @override
  void initState() {
    super.initState();
    //opretter WidgetsBinding instance observer.
    generateColors();
    WidgetsBinding.instance.addObserver(this);
  }

//fjerner observer.
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  //tjekker status på appens lifecycleState, for at sikre at musik lukkes når appen ikke er i forgrunden.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.paused:
        audioPlayer.stop();

        break;

      case AppLifecycleState.resumed:
        audioPlayer.stop();

        break;
      case AppLifecycleState.inactive:
        audioPlayer.stop();

        break;
      case AppLifecycleState.detached:
        audioPlayer.stop();

        break;
    }
  }

  Area selectedArea;
  DetailedAreaState(this.selectedArea);
  AudioPlayer audioPlayer = new AudioPlayer();
  Duration duration = new Duration();
  Duration position = new Duration();

  String urlcopy;
  String titletext;
  String durationCopy;

  //bool playing = false;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          title: Text(selectedArea.getTitle + ' Trafikmeldinger'),
          leading: MaterialButton(
            onPressed: () {
              Navigator.pop(context);
              audioPlayer.stop();
            },
            child: Icon(Icons.arrow_back, color: Colors.white),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
              color: Colors.lightBlue[50],
              border: Border(
                  bottom: BorderSide(color: Colors.blueAccent, width: 3.0))),
          child: FutureBuilder(
            future: fetchNews(),
            builder: (context, snap) {
              if (snap.hasData) {
                final List _news = snap.data;
                return ListView.separated(
                  itemBuilder: (context, i) {
                    //populerer List med items.
                    final NewsModel _item = _news[i];
                    //Returnerer list Tile med dato, duration og knap til afspilning af URL og stop knap.
                    return ListTile(
                      title: Text(
                          '${_item.pubDate.toString().replaceFirst("g ", "g\n").replaceFirst(new RegExp("UV(?:11?|[3-8]) "), "")}'),
                      //.replaceFirst(RegExp(source), to)
                      subtitle: Text(
                          '${_item.duration.toString().substring(1 + 2).split('.').first.padLeft(5, "0")}' +
                              " minutter"),
                      // slider(); Insert this in modal popup
                      leading: new IconButton(
                          iconSize: 50,
                          alignment: Alignment.centerLeft,
                          icon: Icon(
                            Icons.play_circle_outline,
                            color: _colors[i],
                          ),
                          onPressed: () {
                            _playerModalBottomSheet(context);
                            urlcopy = '${_item.enclosure}';
                            titletext =
                                '${_item.pubDate.toString().replaceFirst("g ", "g\n").replaceFirst(new RegExp("UV(?:11?|[3-8]) "), "")}';
                          }),
                    );
                  },
                  separatorBuilder: (context, i) => Divider(
                    color: Colors.blueGrey[300],
                    height: 1.0,
                    thickness: 2.0,
                  ),
                  itemCount: listsizes,
                );
              } else if (snap.hasError) {
                return Center(
                  child: Text(snap.error.toString()),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  //Future Function der sletter appen's fil cache for at sikre at List altid er populeret med nyeste entries.
  Future<void> _deleteCacheDir() async {
    final cacheDir = await getTemporaryDirectory();

    if (cacheDir.existsSync()) {
      cacheDir.deleteSync(recursive: true);
    }
  }

  // Future der sørger for at tilbageknappen stopper for afspilning af lyd, og derefter popper tilbage til main..
  Future<bool> _onBackPressed() {
    audioPlayer.stop();
    Navigator.pop(context);
    return null;
  }

  void _playerModalBottomSheet() {
    showModalBottomSheet() async {
      return Container(
        audioPlayer.play(url),
        child: Text("Test"),
      )        
        };
  }

  /*Future function der først kører en clear cache function og derefter asynkront 
   tjekker på om xml URL'en giver statuskode 200 i respons. Derefter scraper den XML
   filen for tags og tilføjer til en List. */

  Future fetchNews() async {
    _deleteCacheDir();
    final _response = await http.get(selectedArea.getAreaURL);

    if (_response.statusCode == 200) {
      var _decoded = new RssFeed.parse(_response.body);
      return _decoded.items
          .map((item) => NewsModel(
                pubDate: item.title,
                enclosure: item.enclosure.url,
                duration: item.itunes.duration,
              ))
          .toList();
    } else {
      throw HttpException('Failed to fetch the data');
    }
  }

  //popup modal der viser at afspilning er i gang.
  void _playerModalBottomSheet(context) {
    Color _color = Colors.blue[700];
    showModalBottomSheet(
        backgroundColor: Colors.blue[100],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        isDismissible: false,
        enableDrag: false,
        isScrollControlled: false,
        context: context,
        builder: (BuildContext bc) {
          playing = true;
          print("playing true2");
          audioPlayer.play(urlcopy, isLocal: true);
          return Container(
              alignment: Alignment.center,
              height: MediaQuery.of(context).size.height,
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(children: <Widget>[
                    Row(
                      children: [
                        Text(titletext),
                        Spacer(),
                        IconButton(
                            icon: Icon(Icons.cancel),
                            color: _color,
                            iconSize: 40,
                            onPressed: () {
                              audioPlayer.stop();
                              playing = false;
                              Navigator.of(context).pop();
                            }),
                      ],
                    ),
                    Column(children: [
                      InkWell(
                        onTap: () {
                          if (playing == true) {
                            playing = false;
                            print(playing);
                            audioPlayer.pause();
                          } else {
                            playing = true;
                            print(playing);
                            audioPlayer.play(urlcopy, isLocal: true);
                          }
                        },
                        child: Icon(
                          playing == false
                              ? Icons.pause_circle_outline
                              : Icons.play_circle_outline,
                          size: MediaQuery.of(context).size.width * .50,
                          color: _color,
                        ),
                      ),
                    ]),
                    Column(
                        //children: [
                        //slider(),
                        //],
                        ),
                  ])));
        });
  }

  //Slider widget
  Widget slider() {
    return Slider.adaptive(
        min: 0.0,
        max: duration.inSeconds.toDouble(),
        value: duration.inSeconds.toDouble(),
        onChanged: (double value) {
          audioPlayer.onAudioPositionChanged.listen((Duration p) => {
                Text('Current position: $p'),
                setState(() => position = p),
              });
        });
  }
}
