import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geojson/geojson.dart';
import 'package:hikageapp/pages/SelectedRoutePage.dart';
import 'package:hikageapp/res/ColorParams.dart';
import 'package:hikageapp/res/StringsParams.dart';
import 'package:hikageapp/utils/DialogUtil.dart';
import 'package:hikageapp/utils/LocationUtils.dart';
import 'package:hikageapp/utils/MapTileUtils.dart';
import 'package:hikageapp/utils/RouteUtils.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';

class RouteResultPage extends StatefulWidget {
  final LatLng startPos;
  final LatLng stopPos;
  final GeoJson shortest;
  final GeoJson recommended;

  RouteResultPage(this.startPos, this.stopPos, this.shortest, this.recommended);

  @override
  RouteResultPageState createState() => RouteResultPageState();
}

class RouteResultPageState extends State<RouteResultPage> {
  MapController _mapController = MapController();
  List<Marker> _markers = List<Marker>();
  List<Polyline> _polyLines = List<Polyline>();

  GeoJson _recommendedGeoJson;
  GeoJson _shortestGeoJson;
  double _recoSunLight;
  double _shortSunLight;

  LatLng _initialPoint = LatLng(35.6592979, 139.7005656);

  String _timeChosen = StringParams.locale["RouteResultPage.now"];

  LocationUtils _locationUtils = LocationUtils();

