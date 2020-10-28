import 'dart:io';
import 'package:flutter/material.dart';
import 'util/Areas.dart';
import 'package:webfeed/domain/rss_feed.dart';
import 'package:audioplayers/audioplayers.dart';
import 'Util/NewsModel.dart';
import 'package:./http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'Util/styles.dart';

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
  AudioPlayer audioPlayer = new AudioPlayer();
  Duration duration = new Duration();
  Duration position = new Duration();

  generateColors() {
    _colors = List.generate(
        listsizes, (int index) => Colors.blue[900]); // here 10 is items.length
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

  //tjekker status på appens lifecycleState, for at sikre at lyd stoppes når appen ikke er i forgrunden.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.resumed:
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
        audioPlayer.stop();
        playing = false;
        break;
    }
  }

  Area selectedArea;
  DetailedAreaState(this.selectedArea);

  String urlcopy;
  String titletext;
  String durationCopy;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        backgroundColor: Colors.blueGrey,
        appBar: AppBar(
          backgroundColor: Colors.blue[900],
          title: Text(
            selectedArea.getTitle + ' Trafikmeldinger',
            style: Style.headerTextStyle,
          ),
          leading: MaterialButton(
            onPressed: () {
              Navigator.pop(context);
              audioPlayer.stop();
              playing = false;
            },
            child: Icon(Icons.arrow_back, color: Colors.white),
          ),
        ),
        body: Container(
          margin: new EdgeInsets.only(left: 10.0, right: 10.0),
          decoration: BoxDecoration(
            color: Colors.lightBlue[50],
            shape: BoxShape.rectangle,
            borderRadius: new BorderRadius.circular(15.0),
          ),
          child: FutureBuilder(
            future: fetchNews(),
            builder: (context, snap) {
              if (snap.hasData) {
                final List _news = snap.data;
                return ListView.separated(
                  itemBuilder: (context, i) {
                    //populerer List med items.
                    final NewsModel _item = _news[i];
                    //Returnerer list Tile med dato, duration og iconbutton der åbner BottomModalSheet
                    return ListTile(
                      title: Text(
                          '${_item.pubDate.toString().replaceFirst("g ", "g\n").replaceFirst(new RegExp("UV(?:11?|[3-8]) "), "")}',
                          style: Style.baseTextStyle),
                      subtitle: Text(
                          '${_item.duration.toString().substring(1 + 2).split('.').first.padLeft(5, "0")}' +
                              " minutter",
                          style: Style.baseTextStyle),
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
                            durationCopy =
                                '${_item.duration.toString().substring(1 + 2).split('.').first.padLeft(5, "0")}';
                            setState(() {
                              getAudio();
                            });
                          }),
                    );
                  },
                  separatorBuilder: (context, i) => Divider(
                    color: Colors.blueGrey,
                    height: 1.0,
                    thickness: 5.0,
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
    playing = false;
    Navigator.pop(context);
    return null;
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

  //Slider widget
  Widget slider() {
    return Slider.adaptive(
        activeColor: Colors.blue[900],
        inactiveColor: Colors.indigo[900],
        min: 0.0,
        value: position.inSeconds.toDouble(),
        max: duration.inSeconds.floorToDouble(),
        onChanged: (double value) {
          setState(() {
            audioPlayer.seek(Duration(seconds: value.toInt()));
          });
        });
  }

  void getAudio() async {
    audioPlayer.onDurationChanged.listen((Duration dur) {
      setState(() => duration = dur);
    });
    audioPlayer.onAudioPositionChanged.listen((Duration pos) {
      setState(() => position = pos);
    });

    audioPlayer.onPlayerCompletion.listen((event) {
      setState(() {
        playing = false;
      });
    });

    if (playing) {
      //pause
      var res = await audioPlayer.pause();
      if (res == 1) {
        setState(() {
          playing = false;
        });
      }
    } else {
      //play song
      var res = await audioPlayer.play(urlcopy, isLocal: true);
      if (res == 1) {
        setState(() {
          playing = true;
        });
      }
    }
  }

  //popup modal der viser at afspilning er i gang.
  void _playerModalBottomSheet(context) {
    Color _color = Colors.blue[900];
    showModalBottomSheet(
        isDismissible: false,
        enableDrag: false,
        isScrollControlled: false,
        backgroundColor: Colors.blue[100],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Container(
                height: MediaQuery.of(context).size.height,
                child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            titletext,
                          ),
                          Spacer(),
                          IconButton(
                              icon: Icon(Icons.cancel),
                              color: _color,
                              iconSize: 40,
                              onPressed: () {
                                audioPlayer.stop();
                                setState(() {
                                  playing = false;
                                  duration = Duration(seconds: 0);
                                  position = Duration(seconds: 0);
                                });
                                Navigator.of(context).pop();
                              }),
                        ],
                      ),
                      Column(children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              getAudio();
                            });
                          },
                          child: StreamBuilder<Object>(
                              stream: audioPlayer.onPlayerStateChanged,
                              builder: (context, snapshot) {
                                return Icon(
                                  playing == true
                                      ? Icons.pause_circle_outline
                                      : Icons.play_circle_outline,
                                  size: MediaQuery.of(context).size.width * .50,
                                  color: _color,
                                );
                              }),
                        ),
                      ]),
                      Column(
                        children: [
                          Container(
                            child: StreamBuilder<Duration>(
                                stream: audioPlayer.onAudioPositionChanged,
                                builder: (context,
                                    AsyncSnapshot<Duration> snapshot) {
                                  return slider();
                                }),
                          ),
                          Column(
                            children: [
                              Container(
                                child: StreamBuilder<Duration>(
                                    stream: audioPlayer.onAudioPositionChanged,
                                    builder: (context,
                                        AsyncSnapshot<Duration> snapshot) {
                                      return Text(
                                        position.inSeconds
                                                .toDouble()
                                                .toString() +
                                            " / " +
                                            duration.inSeconds
                                                .toDouble()
                                                .toString() +
                                            " Sekunder.",
                                        style: Style.smallTextStyle,
                                      );
                                    }),
                              ),
                            ],
                          )
                        ],
                      ),
                    ])));
          });
        });
  }
}
