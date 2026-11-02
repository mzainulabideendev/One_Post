// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'provider_capabilities.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProviderCapabilities {

 SocialProvider get provider; List<String> get supportedMediaTypes; int get maxCaptionLength; bool get supportsOAuth; bool get supportsVideo; Map<String, String> get restrictions;
/// Create a copy of ProviderCapabilities
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProviderCapabilitiesCopyWith<ProviderCapabilities> get copyWith => _$ProviderCapabilitiesCopyWithImpl<ProviderCapabilities>(this as ProviderCapabilities, _$identity);

  /// Serializes this ProviderCapabilities to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ProviderCapabilities;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProviderCapabilities&&(identical(other.provider, _this.provider) || other.provider == _this.provider)&&const DeepCollectionEquality().equals(other.supportedMediaTypes, _this.supportedMediaTypes)&&(identical(other.maxCaptionLength, _this.maxCaptionLength) || other.maxCaptionLength == _this.maxCaptionLength)&&(identical(other.supportsOAuth, _this.supportsOAuth) || other.supportsOAuth == _this.supportsOAuth)&&(identical(other.supportsVideo, _this.supportsVideo) || other.supportsVideo == _this.supportsVideo)&&const DeepCollectionEquality().equals(other.restrictions, _this.restrictions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ProviderCapabilities;
  return Object.hash(runtimeType,_this.provider,const DeepCollectionEquality().hash(_this.supportedMediaTypes),_this.maxCaptionLength,_this.supportsOAuth,_this.supportsVideo,const DeepCollectionEquality().hash(_this.restrictions));
}

@override
String toString() {
  final _this = this as ProviderCapabilities;
  return 'ProviderCapabilities(provider: ${_this.provider}, supportedMediaTypes: ${_this.supportedMediaTypes}, maxCaptionLength: ${_this.maxCaptionLength}, supportsOAuth: ${_this.supportsOAuth}, supportsVideo: ${_this.supportsVideo}, restrictions: ${_this.restrictions})';
}


}

