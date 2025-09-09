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
mixin _$TCGCard implements DiagnosticableTreeMixin {

 String get id;// App-unique ID (e.g., UUID or gameType-gameCode)
 String get gameCode;// API-specific ID (e.g., 'swsh4-25', '6983839')
 String get name;// Card name (e.g., 'Charizard', 'Tornado Dragon')
 String get gameType;// e.g., 'pokemon', 'yugioh', 'magic', 'optcg', 'dragonball', 'digimon', 'unionarena', 'gundam'
 String? get setName;// e.g., 'Vivid Voltage', 'Battles of Legend'
 String? get rarity;// e.g., 'Rare', 'Mythic Rare'
 String? get imageRefSmall;// Supabase bucket path for small image (grid view)
 String? get imageRefLarge;// Supabase bucket path for large image (detail view)
 DateTime? get lastUpdated;// Timestamp of last update
 List<double>? get imageEmbedding;// pgvector embedding for image searches
 List<double>? get textEmbedding;// pgvector embedding for text searches
 Map<String, dynamic>? get gameSpecificData;
/// Create a copy of TCGCard
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TCGCardCopyWith<TCGCard> get copyWith => _$TCGCardCopyWithImpl<TCGCard>(this as TCGCard, _$identity);

  /// Serializes this TCGCard to a JSON map.
  Map<String, dynamic> toJson();

@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'TCGCard'))
    ..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('gameCode', gameCode))..add(DiagnosticsProperty('name', name))..add(DiagnosticsProperty('gameType', gameType))..add(DiagnosticsProperty('setName', setName))..add(DiagnosticsProperty('rarity', rarity))..add(DiagnosticsProperty('imageRefSmall', imageRefSmall))..add(DiagnosticsProperty('imageRefLarge', imageRefLarge))..add(DiagnosticsProperty('lastUpdated', lastUpdated))..add(DiagnosticsProperty('imageEmbedding', imageEmbedding))..add(DiagnosticsProperty('textEmbedding', textEmbedding))..add(DiagnosticsProperty('gameSpecificData', gameSpecificData));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TCGCard&&(identical(other.id, id) || other.id == id)&&(identical(other.gameCode, gameCode) || other.gameCode == gameCode)&&(identical(other.name, name) || other.name == name)&&(identical(other.gameType, gameType) || other.gameType == gameType)&&(identical(other.setName, setName) || other.setName == setName)&&(identical(other.rarity, rarity) || other.rarity == rarity)&&(identical(other.imageRefSmall, imageRefSmall) || other.imageRefSmall == imageRefSmall)&&(identical(other.imageRefLarge, imageRefLarge) || other.imageRefLarge == imageRefLarge)&&(identical(other.lastUpdated, lastUpdated) || other.lastUpdated == lastUpdated)&&const DeepCollectionEquality().equals(other.imageEmbedding, imageEmbedding)&&const DeepCollectionEquality().equals(other.textEmbedding, textEmbedding)&&const DeepCollectionEquality().equals(other.gameSpecificData, gameSpecificData));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,gameCode,name,gameType,setName,rarity,imageRefSmall,imageRefLarge,lastUpdated,const DeepCollectionEquality().hash(imageEmbedding),const DeepCollectionEquality().hash(textEmbedding),const DeepCollectionEquality().hash(gameSpecificData));

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'TCGCard(id: $id, gameCode: $gameCode, name: $name, gameType: $gameType, setName: $setName, rarity: $rarity, imageRefSmall: $imageRefSmall, imageRefLarge: $imageRefLarge, lastUpdated: $lastUpdated, imageEmbedding: $imageEmbedding, textEmbedding: $textEmbedding, gameSpecificData: $gameSpecificData)';
}


}

