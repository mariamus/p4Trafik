import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(MaterialApp(
      home: AboutMe(),
    ));

class AboutMe extends StatefulWidget {
  @override
  _AboutMeState createState() => _AboutMeState();
}

class _AboutMeState extends State<AboutMe> {
  _launchURL() async {
    const url = 'https://paypal.me/pools/c/8t0L0qtGqL';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Om denne app'),
        centerTitle: true,
        elevation: 0.0,
        leading: MaterialButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _launchURL,
        child: Icon(Icons.favorite_border, color: Colors.red),
      ),
      body: Container(
        padding: EdgeInsets.all(30),
        child: Text(
            'Hej! \nJeg hedder Elisabeth, og jeg pendler dagligt på E45. Jeg er flere gange rendt ind i at jeg lige har misset en Trafikmelding på P4 og er endt i trælse køer på motorvejen.\n\nSå jeg har lavet denne lille app for at kunne tjekke seneste trafikmeldinger inden jeg kører.\n\nJeg håber du får glæde af min lille app, som er gratis og fri for reklamer. \n\nMen hvis du er blevet reddet fra en trafikprop, og føler dig gavmild, er du velkommen til at give en kop kaffe ved at klikke på hjertet i nederste hjørne. \n\nIngen tvang! :)\n\nP.S. Jeg undskylder hvis der opstår fejl. Jeg er stadig ny i app-udvikling.',
            style: TextStyle(
              fontSize: 14,
            )),
      ),
    );
  }
}
