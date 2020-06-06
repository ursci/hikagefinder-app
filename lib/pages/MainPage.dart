import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hikageapp/pages/InfoPage.dart';
import 'package:hikageapp/pages/MapStartPage.dart';
import 'package:latlong/latlong.dart';

class MainPage extends StatefulWidget {
  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  MapController _mapController = MapController();
  List<Marker> _markers = List<Marker>();
  List<Polyline> _polyLines = List<Polyline>();

  LatLng _initialPoint = LatLng(35.6592979, 139.7005656);

  @override
  void initState() {
    super.initState();
    _markers.add(
      Marker(
        point: _initialPoint,
        height: 49.0,
        width: 49.0,
        anchorPos: AnchorPos.exactly(Anchor(10.0, 10.0)),
        builder: (ctx) => Container(
          child: FlatButton(
            onPressed: () => {},
            child: Icon(
              Icons.my_location,
              size: 45.0,
              color: Colors.blue[900],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        title: Text("Hikage Route Finder"),
        backgroundColor: Colors.blue[900],
      ),*/
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 7,
              child: Stack(
                children: <Widget>[
                  FlutterMap(
                    options: MapOptions(
                        center: _initialPoint,
                        maxZoom: 18.0,
                        minZoom: 15.0,
                        zoom: 15.0,
                        /*
                        nePanBoundary:
                            LatLng(35.6592979 + 0.005, 139.7005656 + 0.005),
                        swPanBoundary:
                            LatLng(35.6592979 - 0.005, 139.7005656 - 0.005),
                         */
                        onPositionChanged: (pos, t) {}),
                    mapController: _mapController,
                    layers: [
                      TileLayerOptions(
                        urlTemplate:
                            'https://cyberjapandata.gsi.go.jp/xyz/pale/{z}/{x}/{y}.png',
                        //'http://{s}.www.toolserver.org/tiles/bw-mapnik/{z}/{x}/{y}.png',
                        //'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                        //subdomains: ['a', 'b', 'c'],
                      ),
                      PolylineLayerOptions(
                        polylines: _polyLines,
                      ),
                      MarkerLayerOptions(
                        markers: _markers,
                      )
                    ],
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(20, 30, 20.0, 30.0),
                      child: FloatingActionButton(
                        heroTag: null,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.info,
                          color: Colors.blue[900],
                          size: 38.0,
                        ),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => InfoPage()),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 20.0, 30.0),
                      child: FloatingActionButton(
                          heroTag: null,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.my_location,
                            color: Colors.blue[900],
                            size: 38.0,
                          ),
                          onPressed: () {
                            _mapController.move(
                                _initialPoint, _mapController.zoom);
                          }),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.only(left: 24.0, right: 24.0),
                child: Center(
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    color: Colors.blue[900],
                    child: Text(
                      "Start",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MapStartPage())),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
