import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hikageapp/res/StringsParams.dart';
import 'package:hikageapp/utils/LocationUtils.dart';
import 'package:hikageapp/utils/MapTileUtils.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';

class SelectedRoutePage extends StatefulWidget {
  final List<Marker> routeMarkers;
  final List<Polyline> routePolyLines;
  final String routeText;

  SelectedRoutePage(this.routePolyLines, this.routeMarkers, this.routeText);

  @override
  SelectedRoutePageState createState() => SelectedRoutePageState();
}

class SelectedRoutePageState extends State<SelectedRoutePage> {
  MapController _mapController = MapController();
  LocationUtils _locationUtils = LocationUtils();

  StreamSubscription<LocationData> _streamSubscription;

  List<Marker> _markers = List<Marker>();
  List<Polyline> _polyLines = List<Polyline>();
  String _routeText;
  LatLng _initialPoint;

  @override
  void initState() {
    super.initState();

    _routeText = widget.routeText;

    _markers.add(widget.routeMarkers[0]);
    _markers.add(widget.routeMarkers[1]);

    ///
    /// Starting GPS Location Stream
    ///
    /*
    _locationUtils.changeSettings(LocationAccuracy.high,
        distanceInterval: GPSParams.distanceInterval);

    _streamSubscription = _locationUtils.getLocationStream().listen((data) {
      _initialPoint = LatLng(data.latitude, data.longitude);
      debugPrint("GPS: ${data.toString()}");
      drawGpsPos(_initialPoint);
      _mapController.move(_initialPoint, _mapController.zoom);
    });
    */

    _mapController.onReady.then((val) {
      _mapController.fitBounds(
        LatLngBounds(_markers[1].point, _markers[0].point),
        options: FitBoundsOptions(
          padding: EdgeInsets.all(36.0),
        ),
      );

      _polyLines.add(Polyline(
        color: widget.routePolyLines[0].color,
        points: widget.routePolyLines[0].points,
        strokeWidth: widget.routePolyLines[0].strokeWidth,
      ));
    });
  }

  getPresentPos() async {
    LocationData ld = await _locationUtils.getPresentPos();
    _initialPoint = LatLng(ld.latitude, ld.longitude);
  }

  drawGpsPos(LatLng pos) {
    if (_markers.length > 2) {
      _markers.removeAt(2);
    }

    _markers.add(
      Marker(
        point: pos,
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
    Widget flutterMap = FlutterMap(
      options: MapOptions(
        maxZoom: 18.0,
        minZoom: 14.0,
        center: _markers[0].point,
        zoom: 15.0,
      ),
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
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _routeText + " ${StringParams.locale["SelectedRoutePage.route"]}",
          style: TextStyle(
            color: Color(0xff777777),
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Color(0xff777777),
        ),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 7,
              child: Stack(
                children: <Widget>[
                  flutterMap,
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
                          drawGpsPos(_initialPoint);
                          _mapController.move(
                              _initialPoint, _mapController.zoom);
                        },
                      ),
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
                      StringParams.locale["SelectedRoutePage.return"],
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    onPressed: () => Navigator.pop(context),
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
  void deactivate() {
    if (_streamSubscription != null) {
      _streamSubscription.cancel();
    }
    super.deactivate();
    debugPrint("Deactivated");
  }

  @override
  void dispose() {
    if (_streamSubscription != null) {
      _streamSubscription.cancel();
    }
    super.dispose();
  }
}
