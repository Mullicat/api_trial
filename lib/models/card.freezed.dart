// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'card.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TCGCard {

 String get id; String get gameCode; String get name; String get gameType; String? get version; String? get setName; String? get rarity; String? get imageRefSmall; String? get imageRefLarge; List<double>? get imageEmbedding; List<double>? get textEmbedding; Map<String, dynamic>? get gameSpecificData;
/// Create a copy of TCGCard
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TCGCardCopyWith<TCGCard> get copyWith => _$TCGCardCopyWithImpl<TCGCard>(this as TCGCard, _$identity);

  /// Serializes this TCGCard to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TCGCard&&(identical(other.id, id) || other.id == id)&&(identical(other.gameCode, gameCode) || other.gameCode == gameCode)&&(identical(other.name, name) || other.name == name)&&(identical(other.gameType, gameType) || other.gameType == gameType)&&(identical(other.version, version) || other.version == version)&&(identical(other.setName, setName) || other.setName == setName)&&(identical(other.rarity, rarity) || other.rarity == rarity)&&(identical(other.imageRefSmall, imageRefSmall) || other.imageRefSmall == imageRefSmall)&&(identical(other.imageRefLarge, imageRefLarge) || other.imageRefLarge == imageRefLarge)&&const DeepCollectionEquality().equals(other.imageEmbedding, imageEmbedding)&&const DeepCollectionEquality().equals(other.textEmbedding, textEmbedding)&&const DeepCollectionEquality().equals(other.gameSpecificData, gameSpecificData));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,gameCode,name,gameType,version,setName,rarity,imageRefSmall,imageRefLarge,const DeepCollectionEquality().hash(imageEmbedding),const DeepCollectionEquality().hash(textEmbedding),const DeepCollectionEquality().hash(gameSpecificData));

@override
String toString() {
  return 'TCGCard(id: $id, gameCode: $gameCode, name: $name, gameType: $gameType, version: $version, setName: $setName, rarity: $rarity, imageRefSmall: $imageRefSmall, imageRefLarge: $imageRefLarge, imageEmbedding: $imageEmbedding, textEmbedding: $textEmbedding, gameSpecificData: $gameSpecificData)';
}


}

/// @nodoc
abstract mixin class $TCGCardCopyWith<$Res>  {
  factory $TCGCardCopyWith(TCGCard value, $Res Function(TCGCard) _then) = _$TCGCardCopyWithImpl;
@useResult
$Res call({
 String id, String gameCode, String name, String gameType, String? version, String? setName, String? rarity, String? imageRefSmall, String? imageRefLarge, List<double>? imageEmbedding, List<double>? textEmbedding, Map<String, dynamic>? gameSpecificData
});




}
/// @nodoc
class _$TCGCardCopyWithImpl<$Res>
    implements $TCGCardCopyWith<$Res> {
  _$TCGCardCopyWithImpl(this._self, this._then);

  final TCGCard _self;
  final $Res Function(TCGCard) _then;

/// Create a copy of TCGCard
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? gameCode = null,Object? name = null,Object? gameType = null,Object? version = freezed,Object? setName = freezed,Object? rarity = freezed,Object? imageRefSmall = freezed,Object? imageRefLarge = freezed,Object? imageEmbedding = freezed,Object? textEmbedding = freezed,Object? gameSpecificData = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,gameCode: null == gameCode ? _self.gameCode : gameCode // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,gameType: null == gameType ? _self.gameType : gameType // ignore: cast_nullable_to_non_nullable
as String,version: freezed == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String?,setName: freezed == setName ? _self.setName : setName // ignore: cast_nullable_to_non_nullable
as String?,rarity: freezed == rarity ? _self.rarity : rarity // ignore: cast_nullable_to_non_nullable
as String?,imageRefSmall: freezed == imageRefSmall ? _self.imageRefSmall : imageRefSmall // ignore: cast_nullable_to_non_nullable
as String?,imageRefLarge: freezed == imageRefLarge ? _self.imageRefLarge : imageRefLarge // ignore: cast_nullable_to_non_nullable
as String?,imageEmbedding: freezed == imageEmbedding ? _self.imageEmbedding : imageEmbedding // ignore: cast_nullable_to_non_nullable
as List<double>?,textEmbedding: freezed == textEmbedding ? _self.textEmbedding : textEmbedding // ignore: cast_nullable_to_non_nullable
as List<double>?,gameSpecificData: freezed == gameSpecificData ? _self.gameSpecificData : gameSpecificData // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

}


