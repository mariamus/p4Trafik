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
    bool data = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => DetailedArea(_areas[index])));
  }

  _hellopage() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => AboutMe()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('P4 Trafik Områder'),
        backgroundColor: Colors.blue,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _hellopage();
          });
        },
        child: Icon(Icons.face),
        backgroundColor: Colors.blue[700],
      ),
      body: ListView.separated(
        itemCount: _areas.length,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.lightBlue[50],
            ),
            child: ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    _areas[index].getTitle,
                    textScaleFactor: 1.5,
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
          color: Colors.blueGrey[300],
          height: 1.0,
          thickness: 2.0,
        ),
      ),
    );
  }
}
