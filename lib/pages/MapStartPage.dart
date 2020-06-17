import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:hikageapp/pages/MapStopPage.dart';
import 'package:hikageapp/utils/LocationUtils.dart';
import 'package:hikageapp/utils/MapTileUtils.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';

class MapStartPage extends StatefulWidget {
  @override
  MapStartPageState createState() => MapStartPageState();
}

class MapStartPageState extends State<MapStartPage> {
  MapController _mapController = MapController();
  List<Marker> _markers = List<Marker>();
  List<Polyline> _polyLines = List<Polyline>();

  LatLng _initialPoint = LatLng(35.6592979, 139.7005656);
  LatLng _presentPoint;

  LocationUtils _locationUtils = LocationUtils();

  @override
  void initState() {
    super.initState();
    _presentPoint = _initialPoint;

    _markers.add(
      Marker(
        point: _initialPoint,
        height: 80.0,
        width: 70.0,
        anchorPos: AnchorPos.exactly(Anchor(35.0, 20.0)),
        builder: (ctx) => Container(
          child: Image.asset(
            "assets/img/start_icon.png",
          ),
        ),
      ),
    );
  }

  getPresentPos() async {
    LocationData ld = await _locationUtils.getPresentPos();
    _initialPoint = LatLng(ld.latitude, ld.longitude);
  }

  void centerMarker(MapPosition pos) {
    if (_markers != null && _markers.isNotEmpty && _markers.length > 0) {
      _markers.clear();
    }

    _presentPoint = pos.center;

    _markers.add(
      Marker(
        point: pos.center,
        height: 80.0,
        width: 70.0,
        anchorPos: AnchorPos.exactly(Anchor(35.0, 20.0)),
        builder: (ctx) => Container(
          child: Image.asset(
            "assets/img/start_icon.png",
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
              flex: 5,
              child: Stack(
                children: <Widget>[
                  FlutterMap(
                    options: MapOptions(
                        center: _initialPoint,
                        maxZoom: 18.0,
                        minZoom: 15.0,
                        zoom: 16.0,
                        /*
                        nePanBoundary:
                            LatLng(35.6592979 + 0.005, 139.7005656 + 0.005),
                        swPanBoundary:
                            LatLng(35.6592979 - 0.005, 139.7005656 - 0.005),
                         */
                        onPositionChanged: (pos, t) {
                          centerMarker(pos);
                        }),
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
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 20.0, 30.0),
                      child: FloatingActionButton(
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
              flex: 2,
              child: Container(
                padding: EdgeInsets.only(left: 24.0, right: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Pick your origin",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        color: Color(0xff000000),
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                        letterSpacing: 2,
                      ),
                    ),
                    Text(
                      "Move the map and drop the pin at the location where you want to start your route.",
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        color: Color(0xff6c6c6c),
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        letterSpacing: 0.1625,
                      ),
                    ),
                    SizedBox(
                      height: 9.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          color: Colors.blue[900],
                          child: Text(
                            "Set",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MapStopPage(
                                _presentPoint,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 8.0,
                        ),
                        OutlineButton(
                          borderSide:
                              BorderSide(color: Colors.blue[900], width: 2.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                                fontSize: 16, color: Colors.blue[900]),
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ],
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
