// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

/// Используется на Главной странице.
class ServiceCategoryStruct extends BaseStruct {
  ServiceCategoryStruct({
    int? id,
    String? name,
    String? slug,

    /// Картинка/Иконка для Главной
    String? imageUrl,

    ///  Видео-обложка для страницы категории
    String? videoUrl,
    double? rating,
    String? bookingsCount,
    String? packageHeader,
    String? miniHeader,
  })  : _id = id,
        _name = name,
        _slug = slug,
        _imageUrl = imageUrl,
        _videoUrl = videoUrl,
        _rating = rating,
        _bookingsCount = bookingsCount,
        _packageHeader = packageHeader,
        _miniHeader = miniHeader;

  // "id" field.
  int? _id;
  int get id => _id ?? 0;
  set id(int? val) => _id = val;

  void incrementId(int amount) => id = id + amount;

  bool hasId() => _id != null;

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  set name(String? val) => _name = val;

  bool hasName() => _name != null;

  // "slug" field.
  String? _slug;
  String get slug => _slug ?? '';
  set slug(String? val) => _slug = val;

  bool hasSlug() => _slug != null;

  // "imageUrl" field.
  String? _imageUrl;
  String get imageUrl => _imageUrl ?? '';
  set imageUrl(String? val) => _imageUrl = val;

  bool hasImageUrl() => _imageUrl != null;

  // "videoUrl" field.
  String? _videoUrl;
  String get videoUrl => _videoUrl ?? '';
  set videoUrl(String? val) => _videoUrl = val;

  bool hasVideoUrl() => _videoUrl != null;

  // "rating" field.
  double? _rating;
  double get rating => _rating ?? 0.0;
  set rating(double? val) => _rating = val;

  void incrementRating(double amount) => rating = rating + amount;

  bool hasRating() => _rating != null;

  // "bookingsCount" field.
  String? _bookingsCount;
  String get bookingsCount => _bookingsCount ?? '';
  set bookingsCount(String? val) => _bookingsCount = val;

  bool hasBookingsCount() => _bookingsCount != null;

  // "package_header" field.
  String? _packageHeader;
  String get packageHeader => _packageHeader ?? '';
  set packageHeader(String? val) => _packageHeader = val;

  bool hasPackageHeader() => _packageHeader != null;

  // "mini_header" field.
  String? _miniHeader;
  String get miniHeader => _miniHeader ?? '';
  set miniHeader(String? val) => _miniHeader = val;

  bool hasMiniHeader() => _miniHeader != null;

  static ServiceCategoryStruct fromMap(Map<String, dynamic> data) =>
      ServiceCategoryStruct(
        id: castToType<int>(data['id']),
        name: data['name'] as String?,
        slug: data['slug'] as String?,
        imageUrl: data['imageUrl'] as String?,
        videoUrl: data['videoUrl'] as String?,
        rating: castToType<double>(data['rating']),
        bookingsCount: data['bookingsCount'] as String?,
        packageHeader: data['package_header'] as String?,
        miniHeader: data['mini_header'] as String?,
      );

  static ServiceCategoryStruct? maybeFromMap(dynamic data) => data is Map
      ? ServiceCategoryStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'name': _name,
        'slug': _slug,
        'imageUrl': _imageUrl,
        'videoUrl': _videoUrl,
        'rating': _rating,
        'bookingsCount': _bookingsCount,
        'package_header': _packageHeader,
        'mini_header': _miniHeader,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.int,
        ),
        'name': serializeParam(
          _name,
          ParamType.String,
        ),
        'slug': serializeParam(
          _slug,
          ParamType.String,
        ),
        'imageUrl': serializeParam(
          _imageUrl,
          ParamType.String,
        ),
        'videoUrl': serializeParam(
          _videoUrl,
          ParamType.String,
        ),
        'rating': serializeParam(
          _rating,
          ParamType.double,
        ),
        'bookingsCount': serializeParam(
          _bookingsCount,
          ParamType.String,
        ),
        'package_header': serializeParam(
          _packageHeader,
          ParamType.String,
        ),
        'mini_header': serializeParam(
          _miniHeader,
          ParamType.String,
        ),
      }.withoutNulls;

  static ServiceCategoryStruct fromSerializableMap(Map<String, dynamic> data) =>
      ServiceCategoryStruct(
        id: deserializeParam(
          data['id'],
          ParamType.int,
          false,
        ),
        name: deserializeParam(
          data['name'],
          ParamType.String,
          false,
        ),
        slug: deserializeParam(
          data['slug'],
          ParamType.String,
          false,
        ),
        imageUrl: deserializeParam(
          data['imageUrl'],
          ParamType.String,
          false,
        ),
        videoUrl: deserializeParam(
          data['videoUrl'],
          ParamType.String,
          false,
        ),
        rating: deserializeParam(
          data['rating'],
          ParamType.double,
          false,
        ),
        bookingsCount: deserializeParam(
          data['bookingsCount'],
          ParamType.String,
          false,
        ),
        packageHeader: deserializeParam(
          data['package_header'],
          ParamType.String,
          false,
        ),
        miniHeader: deserializeParam(
          data['mini_header'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'ServiceCategoryStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is ServiceCategoryStruct &&
        id == other.id &&
        name == other.name &&
        slug == other.slug &&
        imageUrl == other.imageUrl &&
        videoUrl == other.videoUrl &&
        rating == other.rating &&
        bookingsCount == other.bookingsCount &&
        packageHeader == other.packageHeader &&
        miniHeader == other.miniHeader;
  }

  @override
  int get hashCode => const ListEquality().hash([
        id,
        name,
        slug,
        imageUrl,
        videoUrl,
        rating,
        bookingsCount,
        packageHeader,
        miniHeader
      ]);
}

ServiceCategoryStruct createServiceCategoryStruct({
  int? id,
  String? name,
  String? slug,
  String? imageUrl,
  String? videoUrl,
  double? rating,
  String? bookingsCount,
  String? packageHeader,
  String? miniHeader,
}) =>
    ServiceCategoryStruct(
      id: id,
      name: name,
      slug: slug,
      imageUrl: imageUrl,
      videoUrl: videoUrl,
      rating: rating,
      bookingsCount: bookingsCount,
      packageHeader: packageHeader,
      miniHeader: miniHeader,
    );
