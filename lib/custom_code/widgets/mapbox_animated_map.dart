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
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MapboxAnimatedMap extends StatefulWidget {
  const MapboxAnimatedMap({
    Key? key,
    this.width,
    this.height,
    required this.accessToken,
    required this.styleId,
    this.initialCenter,
    required this.zoomLevel,
    required this.allowInteraction,
    this.onAddressChanged,
    this.searchTerm,
    this.language = 'en',
  }) : super(key: key);

  final double? width;
  final double? height;
  final String accessToken;
  final String styleId;
  final LatLng? initialCenter;
  final double zoomLevel;
  final bool allowInteraction;
  final String? searchTerm;
  final String language;

  // ОБНОВЛЕНИЕ: Добавили String city в callback!
  final Future<dynamic> Function(
      String address, String city, double lat, double lng)? onAddressChanged;

  @override
  _MapboxAnimatedMapState createState() => _MapboxAnimatedMapState();
}

class _MapboxAnimatedMapState extends State<MapboxAnimatedMap>
    with TickerProviderStateMixin {
  late final MapController _mapController;
  Timer? _debounce;
  String _lastSearchedTerm = '';

  @override
  void initState() {
    super.initState();
    _mapController = MapController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.initialCenter != null) {
        _fetchAddress(
            widget.initialCenter!.latitude, widget.initialCenter!.longitude);
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _mapController.dispose();
    super.dispose();
  }

  latLng.LatLng _getInitialCenter() {
    if (widget.initialCenter != null) {
      return latLng.LatLng(
          widget.initialCenter!.latitude, widget.initialCenter!.longitude);
    }
    return const latLng.LatLng(0, 0);
  }

  String get _currentLanguage =>
      (widget.language.isNotEmpty) ? widget.language : 'en';

  Future<void> _fetchAddress(double lat, double lng) async {
    final url =
        'https://api.mapbox.com/geocoding/v5/mapbox.places/$lng,$lat.json?access_token=${widget.accessToken}&language=$_currentLanguage&limit=1';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['features'] != null && data['features'].isNotEmpty) {
          final feature = data['features'][0];
          String address = feature['place_name'] ?? '';

          // Парсим город из контекста Mapbox (обычно id начинается с 'place.')
          String city = '';
          if (feature['context'] != null) {
            for (var item in feature['context']) {
              if (item['id'] != null &&
                  item['id'].toString().startsWith('place.')) {
                city = item['text'] ?? '';
                break;
              }
            }
          }

          if (widget.onAddressChanged != null) {
            // Отправляем всё во FlutterFlow UI!
            widget.onAddressChanged!(address, city, lat, lng);
          }
        }
      }
    } catch (e) {
      print('Error fetching address: $e');
    }
  }

  Future<void> _searchByText(String text) async {
    if (text.isEmpty) return;

    final encodedText = Uri.encodeComponent(text);
    final url =
        'https://api.mapbox.com/geocoding/v5/mapbox.places/$encodedText.json?access_token=${widget.accessToken}&language=$_currentLanguage&limit=1';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['features'] != null && data['features'].isNotEmpty) {
          final coords = data['features'][0]['center'];
          double lng = coords[0].toDouble();
          double lat = coords[1].toDouble();

          _animatedMapMove(latLng.LatLng(lat, lng), widget.zoomLevel);
        }
      }
    } catch (e) {
      print('Error searching address: $e');
    }
  }

  void _onMapPositionChanged(MapCamera position, bool hasGesture) {
    if (!hasGesture) return;

    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 600), () {
      _fetchAddress(position.center.latitude, position.center.longitude);
    });
  }

  @override
  void didUpdateWidget(MapboxAnimatedMap oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.language != widget.language) {
      _fetchAddress(_mapController.camera.center.latitude,
          _mapController.camera.center.longitude);
    }

    if (widget.searchTerm != null &&
        widget.searchTerm!.isNotEmpty &&
        widget.searchTerm != oldWidget.searchTerm &&
        widget.searchTerm != _lastSearchedTerm) {
      _lastSearchedTerm = widget.searchTerm!;
      _searchByText(widget.searchTerm!);
    }

    if (oldWidget.initialCenter != widget.initialCenter) {
      _animatedMapMove(_getInitialCenter(), widget.zoomLevel);
    }
  }

  void _animatedMapMove(latLng.LatLng destLocation, double destZoom) {
    final latTween = Tween<double>(
      begin: _mapController.camera.center.latitude,
      end: destLocation.latitude,
    );
    final lngTween = Tween<double>(
      begin: _mapController.camera.center.longitude,
      end: destLocation.longitude,
    );
    final zoomTween = Tween<double>(
      begin: _mapController.camera.zoom,
      end: destZoom,
    );

    final controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    final Animation<double> animation = CurvedAnimation(
      parent: controller,
      curve: Curves.fastOutSlowIn,
    );

    controller.addListener(() {
      _mapController.move(
        latLng.LatLng(
          latTween.evaluate(animation),
          lngTween.evaluate(animation),
        ),
        zoomTween.evaluate(animation),
      );
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
        _fetchAddress(destLocation.latitude, destLocation.longitude);
      }
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    // ... [остальной код метода build оставьте как есть, он не менялся]
    return Stack(
      children: [
        Container(
          width: widget.width ?? MediaQuery.of(context).size.width,
          height: widget.height ?? 400,
          child: FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _getInitialCenter(),
              initialZoom: widget.zoomLevel,
              maxZoom: 22.0,
              minZoom: 1.0,
              onPositionChanged: _onMapPositionChanged,
              interactionOptions: InteractionOptions(
                flags: widget.allowInteraction
                    ? InteractiveFlag.all
                    : InteractiveFlag.none,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate:
                    "https://api.mapbox.com/styles/v1/{id}/tiles/512/{z}/{x}/{y}@2x?access_token={accessToken}",
                additionalOptions: {
                  'accessToken': widget.accessToken,
                  'id': widget.styleId,
                },
                tileSize: 512,
                zoomOffset: -1,
                maxNativeZoom: 22,
                maxZoom: 24,
                tileProvider: NetworkTileProvider(),
              ),
            ],
          ),
        ),
        if (widget.allowInteraction)
          IgnorePointer(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 35),
                child: Icon(
                  Icons.location_on,
                  size: 40,
                  color: FlutterFlowTheme.of(context).primary,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