/// Adds pattern-matching-related methods to [TCGCard].
extension TCGCardPatterns on TCGCard {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TCGCard value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TCGCard() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TCGCard value)  $default,){
final _that = this;
switch (_that) {
case _TCGCard():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TCGCard value)?  $default,){
final _that = this;
switch (_that) {
case _TCGCard() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String gameCode,  String name,  String gameType,  String? version,  String? setName,  String? rarity,  String? imageRefSmall,  String? imageRefLarge,  List<double>? imageEmbedding,  List<double>? textEmbedding,  Map<String, dynamic>? gameSpecificData)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TCGCard() when $default != null:
return $default(_that.id,_that.gameCode,_that.name,_that.gameType,_that.version,_that.setName,_that.rarity,_that.imageRefSmall,_that.imageRefLarge,_that.imageEmbedding,_that.textEmbedding,_that.gameSpecificData);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String gameCode,  String name,  String gameType,  String? version,  String? setName,  String? rarity,  String? imageRefSmall,  String? imageRefLarge,  List<double>? imageEmbedding,  List<double>? textEmbedding,  Map<String, dynamic>? gameSpecificData)  $default,) {final _that = this;
switch (_that) {
case _TCGCard():
return $default(_that.id,_that.gameCode,_that.name,_that.gameType,_that.version,_that.setName,_that.rarity,_that.imageRefSmall,_that.imageRefLarge,_that.imageEmbedding,_that.textEmbedding,_that.gameSpecificData);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String gameCode,  String name,  String gameType,  String? version,  String? setName,  String? rarity,  String? imageRefSmall,  String? imageRefLarge,  List<double>? imageEmbedding,  List<double>? textEmbedding,  Map<String, dynamic>? gameSpecificData)?  $default,) {final _that = this;
switch (_that) {
case _TCGCard() when $default != null:
return $default(_that.id,_that.gameCode,_that.name,_that.gameType,_that.version,_that.setName,_that.rarity,_that.imageRefSmall,_that.imageRefLarge,_that.imageEmbedding,_that.textEmbedding,_that.gameSpecificData);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TCGCard implements TCGCard {
   _TCGCard({required this.id, required this.gameCode, required this.name, required this.gameType, this.version, this.setName, this.rarity, this.imageRefSmall, this.imageRefLarge, final  List<double>? imageEmbedding, final  List<double>? textEmbedding, final  Map<String, dynamic>? gameSpecificData}): _imageEmbedding = imageEmbedding,_textEmbedding = textEmbedding,_gameSpecificData = gameSpecificData;
  factory _TCGCard.fromJson(Map<String, dynamic> json) => _$TCGCardFromJson(json);

@override final  String id;
@override final  String gameCode;
@override final  String name;
@override final  String gameType;
@override final  String? version;
@override final  String? setName;
@override final  String? rarity;
@override final  String? imageRefSmall;
@override final  String? imageRefLarge;
 final  List<double>? _imageEmbedding;
@override List<double>? get imageEmbedding {
  final value = _imageEmbedding;
  if (value == null) return null;
  if (_imageEmbedding is EqualUnmodifiableListView) return _imageEmbedding;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<double>? _textEmbedding;
@override List<double>? get textEmbedding {
  final value = _textEmbedding;
  if (value == null) return null;
  if (_textEmbedding is EqualUnmodifiableListView) return _textEmbedding;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  Map<String, dynamic>? _gameSpecificData;
@override Map<String, dynamic>? get gameSpecificData {
  final value = _gameSpecificData;
  if (value == null) return null;
  if (_gameSpecificData is EqualUnmodifiableMapView) return _gameSpecificData;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of TCGCard
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TCGCardCopyWith<_TCGCard> get copyWith => __$TCGCardCopyWithImpl<_TCGCard>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TCGCardToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TCGCard&&(identical(other.id, id) || other.id == id)&&(identical(other.gameCode, gameCode) || other.gameCode == gameCode)&&(identical(other.name, name) || other.name == name)&&(identical(other.gameType, gameType) || other.gameType == gameType)&&(identical(other.version, version) || other.version == version)&&(identical(other.setName, setName) || other.setName == setName)&&(identical(other.rarity, rarity) || other.rarity == rarity)&&(identical(other.imageRefSmall, imageRefSmall) || other.imageRefSmall == imageRefSmall)&&(identical(other.imageRefLarge, imageRefLarge) || other.imageRefLarge == imageRefLarge)&&const DeepCollectionEquality().equals(other._imageEmbedding, _imageEmbedding)&&const DeepCollectionEquality().equals(other._textEmbedding, _textEmbedding)&&const DeepCollectionEquality().equals(other._gameSpecificData, _gameSpecificData));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,gameCode,name,gameType,version,setName,rarity,imageRefSmall,imageRefLarge,const DeepCollectionEquality().hash(_imageEmbedding),const DeepCollectionEquality().hash(_textEmbedding),const DeepCollectionEquality().hash(_gameSpecificData));

@override
String toString() {
  return 'TCGCard(id: $id, gameCode: $gameCode, name: $name, gameType: $gameType, version: $version, setName: $setName, rarity: $rarity, imageRefSmall: $imageRefSmall, imageRefLarge: $imageRefLarge, imageEmbedding: $imageEmbedding, textEmbedding: $textEmbedding, gameSpecificData: $gameSpecificData)';
}


}

/// @nodoc
abstract mixin class _$TCGCardCopyWith<$Res> implements $TCGCardCopyWith<$Res> {
  factory _$TCGCardCopyWith(_TCGCard value, $Res Function(_TCGCard) _then) = __$TCGCardCopyWithImpl;
@override @useResult
$Res call({
 String id, String gameCode, String name, String gameType, String? version, String? setName, String? rarity, String? imageRefSmall, String? imageRefLarge, List<double>? imageEmbedding, List<double>? textEmbedding, Map<String, dynamic>? gameSpecificData
});




}
/// @nodoc
class __$TCGCardCopyWithImpl<$Res>
    implements _$TCGCardCopyWith<$Res> {
  __$TCGCardCopyWithImpl(this._self, this._then);

  final _TCGCard _self;
  final $Res Function(_TCGCard) _then;

/// Create a copy of TCGCard
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? gameCode = null,Object? name = null,Object? gameType = null,Object? version = freezed,Object? setName = freezed,Object? rarity = freezed,Object? imageRefSmall = freezed,Object? imageRefLarge = freezed,Object? imageEmbedding = freezed,Object? textEmbedding = freezed,Object? gameSpecificData = freezed,}) {
  return _then(_TCGCard(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,gameCode: null == gameCode ? _self.gameCode : gameCode // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,gameType: null == gameType ? _self.gameType : gameType // ignore: cast_nullable_to_non_nullable
as String,version: freezed == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String?,setName: freezed == setName ? _self.setName : setName // ignore: cast_nullable_to_non_nullable
as String?,rarity: freezed == rarity ? _self.rarity : rarity // ignore: cast_nullable_to_non_nullable
as String?,imageRefSmall: freezed == imageRefSmall ? _self.imageRefSmall : imageRefSmall // ignore: cast_nullable_to_non_nullable
as String?,imageRefLarge: freezed == imageRefLarge ? _self.imageRefLarge : imageRefLarge // ignore: cast_nullable_to_non_nullable
as String?,imageEmbedding: freezed == imageEmbedding ? _self._imageEmbedding : imageEmbedding // ignore: cast_nullable_to_non_nullable
as List<double>?,textEmbedding: freezed == textEmbedding ? _self._textEmbedding : textEmbedding // ignore: cast_nullable_to_non_nullable
as List<double>?,gameSpecificData: freezed == gameSpecificData ? _self._gameSpecificData : gameSpecificData // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}

// dart format on