/// @nodoc
abstract mixin class $TCGCardCopyWith<$Res>  {
  factory $TCGCardCopyWith(TCGCard value, $Res Function(TCGCard) _then) = _$TCGCardCopyWithImpl;
@useResult
$Res call({
 String id, String gameCode, String name, String gameType, String? setName, String? rarity, String? imageRefSmall, String? imageRefLarge, DateTime? lastUpdated, List<double>? imageEmbedding, List<double>? textEmbedding, Map<String, dynamic>? gameSpecificData
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? gameCode = null,Object? name = null,Object? gameType = null,Object? setName = freezed,Object? rarity = freezed,Object? imageRefSmall = freezed,Object? imageRefLarge = freezed,Object? lastUpdated = freezed,Object? imageEmbedding = freezed,Object? textEmbedding = freezed,Object? gameSpecificData = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,gameCode: null == gameCode ? _self.gameCode : gameCode // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,gameType: null == gameType ? _self.gameType : gameType // ignore: cast_nullable_to_non_nullable
as String,setName: freezed == setName ? _self.setName : setName // ignore: cast_nullable_to_non_nullable
as String?,rarity: freezed == rarity ? _self.rarity : rarity // ignore: cast_nullable_to_non_nullable
as String?,imageRefSmall: freezed == imageRefSmall ? _self.imageRefSmall : imageRefSmall // ignore: cast_nullable_to_non_nullable
as String?,imageRefLarge: freezed == imageRefLarge ? _self.imageRefLarge : imageRefLarge // ignore: cast_nullable_to_non_nullable
as String?,lastUpdated: freezed == lastUpdated ? _self.lastUpdated : lastUpdated // ignore: cast_nullable_to_non_nullable
as DateTime?,imageEmbedding: freezed == imageEmbedding ? _self.imageEmbedding : imageEmbedding // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String gameCode,  String name,  String gameType,  String? setName,  String? rarity,  String? imageRefSmall,  String? imageRefLarge,  DateTime? lastUpdated,  List<double>? imageEmbedding,  List<double>? textEmbedding,  Map<String, dynamic>? gameSpecificData)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TCGCard() when $default != null:
return $default(_that.id,_that.gameCode,_that.name,_that.gameType,_that.setName,_that.rarity,_that.imageRefSmall,_that.imageRefLarge,_that.lastUpdated,_that.imageEmbedding,_that.textEmbedding,_that.gameSpecificData);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String gameCode,  String name,  String gameType,  String? setName,  String? rarity,  String? imageRefSmall,  String? imageRefLarge,  DateTime? lastUpdated,  List<double>? imageEmbedding,  List<double>? textEmbedding,  Map<String, dynamic>? gameSpecificData)  $default,) {final _that = this;
switch (_that) {
case _TCGCard():
return $default(_that.id,_that.gameCode,_that.name,_that.gameType,_that.setName,_that.rarity,_that.imageRefSmall,_that.imageRefLarge,_that.lastUpdated,_that.imageEmbedding,_that.textEmbedding,_that.gameSpecificData);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String gameCode,  String name,  String gameType,  String? setName,  String? rarity,  String? imageRefSmall,  String? imageRefLarge,  DateTime? lastUpdated,  List<double>? imageEmbedding,  List<double>? textEmbedding,  Map<String, dynamic>? gameSpecificData)?  $default,) {final _that = this;
switch (_that) {
case _TCGCard() when $default != null:
return $default(_that.id,_that.gameCode,_that.name,_that.gameType,_that.setName,_that.rarity,_that.imageRefSmall,_that.imageRefLarge,_that.lastUpdated,_that.imageEmbedding,_that.textEmbedding,_that.gameSpecificData);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TCGCard with DiagnosticableTreeMixin implements TCGCard {
  const _TCGCard({required this.id, required this.gameCode, required this.name, required this.gameType, this.setName, this.rarity, this.imageRefSmall, this.imageRefLarge, this.lastUpdated, final  List<double>? imageEmbedding, final  List<double>? textEmbedding, final  Map<String, dynamic>? gameSpecificData}): _imageEmbedding = imageEmbedding,_textEmbedding = textEmbedding,_gameSpecificData = gameSpecificData;
  factory _TCGCard.fromJson(Map<String, dynamic> json) => _$TCGCardFromJson(json);

@override final  String id;
// App-unique ID (e.g., UUID or gameType-gameCode)
@override final  String gameCode;
// API-specific ID (e.g., 'swsh4-25', '6983839')
@override final  String name;
// Card name (e.g., 'Charizard', 'Tornado Dragon')
@override final  String gameType;
// e.g., 'pokemon', 'yugioh', 'magic', 'optcg', 'dragonball', 'digimon', 'unionarena', 'gundam'
@override final  String? setName;
// e.g., 'Vivid Voltage', 'Battles of Legend'
@override final  String? rarity;
// e.g., 'Rare', 'Mythic Rare'
@override final  String? imageRefSmall;
// Supabase bucket path for small image (grid view)
@override final  String? imageRefLarge;
// Supabase bucket path for large image (detail view)
@override final  DateTime? lastUpdated;
// Timestamp of last update
 final  List<double>? _imageEmbedding;
// Timestamp of last update
@override List<double>? get imageEmbedding {
  final value = _imageEmbedding;
  if (value == null) return null;
  if (_imageEmbedding is EqualUnmodifiableListView) return _imageEmbedding;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

// pgvector embedding for image searches
 final  List<double>? _textEmbedding;
// pgvector embedding for image searches
@override List<double>? get textEmbedding {
  final value = _textEmbedding;
  if (value == null) return null;
  if (_textEmbedding is EqualUnmodifiableListView) return _textEmbedding;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

// pgvector embedding for text searches
 final  Map<String, dynamic>? _gameSpecificData;
// pgvector embedding for text searches
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
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'TCGCard'))
    ..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('gameCode', gameCode))..add(DiagnosticsProperty('name', name))..add(DiagnosticsProperty('gameType', gameType))..add(DiagnosticsProperty('setName', setName))..add(DiagnosticsProperty('rarity', rarity))..add(DiagnosticsProperty('imageRefSmall', imageRefSmall))..add(DiagnosticsProperty('imageRefLarge', imageRefLarge))..add(DiagnosticsProperty('lastUpdated', lastUpdated))..add(DiagnosticsProperty('imageEmbedding', imageEmbedding))..add(DiagnosticsProperty('textEmbedding', textEmbedding))..add(DiagnosticsProperty('gameSpecificData', gameSpecificData));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TCGCard&&(identical(other.id, id) || other.id == id)&&(identical(other.gameCode, gameCode) || other.gameCode == gameCode)&&(identical(other.name, name) || other.name == name)&&(identical(other.gameType, gameType) || other.gameType == gameType)&&(identical(other.setName, setName) || other.setName == setName)&&(identical(other.rarity, rarity) || other.rarity == rarity)&&(identical(other.imageRefSmall, imageRefSmall) || other.imageRefSmall == imageRefSmall)&&(identical(other.imageRefLarge, imageRefLarge) || other.imageRefLarge == imageRefLarge)&&(identical(other.lastUpdated, lastUpdated) || other.lastUpdated == lastUpdated)&&const DeepCollectionEquality().equals(other._imageEmbedding, _imageEmbedding)&&const DeepCollectionEquality().equals(other._textEmbedding, _textEmbedding)&&const DeepCollectionEquality().equals(other._gameSpecificData, _gameSpecificData));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,gameCode,name,gameType,setName,rarity,imageRefSmall,imageRefLarge,lastUpdated,const DeepCollectionEquality().hash(_imageEmbedding),const DeepCollectionEquality().hash(_textEmbedding),const DeepCollectionEquality().hash(_gameSpecificData));

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'TCGCard(id: $id, gameCode: $gameCode, name: $name, gameType: $gameType, setName: $setName, rarity: $rarity, imageRefSmall: $imageRefSmall, imageRefLarge: $imageRefLarge, lastUpdated: $lastUpdated, imageEmbedding: $imageEmbedding, textEmbedding: $textEmbedding, gameSpecificData: $gameSpecificData)';
}


}

