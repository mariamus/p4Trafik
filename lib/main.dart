import 'package:flutter/material.dart';
import 'util/Areas.dart';
import 'DetailedArea.dart';
import 'util/AboutMe.dart';

void main() {
  runApp(MaterialApp(
    title: 'P4 Trafik Områder',
    home: HomeScreen(),
  ));
}

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> {
  List<Area> _areas;

  HomeScreenState() {
    _areas = Areas.initializeAreas().getAreas;
  }

  _handleDetailedViewdata(int index) async {
    await Navigator.push(context,
        MaterialPageRoute(builder: (context) => DetailedArea(_areas[index])));
  }

  _hellopage() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => AboutMe()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      appBar: AppBar(
        title: Text(
          'P4 Trafik Områder',
          style: TextStyle(
            fontFamily: 'Montserrat',
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.emoji_people),
            color: Colors.white,
            onPressed: () {
              setState(() {
                _hellopage();
              });
            },
          )
        ],
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      ),
      body: Container(
        margin: new EdgeInsets.only(top: 5),
        child: ListView.separated(
          itemCount: _areas.length,
          itemBuilder: (context, index) {
            return Container(
              margin: new EdgeInsets.only(left: 10.0, right: 10.0),
              decoration: BoxDecoration(
                color: Color.fromRGBO(64, 75, 96, .9),
                shape: BoxShape.rectangle,
                borderRadius: new BorderRadius.circular(8.0),
                boxShadow: <BoxShadow>[
                  new BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10.0,
                      offset: new Offset(0.0, 10.0))
                ],
              ),
              child: ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      _areas[index].getTitle,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.white,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  _handleDetailedViewdata(index);
                },
              ),
            );
          },
          separatorBuilder: (context, i) => Divider(
            height: 7.0,
            indent: 46,
          ),
        ),
      ),
    );
  }
}
