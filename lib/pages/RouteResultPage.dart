import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

class RouteResultPage extends StatefulWidget {
  final LatLng startPos;
  final LatLng stopPos;

  RouteResultPage(this.startPos, this.stopPos);

  @override
  RouteResultPageState createState() => RouteResultPageState();
}

class RouteResultPageState extends State<RouteResultPage> {
  MapController _mapController = MapController();
  List<Marker> _markers = List<Marker>();
  List<Polyline> _polyLines = List<Polyline>();

  LatLng _initialPoint = LatLng(35.6592979, 139.7005656);

  String _timeChosen = "Now";

  @override
  void initState() {
    super.initState();

    ///
    /// Fitting points into the screen
    ///
    _mapController.onReady.then((value) {
      _mapController.fitBounds(
        LatLngBounds(widget.startPos, widget.stopPos),
        options: FitBoundsOptions(padding: EdgeInsets.all(36.0)),
      );
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

    _polyLines.add(Polyline(
      color: Colors.blue[900],
      points: [widget.startPos, widget.stopPos],
      strokeWidth: 6.0,
      isDotted: false,
    ));
  }

  @override
  Widget build(BuildContext context) {
    Widget flutterMap = FlutterMap(
      options: MapOptions(
        center: _initialPoint,
        maxZoom: 18.0,
        minZoom: 14.0,
        zoom: 18.0,
      ),
      mapController: _mapController,
      layers: [
        TileLayerOptions(
          urlTemplate: //'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              //subdomains: ['a', 'b', 'c'],
              'https://cyberjapandata.gsi.go.jp/xyz/pale/{z}/{x}/{y}.png?xxx=1',
        ),
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
          "Departure: $_timeChosen",
          style: TextStyle(
            color: Color(0xff777777),
          ),
        ),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                ).then((timeOfDay) => setState(() {
                      if (timeOfDay != null) {
                        _timeChosen = timeOfDay.format(context);
                      }
                    }));
              },
              icon: Icon(
                Icons.search,
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
              flex: 2,
              child: Container(
                padding: EdgeInsets.only(left: 24.0, right: 24.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "RECOMMENDED",
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
                            "30% Sunshine",
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
                        color: Colors.blue[900],
                        child: Text(
                          "Use Recommended Route",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        onPressed: () => {},
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        "FASTEST",
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          color: Colors.blue,
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
                            "30% Sunlight",
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
                        color: Colors.blue,
                        child: Text(
                          "Use Fastest Route",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        onPressed: () => {},
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
