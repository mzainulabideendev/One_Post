// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'publishing_batch.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MediaAsset {

 String get id; String get name; String get uri; MediaType get mediaType; bool get isUploaded;
/// Create a copy of MediaAsset
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MediaAssetCopyWith<MediaAsset> get copyWith => _$MediaAssetCopyWithImpl<MediaAsset>(this as MediaAsset, _$identity);

  /// Serializes this MediaAsset to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MediaAsset;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MediaAsset&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.uri, _this.uri) || other.uri == _this.uri)&&(identical(other.mediaType, _this.mediaType) || other.mediaType == _this.mediaType)&&(identical(other.isUploaded, _this.isUploaded) || other.isUploaded == _this.isUploaded));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MediaAsset;
  return Object.hash(runtimeType,_this.id,_this.name,_this.uri,_this.mediaType,_this.isUploaded);
}

@override
String toString() {
  final _this = this as MediaAsset;
  return 'MediaAsset(id: ${_this.id}, name: ${_this.name}, uri: ${_this.uri}, mediaType: ${_this.mediaType}, isUploaded: ${_this.isUploaded})';
}


}

/// @nodoc
abstract mixin class $MediaAssetCopyWith<$Res>  {
  factory $MediaAssetCopyWith(MediaAsset value, $Res Function(MediaAsset) _then) = _$MediaAssetCopyWithImpl;
@useResult
$Res call({
 String id, String name, String uri, MediaType mediaType, bool isUploaded
});




}
/// @nodoc
class _$MediaAssetCopyWithImpl<$Res>
    implements $MediaAssetCopyWith<$Res> {
  _$MediaAssetCopyWithImpl(this._self, this._then);

  final MediaAsset _self;
  final $Res Function(MediaAsset) _then;

/// Create a copy of MediaAsset
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? uri = null,Object? mediaType = null,Object? isUploaded = null,}) {
  return _then(MediaAsset(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,uri: null == uri ? _self.uri : uri // ignore: cast_nullable_to_non_nullable
as String,mediaType: null == mediaType ? _self.mediaType : mediaType // ignore: cast_nullable_to_non_nullable
as MediaType,isUploaded: null == isUploaded ? _self.isUploaded : isUploaded // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [MediaAsset].
extension MediaAssetPatterns on MediaAsset {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MediaAsset value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MediaAsset() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MediaAsset value)  $default,){
final _that = this;
switch (_that) {
case _MediaAsset():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MediaAsset value)?  $default,){
final _that = this;
switch (_that) {
case _MediaAsset() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String uri,  MediaType mediaType,  bool isUploaded)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MediaAsset() when $default != null:
return $default(_that.id,_that.name,_that.uri,_that.mediaType,_that.isUploaded);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String uri,  MediaType mediaType,  bool isUploaded)  $default,) {final _that = this;
switch (_that) {
case _MediaAsset():
return $default(_that.id,_that.name,_that.uri,_that.mediaType,_that.isUploaded);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String uri,  MediaType mediaType,  bool isUploaded)?  $default,) {final _that = this;
switch (_that) {
case _MediaAsset() when $default != null:
return $default(_that.id,_that.name,_that.uri,_that.mediaType,_that.isUploaded);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MediaAsset implements MediaAsset {
  const _MediaAsset({required this.id, required this.name, required this.uri, required this.mediaType, this.isUploaded = false});
  factory _MediaAsset.fromJson(Map<String, dynamic> json) => _$MediaAssetFromJson(json);

@override final  String id;
@override final  String name;
@override final  String uri;
@override final  MediaType mediaType;
@override@JsonKey() final  bool isUploaded;

/// Create a copy of MediaAsset
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MediaAssetCopyWith<_MediaAsset> get copyWith => __$MediaAssetCopyWithImpl<_MediaAsset>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MediaAssetToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MediaAsset&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.uri, uri) || other.uri == uri)&&(identical(other.mediaType, mediaType) || other.mediaType == mediaType)&&(identical(other.isUploaded, isUploaded) || other.isUploaded == isUploaded));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,uri,mediaType,isUploaded);
}

