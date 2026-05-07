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

import 'index.dart';
import '/custom_code/actions/index.dart';
import '/flutter_flow/custom_functions.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'dart:ui' as ui;

class GoogleMapsAnimatedMap extends StatefulWidget {
  const GoogleMapsAnimatedMap({
    Key? key,
    this.width,
    this.height,
    required this.apiKey,
    required this.androidMapId,
    required this.iOSMapId,
    required this.webMapId,
    this.initialCenter,
    required this.zoomLevel,
    required this.allowInteraction,
    this.onAddressChanged,
    this.searchTerm,
    this.language = 'en',
  }) : super(key: key);

  final double? width;
  final double? height;
  final String apiKey;
  final String androidMapId;
  final String iOSMapId;
  final String webMapId;
  final LatLng? initialCenter;
  final double zoomLevel;
  final bool allowInteraction;
  final String? searchTerm;
  final String language;

  final Future<dynamic> Function(
      String address, String city, double lat, double lng)? onAddressChanged;

  @override
  _GoogleMapsAnimatedMapState createState() => _GoogleMapsAnimatedMapState();
}

class _GoogleMapsAnimatedMapState extends State<GoogleMapsAnimatedMap>
    with TickerProviderStateMixin {
  final Completer<gmaps.GoogleMapController> _controller = Completer();
  gmaps.GoogleMapController? _mapController;
  Timer? _debounce;
  String _lastSearchedTerm = '';

  // Анимация пина
  late AnimationController _pinController;
  late Animation<double> _pinAnimation;
  bool _isMoving = false;

  static const gmaps.LatLng _defaultLocation = gmaps.LatLng(43.6532, -79.3832);
  late gmaps.LatLng _currentCenter;
  String _currentMapId = '';

  @override
  void initState() {
    super.initState();
    _currentCenter = _getInitialCenter();
    _currentMapId = _getMapIdForPlatform();

    // Настройка анимации прыжка
    _pinController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _pinAnimation = Tween<double>(begin: 0, end: 15).animate(
      CurvedAnimation(parent: _pinController, curve: Curves.easeOut),
    );

    // Блок с dart:html удален для обеспечения успешной сборки на Android/iOS
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _pinController.dispose();
    super.dispose();
  }

  gmaps.LatLng _getInitialCenter() {
    if (widget.initialCenter != null) {
      return gmaps.LatLng(
          widget.initialCenter!.latitude, widget.initialCenter!.longitude);
    }
    return _defaultLocation;
  }

  String _getMapIdForPlatform() {
    String id = '';
    if (kIsWeb) {
      id = widget.webMapId;
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      id = widget.androidMapId;
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      id = widget.iOSMapId;
    }

    if (id.isEmpty || id.toLowerCase() == 'string') {
      return '51e65d1a42c6dcc2d42df44f';
    }
    return id;
  }

  String get _currentLanguage {
    return (widget.language.isNotEmpty && widget.language.length <= 5)
        ? widget.language
        : 'en';
  }

  Future<void> _fetchAddress(double lat, double lng) async {
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=${widget.apiKey}&language=$_currentLanguage';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['results'] != null && data['results'].isNotEmpty) {
          final result = data['results'][0];
          String address = result['formatted_address'] ?? '';

          String city = '';
          if (result['address_components'] != null) {
            for (var component in result['address_components']) {
              List types = component['types'];
              if (types.contains('locality')) {
                city = component['long_name'] ?? '';
                break;
              }
            }
            if (city.isEmpty) {
              for (var component in result['address_components']) {
                List types = component['types'];
                if (types.contains('administrative_area_level_2')) {
                  city = component['long_name'] ?? '';
                  break;
                }
              }
            }
          }

          if (widget.onAddressChanged != null) {
            widget.onAddressChanged!(
                address, city, lat.toDouble(), lng.toDouble());
          }
        }
      }
    } catch (e) {
      debugPrint('Geocoding Error: $e');
    }
  }

  Future<void> _searchByText(String text) async {
    if (text.isEmpty || _mapController == null) return;

    final encodedText = Uri.encodeComponent(text);
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?address=$encodedText&key=${widget.apiKey}&language=$_currentLanguage';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['results'] != null && data['results'].isNotEmpty) {
          final location = data['results'][0]['geometry']['location'];
          double lat = (location['lat'] as num).toDouble();
          double lng = (location['lng'] as num).toDouble();

          _mapController!.animateCamera(
            gmaps.CameraUpdate.newLatLngZoom(
                gmaps.LatLng(lat, lng), widget.zoomLevel),
          );
        }
      }
    } catch (e) {
      debugPrint('Search Error: $e');
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
      _mapController?.animateCamera(
        gmaps.CameraUpdate.newLatLng(gmaps.LatLng(
            widget.initialCenter!.latitude, widget.initialCenter!.longitude)),
      );
    }
  }

  void _onCameraIdle() {
    if (_mapController == null) return;
    _fetchAddress(_currentCenter.latitude, _currentCenter.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        gmaps.GoogleMap(
          mapType: gmaps.MapType.normal,
          cloudMapId: _currentMapId,
          initialCameraPosition: gmaps.CameraPosition(
            target: _currentCenter,
            zoom: widget.zoomLevel,
          ),
          onMapCreated: (gmaps.GoogleMapController controller) {
            _controller.complete(controller);
            _mapController = controller;

            if (widget.searchTerm != null && widget.searchTerm!.isNotEmpty) {
              _searchByText(widget.searchTerm!);
            } else {
              _fetchAddress(_currentCenter.latitude, _currentCenter.longitude);
            }
          },
          onCameraMove: (gmaps.CameraPosition position) {
            _currentCenter = position.target;
            if (!_isMoving) {
              setState(() => _isMoving = true);
              _pinController.forward();
            }
          },
          onCameraIdle: () {
            if (_isMoving) {
              setState(() => _isMoving = false);
              _pinController.reverse();
            }
            _onCameraIdle();
          },
          myLocationEnabled: false,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          mapToolbarEnabled: false,
          compassEnabled: false,
          indoorViewEnabled: false,
          trafficEnabled: false,
          rotateGesturesEnabled: widget.allowInteraction,
          scrollGesturesEnabled: widget.allowInteraction,
          tiltGesturesEnabled: widget.allowInteraction,
          zoomGesturesEnabled: widget.allowInteraction,
        ),
        if (widget.allowInteraction)
          IgnorePointer(
            child: Center(
              child: AnimatedBuilder(
                animation: _pinAnimation,
                builder: (context, child) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Пин в стиле Uber
                      Transform.translate(
                        offset: Offset(0, -_pinAnimation.value - 24),
                        child: Stack(
                          alignment: Alignment.center,
                          clipBehavior: Clip.none,
                          children: [
                            Positioned(
                              bottom: -10,
                              child: Container(
                                width: 4.0,
                                height: 16,
                                decoration: const BoxDecoration(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.white, width: 2.5),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Тень
                      Container(
                        width: 18 - (_pinAnimation.value / 2),
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.15),
                          borderRadius:
                              BorderRadius.all(Radius.elliptical(18, 5)),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
      ],
    );
  }
}
