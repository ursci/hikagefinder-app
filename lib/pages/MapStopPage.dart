import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hikageapp/pages/RouteResultPage.dart';
import 'package:hikageapp/res/StringsParams.dart';
import 'package:hikageapp/utils/DialogUtil.dart';
import 'package:hikageapp/utils/LocationUtils.dart';
import 'package:hikageapp/utils/MapTileUtils.dart';
import 'package:hikageapp/utils/RouteUtils.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';

class MapStopPage extends StatefulWidget {
  final LatLng startPos;

  MapStopPage(this.startPos);

  @override
  MapStopPageState createState() => MapStopPageState();
}

class MapStopPageState extends State<MapStopPage> {
  MapController _mapController = MapController();
  List<Marker> _markers = List<Marker>();
  List<Polyline> _polyLines = List<Polyline>();

  LatLng _initialPoint = LatLng(35.6592979, 139.7005656);
  LocationUtils _locationUtils = LocationUtils();

  @override
  void initState() {
    super.initState();

    if (widget.startPos != null) {
      _initialPoint = widget.startPos;
    }

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

  void centerMarker(MapPosition pos) {
    if (_markers != null && _markers.isNotEmpty && _markers.length > 1) {
      _markers.removeAt(1);
    }

    if (_polyLines != null && _polyLines.isNotEmpty) {
      _polyLines.removeAt(0);
    }

    _polyLines.add(Polyline(
      color: Colors.grey,
      points: [pos.center, widget.startPos],
      strokeWidth: 6.0,
      isDotted: true,
    ));

    _markers.add(
      Marker(
        point: pos.center,
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
  }

  showErrorMsg(int res) {
    String errMsg = StringParams.locale["MapStopPage.errorDlgMsg"];

    if (res == 2) {
      errMsg = StringParams.locale["MapStopPage.errorTimeDlgMsg"];
    } else if (res == 3) {
      errMsg = StringParams.locale["MapStopPage.errorAreaDlgMsg"];
    }

    DialogUtil.showCustomDialog(
        context,
        StringParams.locale["MapStopPage.errorDlgTitle"],
        errMsg,
        StringParams.locale["MapStopPage.errorDlgClose"],
        titleColor: Colors.red);
  }

  findRoute() async {
    DialogUtil.showOnSendDialog(
        context, StringParams.locale["MapStopPage.findRoute"]);

    RouteUtils routeUtils = RouteUtils();

    bool result =
        await routeUtils.findRoute(widget.startPos, _mapController.center);

    Navigator.pop(context);

    if (!result) {
      /// No Features or other error
      showErrorMsg(routeUtils.errorCode);
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RouteResultPage(
            widget.startPos,
            _mapController.center,
            routeUtils.shortestGeoJson,
            routeUtils.recommendedGeoJson),
      ),
    );
  }

  getPresentPos() async {
    LocationData ld = await _locationUtils.getPresentPos();
    _initialPoint = LatLng(ld.latitude, ld.longitude);
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
                            LatLng(35.6592979 - 0.005, 139.7005656 - 0.005),*/
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
                      StringParams.locale["MapStopPage.title"],
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
                      StringParams.locale["MapStopPage.message"],
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
                            StringParams.locale["MapStopPage.set"],
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          onPressed: () => findRoute(),
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
                            StringParams.locale["MapStopPage.cancel"],
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
