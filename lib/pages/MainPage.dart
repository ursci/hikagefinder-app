import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hikageapp/pages/InfoPage.dart';
import 'package:hikageapp/pages/MapStartPage.dart';
import 'package:hikageapp/res/ColorParams.dart';
import 'package:hikageapp/res/StringsParams.dart';
import 'package:hikageapp/utils/LocationUtils.dart';
import 'package:hikageapp/utils/MapTileUtils.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';

class MainPage extends StatefulWidget {
  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  MapController _mapController = MapController();
  List<Marker> _markers = [];
  List<Polyline> _polyLines = [];

  LatLng _initialPoint = LatLng(35.6592979, 139.7005656);
  LocationUtils _locationUtils = LocationUtils();

  @override
  void initState() {
    super.initState();
    centerMarker();
  }

  getPresentPos() async {
    LocationData ld = await _locationUtils.getPresentPos();
    _initialPoint = LatLng(ld.latitude, ld.longitude);
    centerMarker();
  }

  centerMarker() {
    _markers.clear();

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
              size: 35.0,
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
                      MapTileUtils.getDefaultTileMap(),
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
                        ).then((value) => setState(() {})),
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
                          onPressed: () async {
                            await getPresentPos();
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
                    color: ColorParams.recommendedColor,
                    child: Text(
                      StringParams.locale["MainPage.start"],
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