/// @nodoc
abstract mixin class _$TCGCardCopyWith<$Res> implements $TCGCardCopyWith<$Res> {
  factory _$TCGCardCopyWith(_TCGCard value, $Res Function(_TCGCard) _then) = __$TCGCardCopyWithImpl;
@override @useResult
$Res call({
 String id, String gameCode, String name, String gameType, String? setName, String? rarity, String? imageRefSmall, String? imageRefLarge, DateTime? lastUpdated, List<double>? imageEmbedding, List<double>? textEmbedding, Map<String, dynamic>? gameSpecificData
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? gameCode = null,Object? name = null,Object? gameType = null,Object? setName = freezed,Object? rarity = freezed,Object? imageRefSmall = freezed,Object? imageRefLarge = freezed,Object? lastUpdated = freezed,Object? imageEmbedding = freezed,Object? textEmbedding = freezed,Object? gameSpecificData = freezed,}) {
  return _then(_TCGCard(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,gameCode: null == gameCode ? _self.gameCode : gameCode // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,gameType: null == gameType ? _self.gameType : gameType // ignore: cast_nullable_to_non_nullable
as String,setName: freezed == setName ? _self.setName : setName // ignore: cast_nullable_to_non_nullable
as String?,rarity: freezed == rarity ? _self.rarity : rarity // ignore: cast_nullable_to_non_nullable
as String?,imageRefSmall: freezed == imageRefSmall ? _self.imageRefSmall : imageRefSmall // ignore: cast_nullable_to_non_nullable
as String?,imageRefLarge: freezed == imageRefLarge ? _self.imageRefLarge : imageRefLarge // ignore: cast_nullable_to_non_nullable
as String?,lastUpdated: freezed == lastUpdated ? _self.lastUpdated : lastUpdated // ignore: cast_nullable_to_non_nullable
as DateTime?,imageEmbedding: freezed == imageEmbedding ? _self._imageEmbedding : imageEmbedding // ignore: cast_nullable_to_non_nullable
as List<double>?,textEmbedding: freezed == textEmbedding ? _self._textEmbedding : textEmbedding // ignore: cast_nullable_to_non_nullable
as List<double>?,gameSpecificData: freezed == gameSpecificData ? _self._gameSpecificData : gameSpecificData // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}

// dart format on
