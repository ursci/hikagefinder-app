import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

class MapEntry extends StatefulWidget {
  @override
  MapEntryState createState() => MapEntryState();
}

class MapEntryState extends State<MapEntry> {
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
              Icons.location_on,
              size: 45.0,
              color: Colors.green[900],
            ),
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
      points: [pos.center, _initialPoint],
      strokeWidth: 6.0,
      isDotted: true,
    ));

    _markers.add(
      Marker(
        point: pos.center,
        height: 49.0,
        width: 49.0,
        anchorPos: AnchorPos.exactly(Anchor(10.0, 10.0)),
        builder: (ctx) => Container(
          child: FlatButton(
            onPressed: () => {},
            child: Icon(
              Icons.location_on,
              size: 45.0,
              color: Colors.red,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hikage Route Finder"),
      ),
      body: Center(
        child: FlutterMap(
          options: MapOptions(
              center: _initialPoint,
              maxZoom: 18.0,
              minZoom: 17.0,
              zoom: 18.0,
              nePanBoundary: LatLng(35.6592979 + 0.005, 139.7005656 + 0.005),
              swPanBoundary: LatLng(35.6592979 - 0.005, 139.7005656 - 0.005),
              onPositionChanged: (pos, t) {
                centerMarker(pos);
              }),
          mapController: _mapController,
          layers: [
            TileLayerOptions(
              urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              subdomains: ['a', 'b', 'c'],
            ),
            PolylineLayerOptions(
              polylines: _polyLines,
            ),
            MarkerLayerOptions(
              markers: _markers,
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Center Position',
        backgroundColor: Colors.green[900],
        onPressed: () {
          _mapController.move(_initialPoint, _mapController.zoom);
        },
        child: Icon(Icons.my_location),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
