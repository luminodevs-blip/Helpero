// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latLng;
import 'package:flutter_radar/flutter_radar.dart';
import 'dart:async';

class RadarAnimatedMap extends StatefulWidget {
  const RadarAnimatedMap({
    Key? key,
    this.width,
    this.height,
    required this.publishableKey,
    required this.mapStyle,
    this.initialCenter,
    required this.zoomLevel,
    required this.allowInteraction,
    this.onAddressChanged,
  }) : super(key: key);

  final double? width;
  final double? height;
  final String publishableKey;
  final String mapStyle;
  final LatLng? initialCenter;
  final double zoomLevel;
  final bool allowInteraction;
  final Future<dynamic> Function(String? address)? onAddressChanged;

  @override
  _RadarAnimatedMapState createState() => _RadarAnimatedMapState();
}

class _RadarAnimatedMapState extends State<RadarAnimatedMap>
    with TickerProviderStateMixin {
  late final MapController _mapController;
  Timer? _debounceTimer;
  bool _isRadarInitialized = false;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _initRadar();
  }

  // Инициализация SDK внутри виджета (на случай если не сделали глобально)
  Future<void> _initRadar() async {
    await Radar.initialize(widget.publishableKey);
    setState(() {
      _isRadarInitialized = true;
    });
  }

  latLng.LatLng _getCenter() {
    if (widget.initialCenter != null) {
      return latLng.LatLng(
          widget.initialCenter!.latitude, widget.initialCenter!.longitude);
    }
    return const latLng.LatLng(43.6532, -79.3832);
  }

  // Использование официального метода SDK для получения адреса
  Future<void> _getAddress(latLng.LatLng coords) async {
    if (!_isRadarInitialized) return;

    try {
      // Метод SDK: reverseGeocode
      var result = await Radar.reverseGeocode(
        location: {
          'latitude': coords.latitude,
          'longitude': coords.longitude,
        },
      );

      if (result?['status'] == 'SUCCESS') {
        List? addresses = result?['addresses'];
        if (addresses != null && addresses.isNotEmpty) {
          String? formattedAddress = addresses[0]['formattedAddress'];
          if (widget.onAddressChanged != null) {
            widget.onAddressChanged!(formattedAddress);
          }
        }
      }
    } catch (e) {
      print("Radar SDK Reverse Geocode Error: $e");
    }
  }

  @override
  void didUpdateWidget(RadarAnimatedMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialCenter != widget.initialCenter) {
      _animatedMapMove(_getCenter(), widget.zoomLevel);
    }
  }

  void _animatedMapMove(latLng.LatLng destLocation, double destZoom) {
    final latTween = Tween<double>(
        begin: _mapController.camera.center.latitude,
        end: destLocation.latitude);
    final lngTween = Tween<double>(
        begin: _mapController.camera.center.longitude,
        end: destLocation.longitude);

    final controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    final Animation<double> animation =
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    controller.addListener(() {
      _mapController.move(
          latLng.LatLng(
              latTween.evaluate(animation), lngTween.evaluate(animation)),
          _mapController.camera.zoom);
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) controller.dispose();
    });
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final String radarTileUrl =
        "https://api.radar.io/maps/static/tiles/${widget.mapStyle}/{z}/{x}/{y}.png?publishableKey=${widget.publishableKey}";

    return Container(
      width: widget.width ?? MediaQuery.of(context).size.width,
      height: widget.height ?? 400,
      child: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: _getCenter(),
          initialZoom: widget.zoomLevel,
          interactionOptions: InteractionOptions(
            flags: widget.allowInteraction
                ? InteractiveFlag.all
                : InteractiveFlag.none,
          ),
          onPositionChanged: (camera, hasGesture) {
            if (hasGesture) {
              _debounceTimer?.cancel();
              _debounceTimer = Timer(const Duration(milliseconds: 700), () {
                _getAddress(camera.center);
              });
            }
          },
        ),
        children: [
          TileLayer(
            urlTemplate: radarTileUrl,
            tileProvider: NetworkTileProvider(),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}