@override
String toString() {
    return 'MediaAsset(id: $id, name: $name, uri: $uri, mediaType: $mediaType, isUploaded: $isUploaded)';
}


}

/// @nodoc
abstract mixin class _$MediaAssetCopyWith<$Res> implements $MediaAssetCopyWith<$Res> {
  factory _$MediaAssetCopyWith(_MediaAsset value, $Res Function(_MediaAsset) _then) = __$MediaAssetCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String uri, MediaType mediaType, bool isUploaded
});




}
/// @nodoc
class __$MediaAssetCopyWithImpl<$Res>
    implements _$MediaAssetCopyWith<$Res> {
  __$MediaAssetCopyWithImpl(this._self, this._then);

  final _MediaAsset _self;
  final $Res Function(_MediaAsset) _then;

/// Create a copy of MediaAsset
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? uri = null,Object? mediaType = null,Object? isUploaded = null,}) {
  return _then(_MediaAsset(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,uri: null == uri ? _self.uri : uri // ignore: cast_nullable_to_non_nullable
as String,mediaType: null == mediaType ? _self.mediaType : mediaType // ignore: cast_nullable_to_non_nullable
as MediaType,isUploaded: null == isUploaded ? _self.isUploaded : isUploaded // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$PublishingBatch {

 String get id; String get caption; List<String> get destinationIds; List<MediaAsset> get media; PublishingStatus get status; int get progress;
/// Create a copy of PublishingBatch
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PublishingBatchCopyWith<PublishingBatch> get copyWith => _$PublishingBatchCopyWithImpl<PublishingBatch>(this as PublishingBatch, _$identity);

  /// Serializes this PublishingBatch to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PublishingBatch;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PublishingBatch&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.caption, _this.caption) || other.caption == _this.caption)&&const DeepCollectionEquality().equals(other.destinationIds, _this.destinationIds)&&const DeepCollectionEquality().equals(other.media, _this.media)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.progress, _this.progress) || other.progress == _this.progress));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PublishingBatch;
  return Object.hash(runtimeType,_this.id,_this.caption,const DeepCollectionEquality().hash(_this.destinationIds),const DeepCollectionEquality().hash(_this.media),_this.status,_this.progress);
}

@override
String toString() {
  final _this = this as PublishingBatch;
  return 'PublishingBatch(id: ${_this.id}, caption: ${_this.caption}, destinationIds: ${_this.destinationIds}, media: ${_this.media}, status: ${_this.status}, progress: ${_this.progress})';
}


}

/// @nodoc
abstract mixin class $PublishingBatchCopyWith<$Res>  {
  factory $PublishingBatchCopyWith(PublishingBatch value, $Res Function(PublishingBatch) _then) = _$PublishingBatchCopyWithImpl;
@useResult
$Res call({
 String id, String caption, List<String> destinationIds, List<MediaAsset> media, PublishingStatus status, int progress
});




}
/// @nodoc
class _$PublishingBatchCopyWithImpl<$Res>
    implements $PublishingBatchCopyWith<$Res> {
  _$PublishingBatchCopyWithImpl(this._self, this._then);

  final PublishingBatch _self;
  final $Res Function(PublishingBatch) _then;

/// Create a copy of PublishingBatch
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? caption = null,Object? destinationIds = null,Object? media = null,Object? status = null,Object? progress = null,}) {
  return _then(PublishingBatch(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,caption: null == caption ? _self.caption : caption // ignore: cast_nullable_to_non_nullable
as String,destinationIds: null == destinationIds ? _self.destinationIds : destinationIds // ignore: cast_nullable_to_non_nullable
as List<String>,media: null == media ? _self.media : media // ignore: cast_nullable_to_non_nullable
as List<MediaAsset>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PublishingStatus,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PublishingBatch].
extension PublishingBatchPatterns on PublishingBatch {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PublishingBatch value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PublishingBatch() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PublishingBatch value)  $default,){
final _that = this;
switch (_that) {
case _PublishingBatch():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PublishingBatch value)?  $default,){
final _that = this;
switch (_that) {
case _PublishingBatch() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String caption,  List<String> destinationIds,  List<MediaAsset> media,  PublishingStatus status,  int progress)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PublishingBatch() when $default != null:
return $default(_that.id,_that.caption,_that.destinationIds,_that.media,_that.status,_that.progress);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String caption,  List<String> destinationIds,  List<MediaAsset> media,  PublishingStatus status,  int progress)  $default,) {final _that = this;
switch (_that) {
case _PublishingBatch():
return $default(_that.id,_that.caption,_that.destinationIds,_that.media,_that.status,_that.progress);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String caption,  List<String> destinationIds,  List<MediaAsset> media,  PublishingStatus status,  int progress)?  $default,) {final _that = this;
switch (_that) {
case _PublishingBatch() when $default != null:
return $default(_that.id,_that.caption,_that.destinationIds,_that.media,_that.status,_that.progress);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PublishingBatch implements PublishingBatch {
  const _PublishingBatch({required this.id, required this.caption,  List<String> destinationIds = const <String>[],  List<MediaAsset> media = const <MediaAsset>[], this.status = PublishingStatus.draft, this.progress = 0}): _destinationIds = destinationIds,_media = media;
  factory _PublishingBatch.fromJson(Map<String, dynamic> json) => _$PublishingBatchFromJson(json);

@override final  String id;
@override final  String caption;
 final  List<String> _destinationIds;
@override@JsonKey() List<String> get destinationIds {
  if (_destinationIds is EqualUnmodifiableListView) return _destinationIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_destinationIds);
}

 final  List<MediaAsset> _media;
@override@JsonKey() List<MediaAsset> get media {
  if (_media is EqualUnmodifiableListView) return _media;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_media);
}

@override@JsonKey() final  PublishingStatus status;
@override@JsonKey() final  int progress;

/// Create a copy of PublishingBatch
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PublishingBatchCopyWith<_PublishingBatch> get copyWith => __$PublishingBatchCopyWithImpl<_PublishingBatch>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PublishingBatchToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PublishingBatch&&(identical(other.id, id) || other.id == id)&&(identical(other.caption, caption) || other.caption == caption)&&const DeepCollectionEquality().equals(other.destinationIds, _destinationIds)&&const DeepCollectionEquality().equals(other.media, _media)&&(identical(other.status, status) || other.status == status)&&(identical(other.progress, progress) || other.progress == progress));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,caption,const DeepCollectionEquality().hash(_destinationIds),const DeepCollectionEquality().hash(_media),status,progress);
}

