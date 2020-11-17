class Areas {
  List<Area> _areas;

  Areas.initializeAreas() {
    _areas = List<Area>();
    _areas.add(Area(
        'København', 'https://www.dr.dk/mu/feed/p4-trafik-koebenhavn-kh4.xml'));
    _areas.add(Area(
        'Sjælland', 'https://www.dr.dk/mu/feed/p4-trafik-sjaelland-nv4.xml'));
    _areas.add(
        Area('Esbjerg', 'https://www.dr.dk/mu/feed/p4-trafik-esbjerg-es4.xml'));
    _areas.add(Area('Nordjylland',
        'https://www.dr.dk/mu/feed/p4-trafik-nordjylland-al4.xml'));

    _areas.add(Area('Midt og Vest',
        'https://www.dr.dk/mu/feed/p4-trafik-midt-og-vest-ho4.xml'));
    _areas.add(Area(
        'Trekanten', 'https://www.dr.dk/mu/feed/p4-trafik-trekanten-tr4.xml'));
    _areas.add(Area('Østjylland',
        'https://www.dr.dk/mu/feed/p4-trafik-oestjylland-ar4.xml'));
    _areas.add(Area('Syd', 'https://www.dr.dk/mu/feed/p4-trafik-syd-ab4.xml'));
    _areas.add(Area('Fyn', 'https://www.dr.dk/mu/feed/p4-trafik-fyn-od4.xml'));
  }

  List<Area> get getAreas => _areas;
}

class Area {
  String _title;
  String _areaURL;

  //Constructor
  Area(this._title, this._areaURL);

  //getters
  String get getTitle => _title;
  String get getAreaURL => _areaURL;
}