  @override
  void initState() {
    super.initState();

    _recommendedGeoJson = widget.recommended;
    _shortestGeoJson = widget.shortest;

    ///
    /// Fitting points into the screen
    ///
    _mapController.onReady.then((value) {
      fitMap();
    });

    if (widget.startPos != null) {
      _initialPoint = widget.startPos;
    }

    _markers.add(
      Marker(
        point: widget.startPos,
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

    _markers.add(
      Marker(
        point: widget.stopPos,
        height: 80.0,
        width: 70.0,
        anchorPos: AnchorPos.exactly(Anchor(35.0, 20.0)),
        builder: (ctx) => Container(
          child: Image.asset(
            "assets/img/dest_icon.png",
          ),
        ),
      ),
    );

    drawRoute(false);
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
        anchorPos: AnchorPos.exactly(Anchor(18.0, 18.0)),
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

  drawRoute(bool shortestFirst) {
    _recoSunLight =
        _recommendedGeoJson.features[0].properties["sunlight_rate"] * 100;
    _shortSunLight =
        _shortestGeoJson.features[0].properties["sunlight_rate"] * 100;

    _polyLines.clear();

    if (shortestFirst) {
      _polyLines.add(Polyline(
        color: ColorParams.recommendedColor,
        points: _recommendedGeoJson.lines[0].geoSerie
            .toLatLng(), //[widget.startPos, widget.stopPos],
        strokeWidth: 6.0,
        isDotted: false,
      ));

      _polyLines.add(Polyline(
        color: ColorParams.fastestColor,
        points: _shortestGeoJson.lines[0].geoSerie
            .toLatLng(), //[widget.startPos, widget.stopPos],
        strokeWidth: 6.0,
        isDotted: false,
      ));
    } else {
      _polyLines.add(Polyline(
        color: ColorParams.fastestColor,
        points: _shortestGeoJson.lines[0].geoSerie
            .toLatLng(), //[widget.startPos, widget.stopPos],
        strokeWidth: 6.0,
        isDotted: false,
      ));

      _polyLines.add(Polyline(
        color: ColorParams.recommendedColor,
        points: _recommendedGeoJson.lines[0].geoSerie
            .toLatLng(), //[widget.startPos, widget.stopPos],
        strokeWidth: 6.0,
        isDotted: false,
      ));
    }
  }

  fitMap() {
    _mapController.fitBounds(
      LatLngBounds(widget.startPos, widget.stopPos),
      options: FitBoundsOptions(padding: EdgeInsets.all(36.0)),
    );
  }

  findRoute(TimeOfDay timeOfDay) async {
    RouteUtils routeUtils = RouteUtils();

    DateTime now = DateTime.now();
    DateTime rNow = DateTime(
        now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);

    DialogUtil.showOnSendDialog(
        context, StringParams.locale["RouteResultPage.findRoute"]);

    bool result = await routeUtils.findRoute(widget.startPos, widget.stopPos,
        dateParam: rNow);

    Navigator.pop(context);

    if (result) {
      _timeChosen = timeOfDay.format(context);
      _recommendedGeoJson = routeUtils.recommendedGeoJson;
      _shortestGeoJson = routeUtils.shortestGeoJson;

      setState(() {
        drawRoute(false);
      });
    } else {
      String errMsg = StringParams.locale["RouteResultPage.errorDlgMsg"];
      int res = routeUtils.errorCode;

      if (res == 2) {
        errMsg = StringParams.locale["RouteResultPage.errorTimeDlgMsg"];
      } else if (res == 3) {
        errMsg = StringParams.locale["RouteResultPage.errorAreaDlgMsg"];
      }

      DialogUtil.showCustomDialog(
          context,
          StringParams.locale["RouteResultPage.errorDlgTitle"],
          errMsg,
          StringParams.locale["RouteResultPage.errorDlgClose"],
          titleColor: Colors.red);
    }
  }

  getPresentPos() async {
    LocationData ld = await _locationUtils.getPresentPos();
    _initialPoint = LatLng(ld.latitude, ld.longitude);
  }

  @override
  Widget build(BuildContext context) {
    List<Polyline> fastestRoute = List<Polyline>();
    List<Polyline> recommendedRoute = List<Polyline>();

    fastestRoute.add(_polyLines[0]);
    recommendedRoute.add(_polyLines[1]);

    Widget flutterMap = FlutterMap(
      options: MapOptions(
        center: _initialPoint,
        maxZoom: 16.0,
        minZoom: 14.0,
        zoom: 18.0,
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
        iconTheme: IconThemeData(
          color: Color(0xff777777),
        ),
        title: Text(
          "${StringParams.locale["RouteResultPage.departure"]}: $_timeChosen",
          style: TextStyle(
            color: Color(0xff777777),
          ),
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              onPressed: () {
                showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                ).then((timeOfDay) async {
                  if (timeOfDay != null) {
                    await findRoute(timeOfDay);
                    fitMap();
                  }
                });
              },
              icon: Icon(
                Icons.timer,
                color: Colors.black, //Color(0xff777777),
              ))
        ],
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 3,
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
                          }),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                padding: EdgeInsets.all(10.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        StringParams.locale["RouteResultPage.recommended"],
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          color: Colors.blue[900],
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                          letterSpacing: 2,
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.wb_sunny),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            "${_recoSunLight.toStringAsFixed(2)}% ${StringParams.locale["RouteResultPage.sunlight"]}",
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              color: Color(0xff6c6c6c),
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                              letterSpacing: 0.1625,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        color: ColorParams.recommendedColor,
                        child: Text(
                          StringParams.locale["RouteResultPage.useRecommended"],
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        //onPressed: () => setState(() => drawRoute(false)),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SelectedRoutePage(
                              recommendedRoute,
                              _markers,
                              StringParams
                                  .locale["RouteResultPage.recommended"],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Text(
                        StringParams.locale["RouteResultPage.fastest"],
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          color: ColorParams.fastestColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                          letterSpacing: 2,
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.wb_sunny),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            "${_shortSunLight.toStringAsFixed(2)}% ${StringParams.locale["RouteResultPage.sunlight"]}",
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              color: Color(0xff6c6c6c),
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                              letterSpacing: 0.1625,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        color: ColorParams.fastestColor,
                        child: Text(
                          StringParams.locale["RouteResultPage.useFastest"],
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        //onPressed: () => setState(() => drawRoute(true)),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SelectedRoutePage(
                              fastestRoute,
                              _markers,
                              StringParams.locale["RouteResultPage.fastest"],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      )
                    ],
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
