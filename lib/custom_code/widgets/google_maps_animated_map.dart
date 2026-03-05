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

import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'dart:io' show Platform;

class GoogleMapsAnimatedMap extends StatefulWidget {
  const GoogleMapsAnimatedMap({
    Key? key,
    this.width,
    this.height,
    required this.apiKey,
    required this.androidMapId,
    required this.iOSMapId,
    required this.webMapId,
    this.initialCenter, // Это LatLng от FlutterFlow
    required this.zoomLevel,
    required this.allowInteraction,
    this.onAddressChanged,
    this.searchTerm,
  }) : super(key: key);

  final double? width;
  final double? height;
  final String apiKey;
  final String androidMapId;
  final String iOSMapId;
  final String webMapId;
  final LatLng? initialCenter; // LatLng от FlutterFlow
  final double zoomLevel;
  final bool allowInteraction;
  final String? searchTerm;

  final Future<dynamic> Function(String address, double lat, double lng)?
      onAddressChanged;

  @override
  _GoogleMapsAnimatedMapState createState() => _GoogleMapsAnimatedMapState();
}

class _GoogleMapsAnimatedMapState extends State<GoogleMapsAnimatedMap> {
  // Используем gmaps. типы
  final Completer<gmaps.GoogleMapController> _controller = Completer();
  gmaps.GoogleMapController? _mapController;
  Timer? _debounce;
  String _lastSearchedTerm = '';

  // Константа тоже должна быть gmaps.LatLng
  static const gmaps.LatLng _defaultLocation = gmaps.LatLng(43.6532, -79.3832);
  gmaps.LatLng _currentCenter = _defaultLocation;

  String _currentMapId = '';

  @override
  void initState() {
    super.initState();
    _currentCenter = _getInitialCenter();
    _currentMapId = _getMapIdForPlatform();
  }

  String _getMapIdForPlatform() {
    if (kIsWeb) {
      return widget.webMapId;
    } else if (Platform.isAndroid) {
      return widget.androidMapId;
    } else if (Platform.isIOS) {
      return widget.iOSMapId;
    }
    return '';
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _mapController?.dispose();
    super.dispose();
  }

  // Конвертируем FlutterFlow LatLng в Google Maps LatLng
  gmaps.LatLng _getInitialCenter() {
    if (widget.initialCenter != null) {
      return gmaps.LatLng(
          widget.initialCenter!.latitude, widget.initialCenter!.longitude);
    }
    return _defaultLocation;
  }

  Future<void> _fetchAddress(double lat, double lng) async {
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=${widget.apiKey}&language=ru';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['results'] != null && data['results'].isNotEmpty) {
          String address = data['results'][0]['formatted_address'];
          if (widget.onAddressChanged != null) {
            widget.onAddressChanged!(address, lat, lng);
          }
        }
      }
    } catch (e) {
      print('Google Maps Geocoding Error: $e');
    }
  }

  Future<void> _searchByText(String text) async {
    if (text.isEmpty) return;

    final encodedText = Uri.encodeComponent(text);
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?address=$encodedText&key=${widget.apiKey}&language=ru';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['results'] != null && data['results'].isNotEmpty) {
          final location = data['results'][0]['geometry']['location'];
          double lat = location['lat'];
          double lng = location['lng'];

          final gmaps.GoogleMapController controller = await _controller.future;
          controller.animateCamera(gmaps.CameraUpdate.newLatLngZoom(
              gmaps.LatLng(lat, lng), widget.zoomLevel));

          String formattedAddress = data['results'][0]['formatted_address'];
          if (widget.onAddressChanged != null) {
            widget.onAddressChanged!(formattedAddress, lat, lng);
          }
        }
      }
    } catch (e) {
      print('Search Error: $e');
    }
  }

  @override
  void didUpdateWidget(GoogleMapsAnimatedMap oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.searchTerm != null &&
        widget.searchTerm!.isNotEmpty &&
        widget.searchTerm != oldWidget.searchTerm &&
        widget.searchTerm != _lastSearchedTerm) {
      _lastSearchedTerm = widget.searchTerm!;
      _searchByText(widget.searchTerm!);
    }

    if (oldWidget.initialCenter != widget.initialCenter &&
        widget.initialCenter != null) {
      // При изменении параметра нужно сконвертировать координаты
      _moveCamera(gmaps.LatLng(
          widget.initialCenter!.latitude, widget.initialCenter!.longitude));
    }
  }

  Future<void> _moveCamera(gmaps.LatLng pos) async {
    final gmaps.GoogleMapController controller = await _controller.future;
    controller.animateCamera(gmaps.CameraUpdate.newLatLng(pos));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: widget.width ?? MediaQuery.of(context).size.width,
          height: widget.height ?? 400,
          child: gmaps.GoogleMap(
            // Используем префикс
            cloudMapId: _currentMapId,

            mapType: gmaps.MapType.normal,
            initialCameraPosition: gmaps.CameraPosition(
              target: _getInitialCenter(),
              zoom: widget.zoomLevel,
            ),
            onMapCreated: (gmaps.GoogleMapController controller) {
              _controller.complete(controller);
              _mapController = controller;
              if (widget.initialCenter != null) {
                _fetchAddress(widget.initialCenter!.latitude,
                    widget.initialCenter!.longitude);
              }
            },

            // --- НАСТРОЙКИ UI: ОТКЛЮЧАЕМ ВСЁ ЛИШНЕЕ ---
            zoomControlsEnabled: false, // Кнопки +/-
            mapToolbarEnabled: false, // Панель снизу (Маршрут/Карты) на Android
            myLocationButtonEnabled: false, // Кнопка "Где я"
            compassEnabled: false, // Компас
            trafficEnabled: false, // Слой пробок

            // Управление жестами (зависит от allowInteraction)
            rotateGesturesEnabled: widget.allowInteraction,
            scrollGesturesEnabled: widget.allowInteraction,
            zoomGesturesEnabled: widget.allowInteraction,
            tiltGesturesEnabled: widget.allowInteraction,
            myLocationEnabled:
                true, // Синяя точка "Я" остается, но кнопка скрыта

            // Логика движения
            onCameraMove: (gmaps.CameraPosition position) {
              _currentCenter = position.target;
              if (_debounce?.isActive ?? false) _debounce?.cancel();
            },
            onCameraIdle: () {
              _debounce = Timer(const Duration(milliseconds: 800), () {
                _fetchAddress(
                    _currentCenter.latitude, _currentCenter.longitude);
              });
            },
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
