// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'social_account.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SocialAccount {

 String get id; SocialProvider get provider; String get displayName; String get accountId; SocialAccountStatus get status; String get username; String get avatarUrl; List<String> get scopes;
/// Create a copy of SocialAccount
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SocialAccountCopyWith<SocialAccount> get copyWith => _$SocialAccountCopyWithImpl<SocialAccount>(this as SocialAccount, _$identity);

  /// Serializes this SocialAccount to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SocialAccount;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SocialAccount&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.provider, _this.provider) || other.provider == _this.provider)&&(identical(other.displayName, _this.displayName) || other.displayName == _this.displayName)&&(identical(other.accountId, _this.accountId) || other.accountId == _this.accountId)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.username, _this.username) || other.username == _this.username)&&(identical(other.avatarUrl, _this.avatarUrl) || other.avatarUrl == _this.avatarUrl)&&const DeepCollectionEquality().equals(other.scopes, _this.scopes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SocialAccount;
  return Object.hash(runtimeType,_this.id,_this.provider,_this.displayName,_this.accountId,_this.status,_this.username,_this.avatarUrl,const DeepCollectionEquality().hash(_this.scopes));
}

@override
String toString() {
  final _this = this as SocialAccount;
  return 'SocialAccount(id: ${_this.id}, provider: ${_this.provider}, displayName: ${_this.displayName}, accountId: ${_this.accountId}, status: ${_this.status}, username: ${_this.username}, avatarUrl: ${_this.avatarUrl}, scopes: ${_this.scopes})';
}


}

/// @nodoc
abstract mixin class $SocialAccountCopyWith<$Res>  {
  factory $SocialAccountCopyWith(SocialAccount value, $Res Function(SocialAccount) _then) = _$SocialAccountCopyWithImpl;
@useResult
$Res call({
 String id, SocialProvider provider, String displayName, String accountId, SocialAccountStatus status, String username, String avatarUrl, List<String> scopes
});




}
/// @nodoc
class _$SocialAccountCopyWithImpl<$Res>
    implements $SocialAccountCopyWith<$Res> {
  _$SocialAccountCopyWithImpl(this._self, this._then);

  final SocialAccount _self;
  final $Res Function(SocialAccount) _then;

/// Create a copy of SocialAccount
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? provider = null,Object? displayName = null,Object? accountId = null,Object? status = null,Object? username = null,Object? avatarUrl = null,Object? scopes = null,}) {
  return _then(SocialAccount(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as SocialProvider,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SocialAccountStatus,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: null == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String,scopes: null == scopes ? _self.scopes : scopes // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [SocialAccount].
extension SocialAccountPatterns on SocialAccount {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SocialAccount value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SocialAccount() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SocialAccount value)  $default,){
final _that = this;
switch (_that) {
case _SocialAccount():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SocialAccount value)?  $default,){
final _that = this;
switch (_that) {
case _SocialAccount() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  SocialProvider provider,  String displayName,  String accountId,  SocialAccountStatus status,  String username,  String avatarUrl,  List<String> scopes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SocialAccount() when $default != null:
return $default(_that.id,_that.provider,_that.displayName,_that.accountId,_that.status,_that.username,_that.avatarUrl,_that.scopes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  SocialProvider provider,  String displayName,  String accountId,  SocialAccountStatus status,  String username,  String avatarUrl,  List<String> scopes)  $default,) {final _that = this;
switch (_that) {
case _SocialAccount():
return $default(_that.id,_that.provider,_that.displayName,_that.accountId,_that.status,_that.username,_that.avatarUrl,_that.scopes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  SocialProvider provider,  String displayName,  String accountId,  SocialAccountStatus status,  String username,  String avatarUrl,  List<String> scopes)?  $default,) {final _that = this;
switch (_that) {
case _SocialAccount() when $default != null:
return $default(_that.id,_that.provider,_that.displayName,_that.accountId,_that.status,_that.username,_that.avatarUrl,_that.scopes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SocialAccount implements SocialAccount {
  const _SocialAccount({required this.id, required this.provider, required this.displayName, required this.accountId, this.status = SocialAccountStatus.connected, this.username = '', this.avatarUrl = '',  List<String> scopes = const <String>[]}): _scopes = scopes;
  factory _SocialAccount.fromJson(Map<String, dynamic> json) => _$SocialAccountFromJson(json);

@override final  String id;
@override final  SocialProvider provider;
@override final  String displayName;
@override final  String accountId;
@override@JsonKey() final  SocialAccountStatus status;
@override@JsonKey() final  String username;
@override@JsonKey() final  String avatarUrl;
 final  List<String> _scopes;
@override@JsonKey() List<String> get scopes {
  if (_scopes is EqualUnmodifiableListView) return _scopes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_scopes);
}


/// Create a copy of SocialAccount
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SocialAccountCopyWith<_SocialAccount> get copyWith => __$SocialAccountCopyWithImpl<_SocialAccount>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SocialAccountToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SocialAccount&&(identical(other.id, id) || other.id == id)&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.status, status) || other.status == status)&&(identical(other.username, username) || other.username == username)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&const DeepCollectionEquality().equals(other.scopes, _scopes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,provider,displayName,accountId,status,username,avatarUrl,const DeepCollectionEquality().hash(_scopes));
}

@override
String toString() {
    return 'SocialAccount(id: $id, provider: $provider, displayName: $displayName, accountId: $accountId, status: $status, username: $username, avatarUrl: $avatarUrl, scopes: $scopes)';
}


}

/// @nodoc
abstract mixin class _$SocialAccountCopyWith<$Res> implements $SocialAccountCopyWith<$Res> {
  factory _$SocialAccountCopyWith(_SocialAccount value, $Res Function(_SocialAccount) _then) = __$SocialAccountCopyWithImpl;
@override @useResult
$Res call({
 String id, SocialProvider provider, String displayName, String accountId, SocialAccountStatus status, String username, String avatarUrl, List<String> scopes
});




}
/// @nodoc
class __$SocialAccountCopyWithImpl<$Res>
    implements _$SocialAccountCopyWith<$Res> {
  __$SocialAccountCopyWithImpl(this._self, this._then);

  final _SocialAccount _self;
  final $Res Function(_SocialAccount) _then;

/// Create a copy of SocialAccount
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? provider = null,Object? displayName = null,Object? accountId = null,Object? status = null,Object? username = null,Object? avatarUrl = null,Object? scopes = null,}) {
  return _then(_SocialAccount(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as SocialProvider,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SocialAccountStatus,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: null == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String,scopes: null == scopes ? _self._scopes : scopes // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