@override
String toString() {
    return 'PublishingBatch(id: $id, caption: $caption, destinationIds: $destinationIds, media: $media, status: $status, progress: $progress)';
}


}

/// @nodoc
abstract mixin class _$PublishingBatchCopyWith<$Res> implements $PublishingBatchCopyWith<$Res> {
  factory _$PublishingBatchCopyWith(_PublishingBatch value, $Res Function(_PublishingBatch) _then) = __$PublishingBatchCopyWithImpl;
@override @useResult
$Res call({
 String id, String caption, List<String> destinationIds, List<MediaAsset> media, PublishingStatus status, int progress
});




}
/// @nodoc
class __$PublishingBatchCopyWithImpl<$Res>
    implements _$PublishingBatchCopyWith<$Res> {
  __$PublishingBatchCopyWithImpl(this._self, this._then);

  final _PublishingBatch _self;
  final $Res Function(_PublishingBatch) _then;

/// Create a copy of PublishingBatch
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? caption = null,Object? destinationIds = null,Object? media = null,Object? status = null,Object? progress = null,}) {
  return _then(_PublishingBatch(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,caption: null == caption ? _self.caption : caption // ignore: cast_nullable_to_non_nullable
as String,destinationIds: null == destinationIds ? _self._destinationIds : destinationIds // ignore: cast_nullable_to_non_nullable
as List<String>,media: null == media ? _self._media : media // ignore: cast_nullable_to_non_nullable
as List<MediaAsset>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PublishingStatus,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