/// @nodoc
abstract mixin class $ProviderCapabilitiesCopyWith<$Res>  {
  factory $ProviderCapabilitiesCopyWith(ProviderCapabilities value, $Res Function(ProviderCapabilities) _then) = _$ProviderCapabilitiesCopyWithImpl;
@useResult
$Res call({
 SocialProvider provider, List<String> supportedMediaTypes, int maxCaptionLength, bool supportsOAuth, bool supportsVideo, Map<String, String> restrictions
});




}
/// @nodoc
class _$ProviderCapabilitiesCopyWithImpl<$Res>
    implements $ProviderCapabilitiesCopyWith<$Res> {
  _$ProviderCapabilitiesCopyWithImpl(this._self, this._then);

  final ProviderCapabilities _self;
  final $Res Function(ProviderCapabilities) _then;

/// Create a copy of ProviderCapabilities
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? provider = null,Object? supportedMediaTypes = null,Object? maxCaptionLength = null,Object? supportsOAuth = null,Object? supportsVideo = null,Object? restrictions = null,}) {
  return _then(ProviderCapabilities(
provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as SocialProvider,supportedMediaTypes: null == supportedMediaTypes ? _self.supportedMediaTypes : supportedMediaTypes // ignore: cast_nullable_to_non_nullable
as List<String>,maxCaptionLength: null == maxCaptionLength ? _self.maxCaptionLength : maxCaptionLength // ignore: cast_nullable_to_non_nullable
as int,supportsOAuth: null == supportsOAuth ? _self.supportsOAuth : supportsOAuth // ignore: cast_nullable_to_non_nullable
as bool,supportsVideo: null == supportsVideo ? _self.supportsVideo : supportsVideo // ignore: cast_nullable_to_non_nullable
as bool,restrictions: null == restrictions ? _self.restrictions : restrictions // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}

}


/// Adds pattern-matching-related methods to [ProviderCapabilities].
extension ProviderCapabilitiesPatterns on ProviderCapabilities {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProviderCapabilities value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProviderCapabilities() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProviderCapabilities value)  $default,){
final _that = this;
switch (_that) {
case _ProviderCapabilities():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProviderCapabilities value)?  $default,){
final _that = this;
switch (_that) {
case _ProviderCapabilities() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( SocialProvider provider,  List<String> supportedMediaTypes,  int maxCaptionLength,  bool supportsOAuth,  bool supportsVideo,  Map<String, String> restrictions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProviderCapabilities() when $default != null:
return $default(_that.provider,_that.supportedMediaTypes,_that.maxCaptionLength,_that.supportsOAuth,_that.supportsVideo,_that.restrictions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( SocialProvider provider,  List<String> supportedMediaTypes,  int maxCaptionLength,  bool supportsOAuth,  bool supportsVideo,  Map<String, String> restrictions)  $default,) {final _that = this;
switch (_that) {
case _ProviderCapabilities():
return $default(_that.provider,_that.supportedMediaTypes,_that.maxCaptionLength,_that.supportsOAuth,_that.supportsVideo,_that.restrictions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( SocialProvider provider,  List<String> supportedMediaTypes,  int maxCaptionLength,  bool supportsOAuth,  bool supportsVideo,  Map<String, String> restrictions)?  $default,) {final _that = this;
switch (_that) {
case _ProviderCapabilities() when $default != null:
return $default(_that.provider,_that.supportedMediaTypes,_that.maxCaptionLength,_that.supportsOAuth,_that.supportsVideo,_that.restrictions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProviderCapabilities implements ProviderCapabilities {
  const _ProviderCapabilities({required this.provider,  List<String> supportedMediaTypes = const <String>[], this.maxCaptionLength = 280, this.supportsOAuth = false, this.supportsVideo = false,  Map<String, String> restrictions = const <String, String>{}}): _supportedMediaTypes = supportedMediaTypes,_restrictions = restrictions;
  factory _ProviderCapabilities.fromJson(Map<String, dynamic> json) => _$ProviderCapabilitiesFromJson(json);

@override final  SocialProvider provider;
 final  List<String> _supportedMediaTypes;
@override@JsonKey() List<String> get supportedMediaTypes {
  if (_supportedMediaTypes is EqualUnmodifiableListView) return _supportedMediaTypes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_supportedMediaTypes);
}

@override@JsonKey() final  int maxCaptionLength;
@override@JsonKey() final  bool supportsOAuth;
@override@JsonKey() final  bool supportsVideo;
 final  Map<String, String> _restrictions;
@override@JsonKey() Map<String, String> get restrictions {
  if (_restrictions is EqualUnmodifiableMapView) return _restrictions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_restrictions);
}


/// Create a copy of ProviderCapabilities
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProviderCapabilitiesCopyWith<_ProviderCapabilities> get copyWith => __$ProviderCapabilitiesCopyWithImpl<_ProviderCapabilities>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProviderCapabilitiesToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProviderCapabilities&&(identical(other.provider, provider) || other.provider == provider)&&const DeepCollectionEquality().equals(other.supportedMediaTypes, _supportedMediaTypes)&&(identical(other.maxCaptionLength, maxCaptionLength) || other.maxCaptionLength == maxCaptionLength)&&(identical(other.supportsOAuth, supportsOAuth) || other.supportsOAuth == supportsOAuth)&&(identical(other.supportsVideo, supportsVideo) || other.supportsVideo == supportsVideo)&&const DeepCollectionEquality().equals(other.restrictions, _restrictions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,provider,const DeepCollectionEquality().hash(_supportedMediaTypes),maxCaptionLength,supportsOAuth,supportsVideo,const DeepCollectionEquality().hash(_restrictions));
}

@override
String toString() {
    return 'ProviderCapabilities(provider: $provider, supportedMediaTypes: $supportedMediaTypes, maxCaptionLength: $maxCaptionLength, supportsOAuth: $supportsOAuth, supportsVideo: $supportsVideo, restrictions: $restrictions)';
}


}

/// @nodoc
abstract mixin class _$ProviderCapabilitiesCopyWith<$Res> implements $ProviderCapabilitiesCopyWith<$Res> {
  factory _$ProviderCapabilitiesCopyWith(_ProviderCapabilities value, $Res Function(_ProviderCapabilities) _then) = __$ProviderCapabilitiesCopyWithImpl;
@override @useResult
$Res call({
 SocialProvider provider, List<String> supportedMediaTypes, int maxCaptionLength, bool supportsOAuth, bool supportsVideo, Map<String, String> restrictions
});




}
/// @nodoc
class __$ProviderCapabilitiesCopyWithImpl<$Res>
    implements _$ProviderCapabilitiesCopyWith<$Res> {
  __$ProviderCapabilitiesCopyWithImpl(this._self, this._then);

  final _ProviderCapabilities _self;
  final $Res Function(_ProviderCapabilities) _then;

/// Create a copy of ProviderCapabilities
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? provider = null,Object? supportedMediaTypes = null,Object? maxCaptionLength = null,Object? supportsOAuth = null,Object? supportsVideo = null,Object? restrictions = null,}) {
  return _then(_ProviderCapabilities(
provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as SocialProvider,supportedMediaTypes: null == supportedMediaTypes ? _self._supportedMediaTypes : supportedMediaTypes // ignore: cast_nullable_to_non_nullable
as List<String>,maxCaptionLength: null == maxCaptionLength ? _self.maxCaptionLength : maxCaptionLength // ignore: cast_nullable_to_non_nullable
as int,supportsOAuth: null == supportsOAuth ? _self.supportsOAuth : supportsOAuth // ignore: cast_nullable_to_non_nullable
as bool,supportsVideo: null == supportsVideo ? _self.supportsVideo : supportsVideo // ignore: cast_nullable_to_non_nullable
as bool,restrictions: null == restrictions ? _self._restrictions : restrictions // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}


}

// dart format on
