import 'package:flutter/material.dart';
import 'util/Areas.dart';
import 'DetailedArea.dart';
import 'util/AboutMe.dart';
import 'Util/styles.dart';

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
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        title: Text('P4 Trafik Områder'),
        backgroundColor: Colors.blue[900],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _hellopage();
          });
        },
        child: Icon(Icons.face),
        backgroundColor: Colors.blue[900],
      ),
      body: ListView.separated(
        itemCount: _areas.length,
        itemBuilder: (context, index) {
          return Container(
            margin: new EdgeInsets.only(left: 10.0, right: 10.0),
            decoration: BoxDecoration(
              color: Colors.lightBlue[50],
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
                    style: Style.headerTextStyle,
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
    );
  }
}
