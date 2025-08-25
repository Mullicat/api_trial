// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'card_model_api_apitcg.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

OnePieceCard _$OnePieceCardFromJson(Map<String, dynamic> json) {
  return _OnePieceCard.fromJson(json);
}

/// @nodoc
mixin _$OnePieceCard {
  String get id => throw _privateConstructorUsedError;
  String get code => throw _privateConstructorUsedError;
  String get rarity => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  Map<String, String> get images => throw _privateConstructorUsedError;
  int get cost => throw _privateConstructorUsedError;
  Attribute? get attribute => throw _privateConstructorUsedError;
  int? get power => throw _privateConstructorUsedError;
  String get counter => throw _privateConstructorUsedError;
  String get color => throw _privateConstructorUsedError;
  String get family => throw _privateConstructorUsedError;
  String get ability => throw _privateConstructorUsedError;
  String get trigger => throw _privateConstructorUsedError;
  SetInfo get set => throw _privateConstructorUsedError;
  List<String> get notes => throw _privateConstructorUsedError;

  /// Serializes this OnePieceCard to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OnePieceCard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OnePieceCardCopyWith<OnePieceCard> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OnePieceCardCopyWith<$Res> {
  factory $OnePieceCardCopyWith(
    OnePieceCard value,
    $Res Function(OnePieceCard) then,
  ) = _$OnePieceCardCopyWithImpl<$Res, OnePieceCard>;
  @useResult
  $Res call({
    String id,
    String code,
    String rarity,
    String type,
    String name,
    Map<String, String> images,
    int cost,
    Attribute? attribute,
    int? power,
    String counter,
    String color,
    String family,
    String ability,
    String trigger,
    SetInfo set,
    List<String> notes,
  });

  $AttributeCopyWith<$Res>? get attribute;
  $SetInfoCopyWith<$Res> get set;
}

/// @nodoc
class _$OnePieceCardCopyWithImpl<$Res, $Val extends OnePieceCard>
    implements $OnePieceCardCopyWith<$Res> {
  _$OnePieceCardCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OnePieceCard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? code = null,
    Object? rarity = null,
    Object? type = null,
    Object? name = null,
    Object? images = null,
    Object? cost = null,
    Object? attribute = freezed,
    Object? power = freezed,
    Object? counter = null,
    Object? color = null,
    Object? family = null,
    Object? ability = null,
    Object? trigger = null,
    Object? set = null,
    Object? notes = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            code: null == code
                ? _value.code
                : code // ignore: cast_nullable_to_non_nullable
                      as String,
            rarity: null == rarity
                ? _value.rarity
                : rarity // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            images: null == images
                ? _value.images
                : images // ignore: cast_nullable_to_non_nullable
                      as Map<String, String>,
            cost: null == cost
                ? _value.cost
                : cost // ignore: cast_nullable_to_non_nullable
                      as int,
            attribute: freezed == attribute
                ? _value.attribute
                : attribute // ignore: cast_nullable_to_non_nullable
                      as Attribute?,
            power: freezed == power
                ? _value.power
                : power // ignore: cast_nullable_to_non_nullable
                      as int?,
            counter: null == counter
                ? _value.counter
                : counter // ignore: cast_nullable_to_non_nullable
                      as String,
            color: null == color
                ? _value.color
                : color // ignore: cast_nullable_to_non_nullable
                      as String,
            family: null == family
                ? _value.family
                : family // ignore: cast_nullable_to_non_nullable
                      as String,
            ability: null == ability
                ? _value.ability
                : ability // ignore: cast_nullable_to_non_nullable
                      as String,
            trigger: null == trigger
                ? _value.trigger
                : trigger // ignore: cast_nullable_to_non_nullable
                      as String,
            set: null == set
                ? _value.set
                : set // ignore: cast_nullable_to_non_nullable
                      as SetInfo,
            notes: null == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as List<String>,
          )
          as $Val,
    );
  }

  /// Create a copy of OnePieceCard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AttributeCopyWith<$Res>? get attribute {
    if (_value.attribute == null) {
      return null;
    }

    return $AttributeCopyWith<$Res>(_value.attribute!, (value) {
      return _then(_value.copyWith(attribute: value) as $Val);
    });
  }

  /// Create a copy of OnePieceCard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SetInfoCopyWith<$Res> get set {
    return $SetInfoCopyWith<$Res>(_value.set, (value) {
      return _then(_value.copyWith(set: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$OnePieceCardImplCopyWith<$Res>
    implements $OnePieceCardCopyWith<$Res> {
  factory _$$OnePieceCardImplCopyWith(
    _$OnePieceCardImpl value,
    $Res Function(_$OnePieceCardImpl) then,
  ) = __$$OnePieceCardImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String code,
    String rarity,
    String type,
    String name,
    Map<String, String> images,
    int cost,
    Attribute? attribute,
    int? power,
    String counter,
    String color,
    String family,
    String ability,
    String trigger,
    SetInfo set,
    List<String> notes,
  });

  @override
  $AttributeCopyWith<$Res>? get attribute;
  @override
  $SetInfoCopyWith<$Res> get set;
}

/// @nodoc
class __$$OnePieceCardImplCopyWithImpl<$Res>
    extends _$OnePieceCardCopyWithImpl<$Res, _$OnePieceCardImpl>
    implements _$$OnePieceCardImplCopyWith<$Res> {
  __$$OnePieceCardImplCopyWithImpl(
    _$OnePieceCardImpl _value,
    $Res Function(_$OnePieceCardImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OnePieceCard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? code = null,
    Object? rarity = null,
    Object? type = null,
    Object? name = null,
    Object? images = null,
    Object? cost = null,
    Object? attribute = freezed,
    Object? power = freezed,
    Object? counter = null,
    Object? color = null,
    Object? family = null,
    Object? ability = null,
    Object? trigger = null,
    Object? set = null,
    Object? notes = null,
  }) {
    return _then(
      _$OnePieceCardImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        code: null == code
            ? _value.code
            : code // ignore: cast_nullable_to_non_nullable
                  as String,
        rarity: null == rarity
            ? _value.rarity
            : rarity // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        images: null == images
            ? _value._images
            : images // ignore: cast_nullable_to_non_nullable
                  as Map<String, String>,
        cost: null == cost
            ? _value.cost
            : cost // ignore: cast_nullable_to_non_nullable
                  as int,
        attribute: freezed == attribute
            ? _value.attribute
            : attribute // ignore: cast_nullable_to_non_nullable
                  as Attribute?,
        power: freezed == power
            ? _value.power
            : power // ignore: cast_nullable_to_non_nullable
                  as int?,
        counter: null == counter
            ? _value.counter
            : counter // ignore: cast_nullable_to_non_nullable
                  as String,
        color: null == color
            ? _value.color
            : color // ignore: cast_nullable_to_non_nullable
                  as String,
        family: null == family
            ? _value.family
            : family // ignore: cast_nullable_to_non_nullable
                  as String,
        ability: null == ability
            ? _value.ability
            : ability // ignore: cast_nullable_to_non_nullable
                  as String,
        trigger: null == trigger
            ? _value.trigger
            : trigger // ignore: cast_nullable_to_non_nullable
                  as String,
        set: null == set
            ? _value.set
            : set // ignore: cast_nullable_to_non_nullable
                  as SetInfo,
        notes: null == notes
            ? _value._notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OnePieceCardImpl implements _OnePieceCard {
  const _$OnePieceCardImpl({
    required this.id,
    required this.code,
    required this.rarity,
    required this.type,
    required this.name,
    required final Map<String, String> images,
    required this.cost,
    this.attribute,
    this.power,
    required this.counter,
    required this.color,
    required this.family,
    required this.ability,
    required this.trigger,
    required this.set,
    required final List<String> notes,
  }) : _images = images,
       _notes = notes;

  factory _$OnePieceCardImpl.fromJson(Map<String, dynamic> json) =>
      _$$OnePieceCardImplFromJson(json);

  @override
  final String id;
  @override
  final String code;
  @override
  final String rarity;
  @override
  final String type;
  @override
  final String name;
  final Map<String, String> _images;
  @override
  Map<String, String> get images {
    if (_images is EqualUnmodifiableMapView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_images);
  }

  @override
  final int cost;
  @override
  final Attribute? attribute;
  @override
  final int? power;
  @override
  final String counter;
  @override
  final String color;
  @override
  final String family;
  @override
  final String ability;
  @override
  final String trigger;
  @override
  final SetInfo set;
  final List<String> _notes;
  @override
  List<String> get notes {
    if (_notes is EqualUnmodifiableListView) return _notes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_notes);
  }

  @override
  String toString() {
    return 'OnePieceCard(id: $id, code: $code, rarity: $rarity, type: $type, name: $name, images: $images, cost: $cost, attribute: $attribute, power: $power, counter: $counter, color: $color, family: $family, ability: $ability, trigger: $trigger, set: $set, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OnePieceCardImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.rarity, rarity) || other.rarity == rarity) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            (identical(other.cost, cost) || other.cost == cost) &&
            (identical(other.attribute, attribute) ||
                other.attribute == attribute) &&
            (identical(other.power, power) || other.power == power) &&
            (identical(other.counter, counter) || other.counter == counter) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.family, family) || other.family == family) &&
            (identical(other.ability, ability) || other.ability == ability) &&
            (identical(other.trigger, trigger) || other.trigger == trigger) &&
            (identical(other.set, set) || other.set == set) &&
            const DeepCollectionEquality().equals(other._notes, _notes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    code,
    rarity,
    type,
    name,
    const DeepCollectionEquality().hash(_images),
    cost,
    attribute,
    power,
    counter,
    color,
    family,
    ability,
    trigger,
    set,
    const DeepCollectionEquality().hash(_notes),
  );

  /// Create a copy of OnePieceCard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OnePieceCardImplCopyWith<_$OnePieceCardImpl> get copyWith =>
      __$$OnePieceCardImplCopyWithImpl<_$OnePieceCardImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OnePieceCardImplToJson(this);
  }
}

abstract class _OnePieceCard implements OnePieceCard {
  const factory _OnePieceCard({
    required final String id,
    required final String code,
    required final String rarity,
    required final String type,
    required final String name,
    required final Map<String, String> images,
    required final int cost,
    final Attribute? attribute,
    final int? power,
    required final String counter,
    required final String color,
    required final String family,
    required final String ability,
    required final String trigger,
    required final SetInfo set,
    required final List<String> notes,
  }) = _$OnePieceCardImpl;

  factory _OnePieceCard.fromJson(Map<String, dynamic> json) =
      _$OnePieceCardImpl.fromJson;

  @override
  String get id;
  @override
  String get code;
  @override
  String get rarity;
  @override
  String get type;
  @override
  String get name;
  @override
  Map<String, String> get images;
  @override
  int get cost;
  @override
  Attribute? get attribute;
  @override
  int? get power;
  @override
  String get counter;
  @override
  String get color;
  @override
  String get family;
  @override
  String get ability;
  @override
  String get trigger;
  @override
  SetInfo get set;
  @override
  List<String> get notes;

  /// Create a copy of OnePieceCard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OnePieceCardImplCopyWith<_$OnePieceCardImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Attribute _$AttributeFromJson(Map<String, dynamic> json) {
  return _Attribute.fromJson(json);
}

/// @nodoc
mixin _$Attribute {
  String get name => throw _privateConstructorUsedError;
  String get image => throw _privateConstructorUsedError;

  /// Serializes this Attribute to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Attribute
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AttributeCopyWith<Attribute> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AttributeCopyWith<$Res> {
  factory $AttributeCopyWith(Attribute value, $Res Function(Attribute) then) =
      _$AttributeCopyWithImpl<$Res, Attribute>;
  @useResult
  $Res call({String name, String image});
}

/// @nodoc
class _$AttributeCopyWithImpl<$Res, $Val extends Attribute>
    implements $AttributeCopyWith<$Res> {
  _$AttributeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Attribute
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? name = null, Object? image = null}) {
    return _then(
      _value.copyWith(
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            image: null == image
                ? _value.image
                : image // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AttributeImplCopyWith<$Res>
    implements $AttributeCopyWith<$Res> {
  factory _$$AttributeImplCopyWith(
    _$AttributeImpl value,
    $Res Function(_$AttributeImpl) then,
  ) = __$$AttributeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, String image});
}

/// @nodoc
class __$$AttributeImplCopyWithImpl<$Res>
    extends _$AttributeCopyWithImpl<$Res, _$AttributeImpl>
    implements _$$AttributeImplCopyWith<$Res> {
  __$$AttributeImplCopyWithImpl(
    _$AttributeImpl _value,
    $Res Function(_$AttributeImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Attribute
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? name = null, Object? image = null}) {
    return _then(
      _$AttributeImpl(
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        image: null == image
            ? _value.image
            : image // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AttributeImpl implements _Attribute {
  const _$AttributeImpl({required this.name, required this.image});

  factory _$AttributeImpl.fromJson(Map<String, dynamic> json) =>
      _$$AttributeImplFromJson(json);

  @override
  final String name;
  @override
  final String image;

  @override
  String toString() {
    return 'Attribute(name: $name, image: $image)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AttributeImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.image, image) || other.image == image));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, image);

  /// Create a copy of Attribute
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AttributeImplCopyWith<_$AttributeImpl> get copyWith =>
      __$$AttributeImplCopyWithImpl<_$AttributeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AttributeImplToJson(this);
  }
}

abstract class _Attribute implements Attribute {
  const factory _Attribute({
    required final String name,
    required final String image,
  }) = _$AttributeImpl;

  factory _Attribute.fromJson(Map<String, dynamic> json) =
      _$AttributeImpl.fromJson;

  @override
  String get name;
  @override
  String get image;

  /// Create a copy of Attribute
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AttributeImplCopyWith<_$AttributeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SetInfo _$SetInfoFromJson(Map<String, dynamic> json) {
  return _SetInfo.fromJson(json);
}

/// @nodoc
mixin _$SetInfo {
  String get name => throw _privateConstructorUsedError;
  String? get id => throw _privateConstructorUsedError;

  /// Serializes this SetInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SetInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SetInfoCopyWith<SetInfo> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SetInfoCopyWith<$Res> {
  factory $SetInfoCopyWith(SetInfo value, $Res Function(SetInfo) then) =
      _$SetInfoCopyWithImpl<$Res, SetInfo>;
  @useResult
  $Res call({String name, String? id});
}

/// @nodoc
class _$SetInfoCopyWithImpl<$Res, $Val extends SetInfo>
    implements $SetInfoCopyWith<$Res> {
  _$SetInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SetInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? name = null, Object? id = freezed}) {
    return _then(
      _value.copyWith(
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SetInfoImplCopyWith<$Res> implements $SetInfoCopyWith<$Res> {
  factory _$$SetInfoImplCopyWith(
    _$SetInfoImpl value,
    $Res Function(_$SetInfoImpl) then,
  ) = __$$SetInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, String? id});
}

/// @nodoc
class __$$SetInfoImplCopyWithImpl<$Res>
    extends _$SetInfoCopyWithImpl<$Res, _$SetInfoImpl>
    implements _$$SetInfoImplCopyWith<$Res> {
  __$$SetInfoImplCopyWithImpl(
    _$SetInfoImpl _value,
    $Res Function(_$SetInfoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SetInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? name = null, Object? id = freezed}) {
    return _then(
      _$SetInfoImpl(
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SetInfoImpl implements _SetInfo {
  const _$SetInfoImpl({required this.name, this.id});

  factory _$SetInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$SetInfoImplFromJson(json);

  @override
  final String name;
  @override
  final String? id;

  @override
  String toString() {
    return 'SetInfo(name: $name, id: $id)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SetInfoImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.id, id) || other.id == id));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, id);

  /// Create a copy of SetInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SetInfoImplCopyWith<_$SetInfoImpl> get copyWith =>
      __$$SetInfoImplCopyWithImpl<_$SetInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SetInfoImplToJson(this);
  }
}

abstract class _SetInfo implements SetInfo {
  const factory _SetInfo({required final String name, final String? id}) =
      _$SetInfoImpl;

  factory _SetInfo.fromJson(Map<String, dynamic> json) = _$SetInfoImpl.fromJson;

  @override
  String get name;
  @override
  String? get id;

  /// Create a copy of SetInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SetInfoImplCopyWith<_$SetInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PokemonCard _$PokemonCardFromJson(Map<String, dynamic> json) {
  return _PokemonCard.fromJson(json);
}

/// @nodoc
mixin _$PokemonCard {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get supertype => throw _privateConstructorUsedError;
  List<String> get subtypes => throw _privateConstructorUsedError;
  String? get level => throw _privateConstructorUsedError;
  String get hp => throw _privateConstructorUsedError;
  List<String> get types => throw _privateConstructorUsedError;
  String? get evolvesFrom => throw _privateConstructorUsedError;
  List<Ability>? get abilities => throw _privateConstructorUsedError;
  List<Attack>? get attacks => throw _privateConstructorUsedError;
  List<Weakness>? get weaknesses => throw _privateConstructorUsedError;
  List<Resistance>? get resistances => throw _privateConstructorUsedError;
  List<String>? get retreatCost => throw _privateConstructorUsedError;
  int? get convertedRetreatCost => throw _privateConstructorUsedError;
  String get number => throw _privateConstructorUsedError;
  String get artist => throw _privateConstructorUsedError;
  String get rarity => throw _privateConstructorUsedError;
  String? get flavorText => throw _privateConstructorUsedError;
  List<int>? get nationalPokedexNumbers => throw _privateConstructorUsedError;
  Map<String, String>? get legalities => throw _privateConstructorUsedError;
  Map<String, String> get images => throw _privateConstructorUsedError;

  /// Serializes this PokemonCard to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PokemonCard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PokemonCardCopyWith<PokemonCard> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PokemonCardCopyWith<$Res> {
  factory $PokemonCardCopyWith(
    PokemonCard value,
    $Res Function(PokemonCard) then,
  ) = _$PokemonCardCopyWithImpl<$Res, PokemonCard>;
  @useResult
  $Res call({
    String id,
    String name,
    String supertype,
    List<String> subtypes,
    String? level,
    String hp,
    List<String> types,
    String? evolvesFrom,
    List<Ability>? abilities,
    List<Attack>? attacks,
    List<Weakness>? weaknesses,
    List<Resistance>? resistances,
    List<String>? retreatCost,
    int? convertedRetreatCost,
    String number,
    String artist,
    String rarity,
    String? flavorText,
    List<int>? nationalPokedexNumbers,
    Map<String, String>? legalities,
    Map<String, String> images,
  });
}

/// @nodoc
class _$PokemonCardCopyWithImpl<$Res, $Val extends PokemonCard>
    implements $PokemonCardCopyWith<$Res> {
  _$PokemonCardCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PokemonCard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? supertype = null,
    Object? subtypes = null,
    Object? level = freezed,
    Object? hp = null,
    Object? types = null,
    Object? evolvesFrom = freezed,
    Object? abilities = freezed,
    Object? attacks = freezed,
    Object? weaknesses = freezed,
    Object? resistances = freezed,
    Object? retreatCost = freezed,
    Object? convertedRetreatCost = freezed,
    Object? number = null,
    Object? artist = null,
    Object? rarity = null,
    Object? flavorText = freezed,
    Object? nationalPokedexNumbers = freezed,
    Object? legalities = freezed,
    Object? images = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            supertype: null == supertype
                ? _value.supertype
                : supertype // ignore: cast_nullable_to_non_nullable
                      as String,
            subtypes: null == subtypes
                ? _value.subtypes
                : subtypes // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            level: freezed == level
                ? _value.level
                : level // ignore: cast_nullable_to_non_nullable
                      as String?,
            hp: null == hp
                ? _value.hp
                : hp // ignore: cast_nullable_to_non_nullable
                      as String,
            types: null == types
                ? _value.types
                : types // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            evolvesFrom: freezed == evolvesFrom
                ? _value.evolvesFrom
                : evolvesFrom // ignore: cast_nullable_to_non_nullable
                      as String?,
            abilities: freezed == abilities
                ? _value.abilities
                : abilities // ignore: cast_nullable_to_non_nullable
                      as List<Ability>?,
            attacks: freezed == attacks
                ? _value.attacks
                : attacks // ignore: cast_nullable_to_non_nullable
                      as List<Attack>?,
            weaknesses: freezed == weaknesses
                ? _value.weaknesses
                : weaknesses // ignore: cast_nullable_to_non_nullable
                      as List<Weakness>?,
            resistances: freezed == resistances
                ? _value.resistances
                : resistances // ignore: cast_nullable_to_non_nullable
                      as List<Resistance>?,
            retreatCost: freezed == retreatCost
                ? _value.retreatCost
                : retreatCost // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            convertedRetreatCost: freezed == convertedRetreatCost
                ? _value.convertedRetreatCost
                : convertedRetreatCost // ignore: cast_nullable_to_non_nullable
                      as int?,
            number: null == number
                ? _value.number
                : number // ignore: cast_nullable_to_non_nullable
                      as String,
            artist: null == artist
                ? _value.artist
                : artist // ignore: cast_nullable_to_non_nullable
                      as String,
            rarity: null == rarity
                ? _value.rarity
                : rarity // ignore: cast_nullable_to_non_nullable
                      as String,
            flavorText: freezed == flavorText
                ? _value.flavorText
                : flavorText // ignore: cast_nullable_to_non_nullable
                      as String?,
            nationalPokedexNumbers: freezed == nationalPokedexNumbers
                ? _value.nationalPokedexNumbers
                : nationalPokedexNumbers // ignore: cast_nullable_to_non_nullable
                      as List<int>?,
            legalities: freezed == legalities
                ? _value.legalities
                : legalities // ignore: cast_nullable_to_non_nullable
                      as Map<String, String>?,
            images: null == images
                ? _value.images
                : images // ignore: cast_nullable_to_non_nullable
                      as Map<String, String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PokemonCardImplCopyWith<$Res>
    implements $PokemonCardCopyWith<$Res> {
  factory _$$PokemonCardImplCopyWith(
    _$PokemonCardImpl value,
    $Res Function(_$PokemonCardImpl) then,
  ) = __$$PokemonCardImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String supertype,
    List<String> subtypes,
    String? level,
    String hp,
    List<String> types,
    String? evolvesFrom,
    List<Ability>? abilities,
    List<Attack>? attacks,
    List<Weakness>? weaknesses,
    List<Resistance>? resistances,
    List<String>? retreatCost,
    int? convertedRetreatCost,
    String number,
    String artist,
    String rarity,
    String? flavorText,
    List<int>? nationalPokedexNumbers,
    Map<String, String>? legalities,
    Map<String, String> images,
  });
}

/// @nodoc
class __$$PokemonCardImplCopyWithImpl<$Res>
    extends _$PokemonCardCopyWithImpl<$Res, _$PokemonCardImpl>
    implements _$$PokemonCardImplCopyWith<$Res> {
  __$$PokemonCardImplCopyWithImpl(
    _$PokemonCardImpl _value,
    $Res Function(_$PokemonCardImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PokemonCard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? supertype = null,
    Object? subtypes = null,
    Object? level = freezed,
    Object? hp = null,
    Object? types = null,
    Object? evolvesFrom = freezed,
    Object? abilities = freezed,
    Object? attacks = freezed,
    Object? weaknesses = freezed,
    Object? resistances = freezed,
    Object? retreatCost = freezed,
    Object? convertedRetreatCost = freezed,
    Object? number = null,
    Object? artist = null,
    Object? rarity = null,
    Object? flavorText = freezed,
    Object? nationalPokedexNumbers = freezed,
    Object? legalities = freezed,
    Object? images = null,
  }) {
    return _then(
      _$PokemonCardImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        supertype: null == supertype
            ? _value.supertype
            : supertype // ignore: cast_nullable_to_non_nullable
                  as String,
        subtypes: null == subtypes
            ? _value._subtypes
            : subtypes // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        level: freezed == level
            ? _value.level
            : level // ignore: cast_nullable_to_non_nullable
                  as String?,
        hp: null == hp
            ? _value.hp
            : hp // ignore: cast_nullable_to_non_nullable
                  as String,
        types: null == types
            ? _value._types
            : types // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        evolvesFrom: freezed == evolvesFrom
            ? _value.evolvesFrom
            : evolvesFrom // ignore: cast_nullable_to_non_nullable
                  as String?,
        abilities: freezed == abilities
            ? _value._abilities
            : abilities // ignore: cast_nullable_to_non_nullable
                  as List<Ability>?,
        attacks: freezed == attacks
            ? _value._attacks
            : attacks // ignore: cast_nullable_to_non_nullable
                  as List<Attack>?,
        weaknesses: freezed == weaknesses
            ? _value._weaknesses
            : weaknesses // ignore: cast_nullable_to_non_nullable
                  as List<Weakness>?,
        resistances: freezed == resistances
            ? _value._resistances
            : resistances // ignore: cast_nullable_to_non_nullable
                  as List<Resistance>?,
        retreatCost: freezed == retreatCost
            ? _value._retreatCost
            : retreatCost // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        convertedRetreatCost: freezed == convertedRetreatCost
            ? _value.convertedRetreatCost
            : convertedRetreatCost // ignore: cast_nullable_to_non_nullable
                  as int?,
        number: null == number
            ? _value.number
            : number // ignore: cast_nullable_to_non_nullable
                  as String,
        artist: null == artist
            ? _value.artist
            : artist // ignore: cast_nullable_to_non_nullable
                  as String,
        rarity: null == rarity
            ? _value.rarity
            : rarity // ignore: cast_nullable_to_non_nullable
                  as String,
        flavorText: freezed == flavorText
            ? _value.flavorText
            : flavorText // ignore: cast_nullable_to_non_nullable
                  as String?,
        nationalPokedexNumbers: freezed == nationalPokedexNumbers
            ? _value._nationalPokedexNumbers
            : nationalPokedexNumbers // ignore: cast_nullable_to_non_nullable
                  as List<int>?,
        legalities: freezed == legalities
            ? _value._legalities
            : legalities // ignore: cast_nullable_to_non_nullable
                  as Map<String, String>?,
        images: null == images
            ? _value._images
            : images // ignore: cast_nullable_to_non_nullable
                  as Map<String, String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PokemonCardImpl implements _PokemonCard {
  const _$PokemonCardImpl({
    required this.id,
    required this.name,
    required this.supertype,
    required final List<String> subtypes,
    this.level,
    required this.hp,
    required final List<String> types,
    this.evolvesFrom,
    final List<Ability>? abilities,
    final List<Attack>? attacks,
    final List<Weakness>? weaknesses,
    final List<Resistance>? resistances,
    final List<String>? retreatCost,
    this.convertedRetreatCost,
    required this.number,
    required this.artist,
    required this.rarity,
    this.flavorText,
    final List<int>? nationalPokedexNumbers,
    final Map<String, String>? legalities,
    required final Map<String, String> images,
  }) : _subtypes = subtypes,
       _types = types,
       _abilities = abilities,
       _attacks = attacks,
       _weaknesses = weaknesses,
       _resistances = resistances,
       _retreatCost = retreatCost,
       _nationalPokedexNumbers = nationalPokedexNumbers,
       _legalities = legalities,
       _images = images;

  factory _$PokemonCardImpl.fromJson(Map<String, dynamic> json) =>
      _$$PokemonCardImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String supertype;
  final List<String> _subtypes;
  @override
  List<String> get subtypes {
    if (_subtypes is EqualUnmodifiableListView) return _subtypes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_subtypes);
  }

  @override
  final String? level;
  @override
  final String hp;
  final List<String> _types;
  @override
  List<String> get types {
    if (_types is EqualUnmodifiableListView) return _types;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_types);
  }

  @override
  final String? evolvesFrom;
  final List<Ability>? _abilities;
  @override
  List<Ability>? get abilities {
    final value = _abilities;
    if (value == null) return null;
    if (_abilities is EqualUnmodifiableListView) return _abilities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<Attack>? _attacks;
  @override
  List<Attack>? get attacks {
    final value = _attacks;
    if (value == null) return null;
    if (_attacks is EqualUnmodifiableListView) return _attacks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<Weakness>? _weaknesses;
  @override
  List<Weakness>? get weaknesses {
    final value = _weaknesses;
    if (value == null) return null;
    if (_weaknesses is EqualUnmodifiableListView) return _weaknesses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<Resistance>? _resistances;
  @override
  List<Resistance>? get resistances {
    final value = _resistances;
    if (value == null) return null;
    if (_resistances is EqualUnmodifiableListView) return _resistances;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _retreatCost;
  @override
  List<String>? get retreatCost {
    final value = _retreatCost;
    if (value == null) return null;
    if (_retreatCost is EqualUnmodifiableListView) return _retreatCost;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final int? convertedRetreatCost;
  @override
  final String number;
  @override
  final String artist;
  @override
  final String rarity;
  @override
  final String? flavorText;
  final List<int>? _nationalPokedexNumbers;
  @override
  List<int>? get nationalPokedexNumbers {
    final value = _nationalPokedexNumbers;
    if (value == null) return null;
    if (_nationalPokedexNumbers is EqualUnmodifiableListView)
      return _nationalPokedexNumbers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final Map<String, String>? _legalities;
  @override
  Map<String, String>? get legalities {
    final value = _legalities;
    if (value == null) return null;
    if (_legalities is EqualUnmodifiableMapView) return _legalities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, String> _images;
  @override
  Map<String, String> get images {
    if (_images is EqualUnmodifiableMapView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_images);
  }

  @override
  String toString() {
    return 'PokemonCard(id: $id, name: $name, supertype: $supertype, subtypes: $subtypes, level: $level, hp: $hp, types: $types, evolvesFrom: $evolvesFrom, abilities: $abilities, attacks: $attacks, weaknesses: $weaknesses, resistances: $resistances, retreatCost: $retreatCost, convertedRetreatCost: $convertedRetreatCost, number: $number, artist: $artist, rarity: $rarity, flavorText: $flavorText, nationalPokedexNumbers: $nationalPokedexNumbers, legalities: $legalities, images: $images)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PokemonCardImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.supertype, supertype) ||
                other.supertype == supertype) &&
            const DeepCollectionEquality().equals(other._subtypes, _subtypes) &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.hp, hp) || other.hp == hp) &&
            const DeepCollectionEquality().equals(other._types, _types) &&
            (identical(other.evolvesFrom, evolvesFrom) ||
                other.evolvesFrom == evolvesFrom) &&
            const DeepCollectionEquality().equals(
              other._abilities,
              _abilities,
            ) &&
            const DeepCollectionEquality().equals(other._attacks, _attacks) &&
            const DeepCollectionEquality().equals(
              other._weaknesses,
              _weaknesses,
            ) &&
            const DeepCollectionEquality().equals(
              other._resistances,
              _resistances,
            ) &&
            const DeepCollectionEquality().equals(
              other._retreatCost,
              _retreatCost,
            ) &&
            (identical(other.convertedRetreatCost, convertedRetreatCost) ||
                other.convertedRetreatCost == convertedRetreatCost) &&
            (identical(other.number, number) || other.number == number) &&
            (identical(other.artist, artist) || other.artist == artist) &&
            (identical(other.rarity, rarity) || other.rarity == rarity) &&
            (identical(other.flavorText, flavorText) ||
                other.flavorText == flavorText) &&
            const DeepCollectionEquality().equals(
              other._nationalPokedexNumbers,
              _nationalPokedexNumbers,
            ) &&
            const DeepCollectionEquality().equals(
              other._legalities,
              _legalities,
            ) &&
            const DeepCollectionEquality().equals(other._images, _images));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    name,
    supertype,
    const DeepCollectionEquality().hash(_subtypes),
    level,
    hp,
    const DeepCollectionEquality().hash(_types),
    evolvesFrom,
    const DeepCollectionEquality().hash(_abilities),
    const DeepCollectionEquality().hash(_attacks),
    const DeepCollectionEquality().hash(_weaknesses),
    const DeepCollectionEquality().hash(_resistances),
    const DeepCollectionEquality().hash(_retreatCost),
    convertedRetreatCost,
    number,
    artist,
    rarity,
    flavorText,
    const DeepCollectionEquality().hash(_nationalPokedexNumbers),
    const DeepCollectionEquality().hash(_legalities),
    const DeepCollectionEquality().hash(_images),
  ]);

  /// Create a copy of PokemonCard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PokemonCardImplCopyWith<_$PokemonCardImpl> get copyWith =>
      __$$PokemonCardImplCopyWithImpl<_$PokemonCardImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PokemonCardImplToJson(this);
  }
}

abstract class _PokemonCard implements PokemonCard {
  const factory _PokemonCard({
    required final String id,
    required final String name,
    required final String supertype,
    required final List<String> subtypes,
    final String? level,
    required final String hp,
    required final List<String> types,
    final String? evolvesFrom,
    final List<Ability>? abilities,
    final List<Attack>? attacks,
    final List<Weakness>? weaknesses,
    final List<Resistance>? resistances,
    final List<String>? retreatCost,
    final int? convertedRetreatCost,
    required final String number,
    required final String artist,
    required final String rarity,
    final String? flavorText,
    final List<int>? nationalPokedexNumbers,
    final Map<String, String>? legalities,
    required final Map<String, String> images,
  }) = _$PokemonCardImpl;

  factory _PokemonCard.fromJson(Map<String, dynamic> json) =
      _$PokemonCardImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get supertype;
  @override
  List<String> get subtypes;
  @override
  String? get level;
  @override
  String get hp;
  @override
  List<String> get types;
  @override
  String? get evolvesFrom;
  @override
  List<Ability>? get abilities;
  @override
  List<Attack>? get attacks;
  @override
  List<Weakness>? get weaknesses;
  @override
  List<Resistance>? get resistances;
  @override
  List<String>? get retreatCost;
  @override
  int? get convertedRetreatCost;
  @override
  String get number;
  @override
  String get artist;
  @override
  String get rarity;
  @override
  String? get flavorText;
  @override
  List<int>? get nationalPokedexNumbers;
  @override
  Map<String, String>? get legalities;
  @override
  Map<String, String> get images;

  /// Create a copy of PokemonCard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PokemonCardImplCopyWith<_$PokemonCardImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Ability _$AbilityFromJson(Map<String, dynamic> json) {
  return _Ability.fromJson(json);
}

/// @nodoc
mixin _$Ability {
  String get name => throw _privateConstructorUsedError;
  String get text => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;

  /// Serializes this Ability to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Ability
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AbilityCopyWith<Ability> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AbilityCopyWith<$Res> {
  factory $AbilityCopyWith(Ability value, $Res Function(Ability) then) =
      _$AbilityCopyWithImpl<$Res, Ability>;
  @useResult
  $Res call({String name, String text, String type});
}

/// @nodoc
class _$AbilityCopyWithImpl<$Res, $Val extends Ability>
    implements $AbilityCopyWith<$Res> {
  _$AbilityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Ability
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? name = null, Object? text = null, Object? type = null}) {
    return _then(
      _value.copyWith(
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            text: null == text
                ? _value.text
                : text // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AbilityImplCopyWith<$Res> implements $AbilityCopyWith<$Res> {
  factory _$$AbilityImplCopyWith(
    _$AbilityImpl value,
    $Res Function(_$AbilityImpl) then,
  ) = __$$AbilityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, String text, String type});
}

/// @nodoc
class __$$AbilityImplCopyWithImpl<$Res>
    extends _$AbilityCopyWithImpl<$Res, _$AbilityImpl>
    implements _$$AbilityImplCopyWith<$Res> {
  __$$AbilityImplCopyWithImpl(
    _$AbilityImpl _value,
    $Res Function(_$AbilityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Ability
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? name = null, Object? text = null, Object? type = null}) {
    return _then(
      _$AbilityImpl(
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        text: null == text
            ? _value.text
            : text // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AbilityImpl implements _Ability {
  const _$AbilityImpl({
    required this.name,
    required this.text,
    required this.type,
  });

  factory _$AbilityImpl.fromJson(Map<String, dynamic> json) =>
      _$$AbilityImplFromJson(json);

  @override
  final String name;
  @override
  final String text;
  @override
  final String type;

  @override
  String toString() {
    return 'Ability(name: $name, text: $text, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AbilityImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.type, type) || other.type == type));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, text, type);

  /// Create a copy of Ability
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AbilityImplCopyWith<_$AbilityImpl> get copyWith =>
      __$$AbilityImplCopyWithImpl<_$AbilityImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AbilityImplToJson(this);
  }
}

abstract class _Ability implements Ability {
  const factory _Ability({
    required final String name,
    required final String text,
    required final String type,
  }) = _$AbilityImpl;

  factory _Ability.fromJson(Map<String, dynamic> json) = _$AbilityImpl.fromJson;

  @override
  String get name;
  @override
  String get text;
  @override
  String get type;

  /// Create a copy of Ability
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AbilityImplCopyWith<_$AbilityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Attack _$AttackFromJson(Map<String, dynamic> json) {
  return _Attack.fromJson(json);
}

/// @nodoc
mixin _$Attack {
  String get name => throw _privateConstructorUsedError;
  List<String> get cost => throw _privateConstructorUsedError;
  int get convertedEnergyCost => throw _privateConstructorUsedError;
  String get damage => throw _privateConstructorUsedError;
  String get text => throw _privateConstructorUsedError;

  /// Serializes this Attack to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Attack
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AttackCopyWith<Attack> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AttackCopyWith<$Res> {
  factory $AttackCopyWith(Attack value, $Res Function(Attack) then) =
      _$AttackCopyWithImpl<$Res, Attack>;
  @useResult
  $Res call({
    String name,
    List<String> cost,
    int convertedEnergyCost,
    String damage,
    String text,
  });
}

/// @nodoc
class _$AttackCopyWithImpl<$Res, $Val extends Attack>
    implements $AttackCopyWith<$Res> {
  _$AttackCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Attack
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? cost = null,
    Object? convertedEnergyCost = null,
    Object? damage = null,
    Object? text = null,
  }) {
    return _then(
      _value.copyWith(
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            cost: null == cost
                ? _value.cost
                : cost // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            convertedEnergyCost: null == convertedEnergyCost
                ? _value.convertedEnergyCost
                : convertedEnergyCost // ignore: cast_nullable_to_non_nullable
                      as int,
            damage: null == damage
                ? _value.damage
                : damage // ignore: cast_nullable_to_non_nullable
                      as String,
            text: null == text
                ? _value.text
                : text // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AttackImplCopyWith<$Res> implements $AttackCopyWith<$Res> {
  factory _$$AttackImplCopyWith(
    _$AttackImpl value,
    $Res Function(_$AttackImpl) then,
  ) = __$$AttackImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String name,
    List<String> cost,
    int convertedEnergyCost,
    String damage,
    String text,
  });
}

/// @nodoc
class __$$AttackImplCopyWithImpl<$Res>
    extends _$AttackCopyWithImpl<$Res, _$AttackImpl>
    implements _$$AttackImplCopyWith<$Res> {
  __$$AttackImplCopyWithImpl(
    _$AttackImpl _value,
    $Res Function(_$AttackImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Attack
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? cost = null,
    Object? convertedEnergyCost = null,
    Object? damage = null,
    Object? text = null,
  }) {
    return _then(
      _$AttackImpl(
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        cost: null == cost
            ? _value._cost
            : cost // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        convertedEnergyCost: null == convertedEnergyCost
            ? _value.convertedEnergyCost
            : convertedEnergyCost // ignore: cast_nullable_to_non_nullable
                  as int,
        damage: null == damage
            ? _value.damage
            : damage // ignore: cast_nullable_to_non_nullable
                  as String,
        text: null == text
            ? _value.text
            : text // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AttackImpl implements _Attack {
  const _$AttackImpl({
    required this.name,
    required final List<String> cost,
    required this.convertedEnergyCost,
    required this.damage,
    required this.text,
  }) : _cost = cost;

  factory _$AttackImpl.fromJson(Map<String, dynamic> json) =>
      _$$AttackImplFromJson(json);

  @override
  final String name;
  final List<String> _cost;
  @override
  List<String> get cost {
    if (_cost is EqualUnmodifiableListView) return _cost;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_cost);
  }

  @override
  final int convertedEnergyCost;
  @override
  final String damage;
  @override
  final String text;

  @override
  String toString() {
    return 'Attack(name: $name, cost: $cost, convertedEnergyCost: $convertedEnergyCost, damage: $damage, text: $text)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AttackImpl &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(other._cost, _cost) &&
            (identical(other.convertedEnergyCost, convertedEnergyCost) ||
                other.convertedEnergyCost == convertedEnergyCost) &&
            (identical(other.damage, damage) || other.damage == damage) &&
            (identical(other.text, text) || other.text == text));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    name,
    const DeepCollectionEquality().hash(_cost),
    convertedEnergyCost,
    damage,
    text,
  );

  /// Create a copy of Attack
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AttackImplCopyWith<_$AttackImpl> get copyWith =>
      __$$AttackImplCopyWithImpl<_$AttackImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AttackImplToJson(this);
  }
}

abstract class _Attack implements Attack {
  const factory _Attack({
    required final String name,
    required final List<String> cost,
    required final int convertedEnergyCost,
    required final String damage,
    required final String text,
  }) = _$AttackImpl;

  factory _Attack.fromJson(Map<String, dynamic> json) = _$AttackImpl.fromJson;

  @override
  String get name;
  @override
  List<String> get cost;
  @override
  int get convertedEnergyCost;
  @override
  String get damage;
  @override
  String get text;

  /// Create a copy of Attack
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AttackImplCopyWith<_$AttackImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Weakness _$WeaknessFromJson(Map<String, dynamic> json) {
  return _Weakness.fromJson(json);
}

/// @nodoc
mixin _$Weakness {
  String get type => throw _privateConstructorUsedError;
  String get value => throw _privateConstructorUsedError;

  /// Serializes this Weakness to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Weakness
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WeaknessCopyWith<Weakness> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WeaknessCopyWith<$Res> {
  factory $WeaknessCopyWith(Weakness value, $Res Function(Weakness) then) =
      _$WeaknessCopyWithImpl<$Res, Weakness>;
  @useResult
  $Res call({String type, String value});
}

/// @nodoc
class _$WeaknessCopyWithImpl<$Res, $Val extends Weakness>
    implements $WeaknessCopyWith<$Res> {
  _$WeaknessCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Weakness
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? type = null, Object? value = null}) {
    return _then(
      _value.copyWith(
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            value: null == value
                ? _value.value
                : value // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$WeaknessImplCopyWith<$Res>
    implements $WeaknessCopyWith<$Res> {
  factory _$$WeaknessImplCopyWith(
    _$WeaknessImpl value,
    $Res Function(_$WeaknessImpl) then,
  ) = __$$WeaknessImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String type, String value});
}

/// @nodoc
class __$$WeaknessImplCopyWithImpl<$Res>
    extends _$WeaknessCopyWithImpl<$Res, _$WeaknessImpl>
    implements _$$WeaknessImplCopyWith<$Res> {
  __$$WeaknessImplCopyWithImpl(
    _$WeaknessImpl _value,
    $Res Function(_$WeaknessImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Weakness
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? type = null, Object? value = null}) {
    return _then(
      _$WeaknessImpl(
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        value: null == value
            ? _value.value
            : value // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$WeaknessImpl implements _Weakness {
  const _$WeaknessImpl({required this.type, required this.value});

  factory _$WeaknessImpl.fromJson(Map<String, dynamic> json) =>
      _$$WeaknessImplFromJson(json);

  @override
  final String type;
  @override
  final String value;

  @override
  String toString() {
    return 'Weakness(type: $type, value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WeaknessImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.value, value) || other.value == value));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, type, value);

  /// Create a copy of Weakness
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WeaknessImplCopyWith<_$WeaknessImpl> get copyWith =>
      __$$WeaknessImplCopyWithImpl<_$WeaknessImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WeaknessImplToJson(this);
  }
}

abstract class _Weakness implements Weakness {
  const factory _Weakness({
    required final String type,
    required final String value,
  }) = _$WeaknessImpl;

  factory _Weakness.fromJson(Map<String, dynamic> json) =
      _$WeaknessImpl.fromJson;

  @override
  String get type;
  @override
  String get value;

  /// Create a copy of Weakness
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WeaknessImplCopyWith<_$WeaknessImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Resistance _$ResistanceFromJson(Map<String, dynamic> json) {
  return _Resistance.fromJson(json);
}

/// @nodoc
mixin _$Resistance {
  String get type => throw _privateConstructorUsedError;
  String get value => throw _privateConstructorUsedError;

  /// Serializes this Resistance to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Resistance
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ResistanceCopyWith<Resistance> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ResistanceCopyWith<$Res> {
  factory $ResistanceCopyWith(
    Resistance value,
    $Res Function(Resistance) then,
  ) = _$ResistanceCopyWithImpl<$Res, Resistance>;
  @useResult
  $Res call({String type, String value});
}

/// @nodoc
class _$ResistanceCopyWithImpl<$Res, $Val extends Resistance>
    implements $ResistanceCopyWith<$Res> {
  _$ResistanceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Resistance
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? type = null, Object? value = null}) {
    return _then(
      _value.copyWith(
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            value: null == value
                ? _value.value
                : value // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ResistanceImplCopyWith<$Res>
    implements $ResistanceCopyWith<$Res> {
  factory _$$ResistanceImplCopyWith(
    _$ResistanceImpl value,
    $Res Function(_$ResistanceImpl) then,
  ) = __$$ResistanceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String type, String value});
}

/// @nodoc
class __$$ResistanceImplCopyWithImpl<$Res>
    extends _$ResistanceCopyWithImpl<$Res, _$ResistanceImpl>
    implements _$$ResistanceImplCopyWith<$Res> {
  __$$ResistanceImplCopyWithImpl(
    _$ResistanceImpl _value,
    $Res Function(_$ResistanceImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Resistance
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? type = null, Object? value = null}) {
    return _then(
      _$ResistanceImpl(
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        value: null == value
            ? _value.value
            : value // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ResistanceImpl implements _Resistance {
  const _$ResistanceImpl({required this.type, required this.value});

  factory _$ResistanceImpl.fromJson(Map<String, dynamic> json) =>
      _$$ResistanceImplFromJson(json);

  @override
  final String type;
  @override
  final String value;

  @override
  String toString() {
    return 'Resistance(type: $type, value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ResistanceImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.value, value) || other.value == value));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, type, value);

  /// Create a copy of Resistance
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ResistanceImplCopyWith<_$ResistanceImpl> get copyWith =>
      __$$ResistanceImplCopyWithImpl<_$ResistanceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ResistanceImplToJson(this);
  }
}

abstract class _Resistance implements Resistance {
  const factory _Resistance({
    required final String type,
    required final String value,
  }) = _$ResistanceImpl;

  factory _Resistance.fromJson(Map<String, dynamic> json) =
      _$ResistanceImpl.fromJson;

  @override
  String get type;
  @override
  String get value;

  /// Create a copy of Resistance
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ResistanceImplCopyWith<_$ResistanceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DragonBallCard _$DragonBallCardFromJson(Map<String, dynamic> json) {
  return _DragonBallCard.fromJson(json);
}

/// @nodoc
mixin _$DragonBallCard {
  String get id => throw _privateConstructorUsedError;
  String get code => throw _privateConstructorUsedError;
  String get rarity => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get color => throw _privateConstructorUsedError;
  Map<String, String> get images => throw _privateConstructorUsedError;
  String get cardType => throw _privateConstructorUsedError;
  String get cost => throw _privateConstructorUsedError;
  String get specifiedCost => throw _privateConstructorUsedError;
  String get power => throw _privateConstructorUsedError;
  String get comboPower => throw _privateConstructorUsedError;
  String get features => throw _privateConstructorUsedError;
  String get effect => throw _privateConstructorUsedError;
  String get getIt => throw _privateConstructorUsedError;
  SetInfo get set => throw _privateConstructorUsedError;

  /// Serializes this DragonBallCard to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DragonBallCard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DragonBallCardCopyWith<DragonBallCard> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DragonBallCardCopyWith<$Res> {
  factory $DragonBallCardCopyWith(
    DragonBallCard value,
    $Res Function(DragonBallCard) then,
  ) = _$DragonBallCardCopyWithImpl<$Res, DragonBallCard>;
  @useResult
  $Res call({
    String id,
    String code,
    String rarity,
    String name,
    String color,
    Map<String, String> images,
    String cardType,
    String cost,
    String specifiedCost,
    String power,
    String comboPower,
    String features,
    String effect,
    String getIt,
    SetInfo set,
  });

  $SetInfoCopyWith<$Res> get set;
}

/// @nodoc
class _$DragonBallCardCopyWithImpl<$Res, $Val extends DragonBallCard>
    implements $DragonBallCardCopyWith<$Res> {
  _$DragonBallCardCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DragonBallCard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? code = null,
    Object? rarity = null,
    Object? name = null,
    Object? color = null,
    Object? images = null,
    Object? cardType = null,
    Object? cost = null,
    Object? specifiedCost = null,
    Object? power = null,
    Object? comboPower = null,
    Object? features = null,
    Object? effect = null,
    Object? getIt = null,
    Object? set = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            code: null == code
                ? _value.code
                : code // ignore: cast_nullable_to_non_nullable
                      as String,
            rarity: null == rarity
                ? _value.rarity
                : rarity // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            color: null == color
                ? _value.color
                : color // ignore: cast_nullable_to_non_nullable
                      as String,
            images: null == images
                ? _value.images
                : images // ignore: cast_nullable_to_non_nullable
                      as Map<String, String>,
            cardType: null == cardType
                ? _value.cardType
                : cardType // ignore: cast_nullable_to_non_nullable
                      as String,
            cost: null == cost
                ? _value.cost
                : cost // ignore: cast_nullable_to_non_nullable
                      as String,
            specifiedCost: null == specifiedCost
                ? _value.specifiedCost
                : specifiedCost // ignore: cast_nullable_to_non_nullable
                      as String,
            power: null == power
                ? _value.power
                : power // ignore: cast_nullable_to_non_nullable
                      as String,
            comboPower: null == comboPower
                ? _value.comboPower
                : comboPower // ignore: cast_nullable_to_non_nullable
                      as String,
            features: null == features
                ? _value.features
                : features // ignore: cast_nullable_to_non_nullable
                      as String,
            effect: null == effect
                ? _value.effect
                : effect // ignore: cast_nullable_to_non_nullable
                      as String,
            getIt: null == getIt
                ? _value.getIt
                : getIt // ignore: cast_nullable_to_non_nullable
                      as String,
            set: null == set
                ? _value.set
                : set // ignore: cast_nullable_to_non_nullable
                      as SetInfo,
          )
          as $Val,
    );
  }

  /// Create a copy of DragonBallCard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SetInfoCopyWith<$Res> get set {
    return $SetInfoCopyWith<$Res>(_value.set, (value) {
      return _then(_value.copyWith(set: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DragonBallCardImplCopyWith<$Res>
    implements $DragonBallCardCopyWith<$Res> {
  factory _$$DragonBallCardImplCopyWith(
    _$DragonBallCardImpl value,
    $Res Function(_$DragonBallCardImpl) then,
  ) = __$$DragonBallCardImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String code,
    String rarity,
    String name,
    String color,
    Map<String, String> images,
    String cardType,
    String cost,
    String specifiedCost,
    String power,
    String comboPower,
    String features,
    String effect,
    String getIt,
    SetInfo set,
  });

  @override
  $SetInfoCopyWith<$Res> get set;
}

/// @nodoc
class __$$DragonBallCardImplCopyWithImpl<$Res>
    extends _$DragonBallCardCopyWithImpl<$Res, _$DragonBallCardImpl>
    implements _$$DragonBallCardImplCopyWith<$Res> {
  __$$DragonBallCardImplCopyWithImpl(
    _$DragonBallCardImpl _value,
    $Res Function(_$DragonBallCardImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DragonBallCard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? code = null,
    Object? rarity = null,
    Object? name = null,
    Object? color = null,
    Object? images = null,
    Object? cardType = null,
    Object? cost = null,
    Object? specifiedCost = null,
    Object? power = null,
    Object? comboPower = null,
    Object? features = null,
    Object? effect = null,
    Object? getIt = null,
    Object? set = null,
  }) {
    return _then(
      _$DragonBallCardImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        code: null == code
            ? _value.code
            : code // ignore: cast_nullable_to_non_nullable
                  as String,
        rarity: null == rarity
            ? _value.rarity
            : rarity // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        color: null == color
            ? _value.color
            : color // ignore: cast_nullable_to_non_nullable
                  as String,
        images: null == images
            ? _value._images
            : images // ignore: cast_nullable_to_non_nullable
                  as Map<String, String>,
        cardType: null == cardType
            ? _value.cardType
            : cardType // ignore: cast_nullable_to_non_nullable
                  as String,
        cost: null == cost
            ? _value.cost
            : cost // ignore: cast_nullable_to_non_nullable
                  as String,
        specifiedCost: null == specifiedCost
            ? _value.specifiedCost
            : specifiedCost // ignore: cast_nullable_to_non_nullable
                  as String,
        power: null == power
            ? _value.power
            : power // ignore: cast_nullable_to_non_nullable
                  as String,
        comboPower: null == comboPower
            ? _value.comboPower
            : comboPower // ignore: cast_nullable_to_non_nullable
                  as String,
        features: null == features
            ? _value.features
            : features // ignore: cast_nullable_to_non_nullable
                  as String,
        effect: null == effect
            ? _value.effect
            : effect // ignore: cast_nullable_to_non_nullable
                  as String,
        getIt: null == getIt
            ? _value.getIt
            : getIt // ignore: cast_nullable_to_non_nullable
                  as String,
        set: null == set
            ? _value.set
            : set // ignore: cast_nullable_to_non_nullable
                  as SetInfo,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DragonBallCardImpl implements _DragonBallCard {
  const _$DragonBallCardImpl({
    required this.id,
    required this.code,
    required this.rarity,
    required this.name,
    required this.color,
    required final Map<String, String> images,
    required this.cardType,
    required this.cost,
    required this.specifiedCost,
    required this.power,
    required this.comboPower,
    required this.features,
    required this.effect,
    required this.getIt,
    required this.set,
  }) : _images = images;

  factory _$DragonBallCardImpl.fromJson(Map<String, dynamic> json) =>
      _$$DragonBallCardImplFromJson(json);

  @override
  final String id;
  @override
  final String code;
  @override
  final String rarity;
  @override
  final String name;
  @override
  final String color;
  final Map<String, String> _images;
  @override
  Map<String, String> get images {
    if (_images is EqualUnmodifiableMapView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_images);
  }

  @override
  final String cardType;
  @override
  final String cost;
  @override
  final String specifiedCost;
  @override
  final String power;
  @override
  final String comboPower;
  @override
  final String features;
  @override
  final String effect;
  @override
  final String getIt;
  @override
  final SetInfo set;

  @override
  String toString() {
    return 'DragonBallCard(id: $id, code: $code, rarity: $rarity, name: $name, color: $color, images: $images, cardType: $cardType, cost: $cost, specifiedCost: $specifiedCost, power: $power, comboPower: $comboPower, features: $features, effect: $effect, getIt: $getIt, set: $set)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DragonBallCardImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.rarity, rarity) || other.rarity == rarity) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.color, color) || other.color == color) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            (identical(other.cardType, cardType) ||
                other.cardType == cardType) &&
            (identical(other.cost, cost) || other.cost == cost) &&
            (identical(other.specifiedCost, specifiedCost) ||
                other.specifiedCost == specifiedCost) &&
            (identical(other.power, power) || other.power == power) &&
            (identical(other.comboPower, comboPower) ||
                other.comboPower == comboPower) &&
            (identical(other.features, features) ||
                other.features == features) &&
            (identical(other.effect, effect) || other.effect == effect) &&
            (identical(other.getIt, getIt) || other.getIt == getIt) &&
            (identical(other.set, set) || other.set == set));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    code,
    rarity,
    name,
    color,
    const DeepCollectionEquality().hash(_images),
    cardType,
    cost,
    specifiedCost,
    power,
    comboPower,
    features,
    effect,
    getIt,
    set,
  );

  /// Create a copy of DragonBallCard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DragonBallCardImplCopyWith<_$DragonBallCardImpl> get copyWith =>
      __$$DragonBallCardImplCopyWithImpl<_$DragonBallCardImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DragonBallCardImplToJson(this);
  }
}

abstract class _DragonBallCard implements DragonBallCard {
  const factory _DragonBallCard({
    required final String id,
    required final String code,
    required final String rarity,
    required final String name,
    required final String color,
    required final Map<String, String> images,
    required final String cardType,
    required final String cost,
    required final String specifiedCost,
    required final String power,
    required final String comboPower,
    required final String features,
    required final String effect,
    required final String getIt,
    required final SetInfo set,
  }) = _$DragonBallCardImpl;

  factory _DragonBallCard.fromJson(Map<String, dynamic> json) =
      _$DragonBallCardImpl.fromJson;

  @override
  String get id;
  @override
  String get code;
  @override
  String get rarity;
  @override
  String get name;
  @override
  String get color;
  @override
  Map<String, String> get images;
  @override
  String get cardType;
  @override
  String get cost;
  @override
  String get specifiedCost;
  @override
  String get power;
  @override
  String get comboPower;
  @override
  String get features;
  @override
  String get effect;
  @override
  String get getIt;
  @override
  SetInfo get set;

  /// Create a copy of DragonBallCard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DragonBallCardImplCopyWith<_$DragonBallCardImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DigimonCard _$DigimonCardFromJson(Map<String, dynamic> json) {
  return _DigimonCard.fromJson(json);
}

/// @nodoc
mixin _$DigimonCard {
  String get id => throw _privateConstructorUsedError;
  String get code => throw _privateConstructorUsedError;
  String? get rarity => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get level => throw _privateConstructorUsedError;
  List<String> get colors => throw _privateConstructorUsedError;
  Map<String, String> get images => throw _privateConstructorUsedError;
  String get cardType => throw _privateConstructorUsedError;
  String? get form => throw _privateConstructorUsedError;
  String? get attribute => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String get dp => throw _privateConstructorUsedError;
  String get playCost => throw _privateConstructorUsedError;
  String get digivolveCost1 => throw _privateConstructorUsedError;
  String get digivolveCost2 => throw _privateConstructorUsedError;
  String get effect => throw _privateConstructorUsedError;
  String get inheritedEffect => throw _privateConstructorUsedError;
  String get securityEffect => throw _privateConstructorUsedError;
  String get notes => throw _privateConstructorUsedError;
  SetInfo get set => throw _privateConstructorUsedError;

  /// Serializes this DigimonCard to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DigimonCard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DigimonCardCopyWith<DigimonCard> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DigimonCardCopyWith<$Res> {
  factory $DigimonCardCopyWith(
    DigimonCard value,
    $Res Function(DigimonCard) then,
  ) = _$DigimonCardCopyWithImpl<$Res, DigimonCard>;
  @useResult
  $Res call({
    String id,
    String code,
    String? rarity,
    String name,
    String? level,
    List<String> colors,
    Map<String, String> images,
    String cardType,
    String? form,
    String? attribute,
    String type,
    String dp,
    String playCost,
    String digivolveCost1,
    String digivolveCost2,
    String effect,
    String inheritedEffect,
    String securityEffect,
    String notes,
    SetInfo set,
  });

  $SetInfoCopyWith<$Res> get set;
}

/// @nodoc
class _$DigimonCardCopyWithImpl<$Res, $Val extends DigimonCard>
    implements $DigimonCardCopyWith<$Res> {
  _$DigimonCardCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DigimonCard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? code = null,
    Object? rarity = freezed,
    Object? name = null,
    Object? level = freezed,
    Object? colors = null,
    Object? images = null,
    Object? cardType = null,
    Object? form = freezed,
    Object? attribute = freezed,
    Object? type = null,
    Object? dp = null,
    Object? playCost = null,
    Object? digivolveCost1 = null,
    Object? digivolveCost2 = null,
    Object? effect = null,
    Object? inheritedEffect = null,
    Object? securityEffect = null,
    Object? notes = null,
    Object? set = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            code: null == code
                ? _value.code
                : code // ignore: cast_nullable_to_non_nullable
                      as String,
            rarity: freezed == rarity
                ? _value.rarity
                : rarity // ignore: cast_nullable_to_non_nullable
                      as String?,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            level: freezed == level
                ? _value.level
                : level // ignore: cast_nullable_to_non_nullable
                      as String?,
            colors: null == colors
                ? _value.colors
                : colors // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            images: null == images
                ? _value.images
                : images // ignore: cast_nullable_to_non_nullable
                      as Map<String, String>,
            cardType: null == cardType
                ? _value.cardType
                : cardType // ignore: cast_nullable_to_non_nullable
                      as String,
            form: freezed == form
                ? _value.form
                : form // ignore: cast_nullable_to_non_nullable
                      as String?,
            attribute: freezed == attribute
                ? _value.attribute
                : attribute // ignore: cast_nullable_to_non_nullable
                      as String?,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            dp: null == dp
                ? _value.dp
                : dp // ignore: cast_nullable_to_non_nullable
                      as String,
            playCost: null == playCost
                ? _value.playCost
                : playCost // ignore: cast_nullable_to_non_nullable
                      as String,
            digivolveCost1: null == digivolveCost1
                ? _value.digivolveCost1
                : digivolveCost1 // ignore: cast_nullable_to_non_nullable
                      as String,
            digivolveCost2: null == digivolveCost2
                ? _value.digivolveCost2
                : digivolveCost2 // ignore: cast_nullable_to_non_nullable
                      as String,
            effect: null == effect
                ? _value.effect
                : effect // ignore: cast_nullable_to_non_nullable
                      as String,
            inheritedEffect: null == inheritedEffect
                ? _value.inheritedEffect
                : inheritedEffect // ignore: cast_nullable_to_non_nullable
                      as String,
            securityEffect: null == securityEffect
                ? _value.securityEffect
                : securityEffect // ignore: cast_nullable_to_non_nullable
                      as String,
            notes: null == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String,
            set: null == set
                ? _value.set
                : set // ignore: cast_nullable_to_non_nullable
                      as SetInfo,
          )
          as $Val,
    );
  }

  /// Create a copy of DigimonCard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SetInfoCopyWith<$Res> get set {
    return $SetInfoCopyWith<$Res>(_value.set, (value) {
      return _then(_value.copyWith(set: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DigimonCardImplCopyWith<$Res>
    implements $DigimonCardCopyWith<$Res> {
  factory _$$DigimonCardImplCopyWith(
    _$DigimonCardImpl value,
    $Res Function(_$DigimonCardImpl) then,
  ) = __$$DigimonCardImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String code,
    String? rarity,
    String name,
    String? level,
    List<String> colors,
    Map<String, String> images,
    String cardType,
    String? form,
    String? attribute,
    String type,
    String dp,
    String playCost,
    String digivolveCost1,
    String digivolveCost2,
    String effect,
    String inheritedEffect,
    String securityEffect,
    String notes,
    SetInfo set,
  });

  @override
  $SetInfoCopyWith<$Res> get set;
}

/// @nodoc
class __$$DigimonCardImplCopyWithImpl<$Res>
    extends _$DigimonCardCopyWithImpl<$Res, _$DigimonCardImpl>
    implements _$$DigimonCardImplCopyWith<$Res> {
  __$$DigimonCardImplCopyWithImpl(
    _$DigimonCardImpl _value,
    $Res Function(_$DigimonCardImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DigimonCard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? code = null,
    Object? rarity = freezed,
    Object? name = null,
    Object? level = freezed,
    Object? colors = null,
    Object? images = null,
    Object? cardType = null,
    Object? form = freezed,
    Object? attribute = freezed,
    Object? type = null,
    Object? dp = null,
    Object? playCost = null,
    Object? digivolveCost1 = null,
    Object? digivolveCost2 = null,
    Object? effect = null,
    Object? inheritedEffect = null,
    Object? securityEffect = null,
    Object? notes = null,
    Object? set = null,
  }) {
    return _then(
      _$DigimonCardImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        code: null == code
            ? _value.code
            : code // ignore: cast_nullable_to_non_nullable
                  as String,
        rarity: freezed == rarity
            ? _value.rarity
            : rarity // ignore: cast_nullable_to_non_nullable
                  as String?,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        level: freezed == level
            ? _value.level
            : level // ignore: cast_nullable_to_non_nullable
                  as String?,
        colors: null == colors
            ? _value._colors
            : colors // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        images: null == images
            ? _value._images
            : images // ignore: cast_nullable_to_non_nullable
                  as Map<String, String>,
        cardType: null == cardType
            ? _value.cardType
            : cardType // ignore: cast_nullable_to_non_nullable
                  as String,
        form: freezed == form
            ? _value.form
            : form // ignore: cast_nullable_to_non_nullable
                  as String?,
        attribute: freezed == attribute
            ? _value.attribute
            : attribute // ignore: cast_nullable_to_non_nullable
                  as String?,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        dp: null == dp
            ? _value.dp
            : dp // ignore: cast_nullable_to_non_nullable
                  as String,
        playCost: null == playCost
            ? _value.playCost
            : playCost // ignore: cast_nullable_to_non_nullable
                  as String,
        digivolveCost1: null == digivolveCost1
            ? _value.digivolveCost1
            : digivolveCost1 // ignore: cast_nullable_to_non_nullable
                  as String,
        digivolveCost2: null == digivolveCost2
            ? _value.digivolveCost2
            : digivolveCost2 // ignore: cast_nullable_to_non_nullable
                  as String,
        effect: null == effect
            ? _value.effect
            : effect // ignore: cast_nullable_to_non_nullable
                  as String,
        inheritedEffect: null == inheritedEffect
            ? _value.inheritedEffect
            : inheritedEffect // ignore: cast_nullable_to_non_nullable
                  as String,
        securityEffect: null == securityEffect
            ? _value.securityEffect
            : securityEffect // ignore: cast_nullable_to_non_nullable
                  as String,
        notes: null == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String,
        set: null == set
            ? _value.set
            : set // ignore: cast_nullable_to_non_nullable
                  as SetInfo,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DigimonCardImpl implements _DigimonCard {
  const _$DigimonCardImpl({
    required this.id,
    required this.code,
    this.rarity,
    required this.name,
    this.level,
    required final List<String> colors,
    required final Map<String, String> images,
    required this.cardType,
    this.form,
    this.attribute,
    required this.type,
    required this.dp,
    required this.playCost,
    required this.digivolveCost1,
    required this.digivolveCost2,
    required this.effect,
    required this.inheritedEffect,
    required this.securityEffect,
    required this.notes,
    required this.set,
  }) : _colors = colors,
       _images = images;

  factory _$DigimonCardImpl.fromJson(Map<String, dynamic> json) =>
      _$$DigimonCardImplFromJson(json);

  @override
  final String id;
  @override
  final String code;
  @override
  final String? rarity;
  @override
  final String name;
  @override
  final String? level;
  final List<String> _colors;
  @override
  List<String> get colors {
    if (_colors is EqualUnmodifiableListView) return _colors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_colors);
  }

  final Map<String, String> _images;
  @override
  Map<String, String> get images {
    if (_images is EqualUnmodifiableMapView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_images);
  }

  @override
  final String cardType;
  @override
  final String? form;
  @override
  final String? attribute;
  @override
  final String type;
  @override
  final String dp;
  @override
  final String playCost;
  @override
  final String digivolveCost1;
  @override
  final String digivolveCost2;
  @override
  final String effect;
  @override
  final String inheritedEffect;
  @override
  final String securityEffect;
  @override
  final String notes;
  @override
  final SetInfo set;

  @override
  String toString() {
    return 'DigimonCard(id: $id, code: $code, rarity: $rarity, name: $name, level: $level, colors: $colors, images: $images, cardType: $cardType, form: $form, attribute: $attribute, type: $type, dp: $dp, playCost: $playCost, digivolveCost1: $digivolveCost1, digivolveCost2: $digivolveCost2, effect: $effect, inheritedEffect: $inheritedEffect, securityEffect: $securityEffect, notes: $notes, set: $set)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DigimonCardImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.rarity, rarity) || other.rarity == rarity) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.level, level) || other.level == level) &&
            const DeepCollectionEquality().equals(other._colors, _colors) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            (identical(other.cardType, cardType) ||
                other.cardType == cardType) &&
            (identical(other.form, form) || other.form == form) &&
            (identical(other.attribute, attribute) ||
                other.attribute == attribute) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.dp, dp) || other.dp == dp) &&
            (identical(other.playCost, playCost) ||
                other.playCost == playCost) &&
            (identical(other.digivolveCost1, digivolveCost1) ||
                other.digivolveCost1 == digivolveCost1) &&
            (identical(other.digivolveCost2, digivolveCost2) ||
                other.digivolveCost2 == digivolveCost2) &&
            (identical(other.effect, effect) || other.effect == effect) &&
            (identical(other.inheritedEffect, inheritedEffect) ||
                other.inheritedEffect == inheritedEffect) &&
            (identical(other.securityEffect, securityEffect) ||
                other.securityEffect == securityEffect) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.set, set) || other.set == set));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    code,
    rarity,
    name,
    level,
    const DeepCollectionEquality().hash(_colors),
    const DeepCollectionEquality().hash(_images),
    cardType,
    form,
    attribute,
    type,
    dp,
    playCost,
    digivolveCost1,
    digivolveCost2,
    effect,
    inheritedEffect,
    securityEffect,
    notes,
    set,
  ]);

  /// Create a copy of DigimonCard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DigimonCardImplCopyWith<_$DigimonCardImpl> get copyWith =>
      __$$DigimonCardImplCopyWithImpl<_$DigimonCardImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DigimonCardImplToJson(this);
  }
}

abstract class _DigimonCard implements DigimonCard {
  const factory _DigimonCard({
    required final String id,
    required final String code,
    final String? rarity,
    required final String name,
    final String? level,
    required final List<String> colors,
    required final Map<String, String> images,
    required final String cardType,
    final String? form,
    final String? attribute,
    required final String type,
    required final String dp,
    required final String playCost,
    required final String digivolveCost1,
    required final String digivolveCost2,
    required final String effect,
    required final String inheritedEffect,
    required final String securityEffect,
    required final String notes,
    required final SetInfo set,
  }) = _$DigimonCardImpl;

  factory _DigimonCard.fromJson(Map<String, dynamic> json) =
      _$DigimonCardImpl.fromJson;

  @override
  String get id;
  @override
  String get code;
  @override
  String? get rarity;
  @override
  String get name;
  @override
  String? get level;
  @override
  List<String> get colors;
  @override
  Map<String, String> get images;
  @override
  String get cardType;
  @override
  String? get form;
  @override
  String? get attribute;
  @override
  String get type;
  @override
  String get dp;
  @override
  String get playCost;
  @override
  String get digivolveCost1;
  @override
  String get digivolveCost2;
  @override
  String get effect;
  @override
  String get inheritedEffect;
  @override
  String get securityEffect;
  @override
  String get notes;
  @override
  SetInfo get set;

  /// Create a copy of DigimonCard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DigimonCardImplCopyWith<_$DigimonCardImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UnionArenaCard _$UnionArenaCardFromJson(Map<String, dynamic> json) {
  return _UnionArenaCard.fromJson(json);
}

/// @nodoc
mixin _$UnionArenaCard {
  String get id => throw _privateConstructorUsedError;
  String get code => throw _privateConstructorUsedError;
  String get url => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get rarity => throw _privateConstructorUsedError;
  String get ap => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String get bp => throw _privateConstructorUsedError;
  String get affinity => throw _privateConstructorUsedError;
  String get effect => throw _privateConstructorUsedError;
  String get trigger => throw _privateConstructorUsedError;
  Map<String, String> get images => throw _privateConstructorUsedError;
  SetInfo get set => throw _privateConstructorUsedError;
  NeedEnergy? get needEnergy => throw _privateConstructorUsedError;

  /// Serializes this UnionArenaCard to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UnionArenaCard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UnionArenaCardCopyWith<UnionArenaCard> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UnionArenaCardCopyWith<$Res> {
  factory $UnionArenaCardCopyWith(
    UnionArenaCard value,
    $Res Function(UnionArenaCard) then,
  ) = _$UnionArenaCardCopyWithImpl<$Res, UnionArenaCard>;
  @useResult
  $Res call({
    String id,
    String code,
    String url,
    String name,
    String rarity,
    String ap,
    String type,
    String bp,
    String affinity,
    String effect,
    String trigger,
    Map<String, String> images,
    SetInfo set,
    NeedEnergy? needEnergy,
  });

  $SetInfoCopyWith<$Res> get set;
  $NeedEnergyCopyWith<$Res>? get needEnergy;
}

/// @nodoc
class _$UnionArenaCardCopyWithImpl<$Res, $Val extends UnionArenaCard>
    implements $UnionArenaCardCopyWith<$Res> {
  _$UnionArenaCardCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UnionArenaCard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? code = null,
    Object? url = null,
    Object? name = null,
    Object? rarity = null,
    Object? ap = null,
    Object? type = null,
    Object? bp = null,
    Object? affinity = null,
    Object? effect = null,
    Object? trigger = null,
    Object? images = null,
    Object? set = null,
    Object? needEnergy = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            code: null == code
                ? _value.code
                : code // ignore: cast_nullable_to_non_nullable
                      as String,
            url: null == url
                ? _value.url
                : url // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            rarity: null == rarity
                ? _value.rarity
                : rarity // ignore: cast_nullable_to_non_nullable
                      as String,
            ap: null == ap
                ? _value.ap
                : ap // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            bp: null == bp
                ? _value.bp
                : bp // ignore: cast_nullable_to_non_nullable
                      as String,
            affinity: null == affinity
                ? _value.affinity
                : affinity // ignore: cast_nullable_to_non_nullable
                      as String,
            effect: null == effect
                ? _value.effect
                : effect // ignore: cast_nullable_to_non_nullable
                      as String,
            trigger: null == trigger
                ? _value.trigger
                : trigger // ignore: cast_nullable_to_non_nullable
                      as String,
            images: null == images
                ? _value.images
                : images // ignore: cast_nullable_to_non_nullable
                      as Map<String, String>,
            set: null == set
                ? _value.set
                : set // ignore: cast_nullable_to_non_nullable
                      as SetInfo,
            needEnergy: freezed == needEnergy
                ? _value.needEnergy
                : needEnergy // ignore: cast_nullable_to_non_nullable
                      as NeedEnergy?,
          )
          as $Val,
    );
  }

  /// Create a copy of UnionArenaCard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SetInfoCopyWith<$Res> get set {
    return $SetInfoCopyWith<$Res>(_value.set, (value) {
      return _then(_value.copyWith(set: value) as $Val);
    });
  }

  /// Create a copy of UnionArenaCard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NeedEnergyCopyWith<$Res>? get needEnergy {
    if (_value.needEnergy == null) {
      return null;
    }

    return $NeedEnergyCopyWith<$Res>(_value.needEnergy!, (value) {
      return _then(_value.copyWith(needEnergy: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UnionArenaCardImplCopyWith<$Res>
    implements $UnionArenaCardCopyWith<$Res> {
  factory _$$UnionArenaCardImplCopyWith(
    _$UnionArenaCardImpl value,
    $Res Function(_$UnionArenaCardImpl) then,
  ) = __$$UnionArenaCardImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String code,
    String url,
    String name,
    String rarity,
    String ap,
    String type,
    String bp,
    String affinity,
    String effect,
    String trigger,
    Map<String, String> images,
    SetInfo set,
    NeedEnergy? needEnergy,
  });

  @override
  $SetInfoCopyWith<$Res> get set;
  @override
  $NeedEnergyCopyWith<$Res>? get needEnergy;
}

/// @nodoc
class __$$UnionArenaCardImplCopyWithImpl<$Res>
    extends _$UnionArenaCardCopyWithImpl<$Res, _$UnionArenaCardImpl>
    implements _$$UnionArenaCardImplCopyWith<$Res> {
  __$$UnionArenaCardImplCopyWithImpl(
    _$UnionArenaCardImpl _value,
    $Res Function(_$UnionArenaCardImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UnionArenaCard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? code = null,
    Object? url = null,
    Object? name = null,
    Object? rarity = null,
    Object? ap = null,
    Object? type = null,
    Object? bp = null,
    Object? affinity = null,
    Object? effect = null,
    Object? trigger = null,
    Object? images = null,
    Object? set = null,
    Object? needEnergy = freezed,
  }) {
    return _then(
      _$UnionArenaCardImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        code: null == code
            ? _value.code
            : code // ignore: cast_nullable_to_non_nullable
                  as String,
        url: null == url
            ? _value.url
            : url // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        rarity: null == rarity
            ? _value.rarity
            : rarity // ignore: cast_nullable_to_non_nullable
                  as String,
        ap: null == ap
            ? _value.ap
            : ap // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        bp: null == bp
            ? _value.bp
            : bp // ignore: cast_nullable_to_non_nullable
                  as String,
        affinity: null == affinity
            ? _value.affinity
            : affinity // ignore: cast_nullable_to_non_nullable
                  as String,
        effect: null == effect
            ? _value.effect
            : effect // ignore: cast_nullable_to_non_nullable
                  as String,
        trigger: null == trigger
            ? _value.trigger
            : trigger // ignore: cast_nullable_to_non_nullable
                  as String,
        images: null == images
            ? _value._images
            : images // ignore: cast_nullable_to_non_nullable
                  as Map<String, String>,
        set: null == set
            ? _value.set
            : set // ignore: cast_nullable_to_non_nullable
                  as SetInfo,
        needEnergy: freezed == needEnergy
            ? _value.needEnergy
            : needEnergy // ignore: cast_nullable_to_non_nullable
                  as NeedEnergy?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UnionArenaCardImpl implements _UnionArenaCard {
  const _$UnionArenaCardImpl({
    required this.id,
    required this.code,
    required this.url,
    required this.name,
    required this.rarity,
    required this.ap,
    required this.type,
    required this.bp,
    required this.affinity,
    required this.effect,
    required this.trigger,
    required final Map<String, String> images,
    required this.set,
    this.needEnergy,
  }) : _images = images;

  factory _$UnionArenaCardImpl.fromJson(Map<String, dynamic> json) =>
      _$$UnionArenaCardImplFromJson(json);

  @override
  final String id;
  @override
  final String code;
  @override
  final String url;
  @override
  final String name;
  @override
  final String rarity;
  @override
  final String ap;
  @override
  final String type;
  @override
  final String bp;
  @override
  final String affinity;
  @override
  final String effect;
  @override
  final String trigger;
  final Map<String, String> _images;
  @override
  Map<String, String> get images {
    if (_images is EqualUnmodifiableMapView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_images);
  }

  @override
  final SetInfo set;
  @override
  final NeedEnergy? needEnergy;

  @override
  String toString() {
    return 'UnionArenaCard(id: $id, code: $code, url: $url, name: $name, rarity: $rarity, ap: $ap, type: $type, bp: $bp, affinity: $affinity, effect: $effect, trigger: $trigger, images: $images, set: $set, needEnergy: $needEnergy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UnionArenaCardImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.rarity, rarity) || other.rarity == rarity) &&
            (identical(other.ap, ap) || other.ap == ap) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.bp, bp) || other.bp == bp) &&
            (identical(other.affinity, affinity) ||
                other.affinity == affinity) &&
            (identical(other.effect, effect) || other.effect == effect) &&
            (identical(other.trigger, trigger) || other.trigger == trigger) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            (identical(other.set, set) || other.set == set) &&
            (identical(other.needEnergy, needEnergy) ||
                other.needEnergy == needEnergy));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    code,
    url,
    name,
    rarity,
    ap,
    type,
    bp,
    affinity,
    effect,
    trigger,
    const DeepCollectionEquality().hash(_images),
    set,
    needEnergy,
  );

  /// Create a copy of UnionArenaCard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UnionArenaCardImplCopyWith<_$UnionArenaCardImpl> get copyWith =>
      __$$UnionArenaCardImplCopyWithImpl<_$UnionArenaCardImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$UnionArenaCardImplToJson(this);
  }
}

abstract class _UnionArenaCard implements UnionArenaCard {
  const factory _UnionArenaCard({
    required final String id,
    required final String code,
    required final String url,
    required final String name,
    required final String rarity,
    required final String ap,
    required final String type,
    required final String bp,
    required final String affinity,
    required final String effect,
    required final String trigger,
    required final Map<String, String> images,
    required final SetInfo set,
    final NeedEnergy? needEnergy,
  }) = _$UnionArenaCardImpl;

  factory _UnionArenaCard.fromJson(Map<String, dynamic> json) =
      _$UnionArenaCardImpl.fromJson;

  @override
  String get id;
  @override
  String get code;
  @override
  String get url;
  @override
  String get name;
  @override
  String get rarity;
  @override
  String get ap;
  @override
  String get type;
  @override
  String get bp;
  @override
  String get affinity;
  @override
  String get effect;
  @override
  String get trigger;
  @override
  Map<String, String> get images;
  @override
  SetInfo get set;
  @override
  NeedEnergy? get needEnergy;

  /// Create a copy of UnionArenaCard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UnionArenaCardImplCopyWith<_$UnionArenaCardImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

NeedEnergy _$NeedEnergyFromJson(Map<String, dynamic> json) {
  return _NeedEnergy.fromJson(json);
}

/// @nodoc
mixin _$NeedEnergy {
  String get value => throw _privateConstructorUsedError;
  String get logo => throw _privateConstructorUsedError;

  /// Serializes this NeedEnergy to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NeedEnergy
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NeedEnergyCopyWith<NeedEnergy> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NeedEnergyCopyWith<$Res> {
  factory $NeedEnergyCopyWith(
    NeedEnergy value,
    $Res Function(NeedEnergy) then,
  ) = _$NeedEnergyCopyWithImpl<$Res, NeedEnergy>;
  @useResult
  $Res call({String value, String logo});
}

/// @nodoc
class _$NeedEnergyCopyWithImpl<$Res, $Val extends NeedEnergy>
    implements $NeedEnergyCopyWith<$Res> {
  _$NeedEnergyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NeedEnergy
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? value = null, Object? logo = null}) {
    return _then(
      _value.copyWith(
            value: null == value
                ? _value.value
                : value // ignore: cast_nullable_to_non_nullable
                      as String,
            logo: null == logo
                ? _value.logo
                : logo // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$NeedEnergyImplCopyWith<$Res>
    implements $NeedEnergyCopyWith<$Res> {
  factory _$$NeedEnergyImplCopyWith(
    _$NeedEnergyImpl value,
    $Res Function(_$NeedEnergyImpl) then,
  ) = __$$NeedEnergyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String value, String logo});
}

/// @nodoc
class __$$NeedEnergyImplCopyWithImpl<$Res>
    extends _$NeedEnergyCopyWithImpl<$Res, _$NeedEnergyImpl>
    implements _$$NeedEnergyImplCopyWith<$Res> {
  __$$NeedEnergyImplCopyWithImpl(
    _$NeedEnergyImpl _value,
    $Res Function(_$NeedEnergyImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of NeedEnergy
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? value = null, Object? logo = null}) {
    return _then(
      _$NeedEnergyImpl(
        value: null == value
            ? _value.value
            : value // ignore: cast_nullable_to_non_nullable
                  as String,
        logo: null == logo
            ? _value.logo
            : logo // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$NeedEnergyImpl implements _NeedEnergy {
  const _$NeedEnergyImpl({required this.value, required this.logo});

  factory _$NeedEnergyImpl.fromJson(Map<String, dynamic> json) =>
      _$$NeedEnergyImplFromJson(json);

  @override
  final String value;
  @override
  final String logo;

  @override
  String toString() {
    return 'NeedEnergy(value: $value, logo: $logo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NeedEnergyImpl &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.logo, logo) || other.logo == logo));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, value, logo);

  /// Create a copy of NeedEnergy
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NeedEnergyImplCopyWith<_$NeedEnergyImpl> get copyWith =>
      __$$NeedEnergyImplCopyWithImpl<_$NeedEnergyImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NeedEnergyImplToJson(this);
  }
}

abstract class _NeedEnergy implements NeedEnergy {
  const factory _NeedEnergy({
    required final String value,
    required final String logo,
  }) = _$NeedEnergyImpl;

  factory _NeedEnergy.fromJson(Map<String, dynamic> json) =
      _$NeedEnergyImpl.fromJson;

  @override
  String get value;
  @override
  String get logo;

  /// Create a copy of NeedEnergy
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NeedEnergyImplCopyWith<_$NeedEnergyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GundamCard _$GundamCardFromJson(Map<String, dynamic> json) {
  return _GundamCard.fromJson(json);
}

/// @nodoc
mixin _$GundamCard {
  String get id => throw _privateConstructorUsedError;
  String get code => throw _privateConstructorUsedError;
  String get rarity => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  Map<String, String> get images => throw _privateConstructorUsedError;
  String get level => throw _privateConstructorUsedError;
  String get cost => throw _privateConstructorUsedError;
  String get color => throw _privateConstructorUsedError;
  String get cardType => throw _privateConstructorUsedError;
  String get effect => throw _privateConstructorUsedError;
  String get zone => throw _privateConstructorUsedError;
  String get trait => throw _privateConstructorUsedError;
  String get link => throw _privateConstructorUsedError;
  String get ap => throw _privateConstructorUsedError;
  String get hp => throw _privateConstructorUsedError;
  String get sourceTitle => throw _privateConstructorUsedError;
  String get getIt => throw _privateConstructorUsedError;
  SetInfo get set => throw _privateConstructorUsedError;

  /// Serializes this GundamCard to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GundamCard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GundamCardCopyWith<GundamCard> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GundamCardCopyWith<$Res> {
  factory $GundamCardCopyWith(
    GundamCard value,
    $Res Function(GundamCard) then,
  ) = _$GundamCardCopyWithImpl<$Res, GundamCard>;
  @useResult
  $Res call({
    String id,
    String code,
    String rarity,
    String name,
    Map<String, String> images,
    String level,
    String cost,
    String color,
    String cardType,
    String effect,
    String zone,
    String trait,
    String link,
    String ap,
    String hp,
    String sourceTitle,
    String getIt,
    SetInfo set,
  });

  $SetInfoCopyWith<$Res> get set;
}

/// @nodoc
class _$GundamCardCopyWithImpl<$Res, $Val extends GundamCard>
    implements $GundamCardCopyWith<$Res> {
  _$GundamCardCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GundamCard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? code = null,
    Object? rarity = null,
    Object? name = null,
    Object? images = null,
    Object? level = null,
    Object? cost = null,
    Object? color = null,
    Object? cardType = null,
    Object? effect = null,
    Object? zone = null,
    Object? trait = null,
    Object? link = null,
    Object? ap = null,
    Object? hp = null,
    Object? sourceTitle = null,
    Object? getIt = null,
    Object? set = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            code: null == code
                ? _value.code
                : code // ignore: cast_nullable_to_non_nullable
                      as String,
            rarity: null == rarity
                ? _value.rarity
                : rarity // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            images: null == images
                ? _value.images
                : images // ignore: cast_nullable_to_non_nullable
                      as Map<String, String>,
            level: null == level
                ? _value.level
                : level // ignore: cast_nullable_to_non_nullable
                      as String,
            cost: null == cost
                ? _value.cost
                : cost // ignore: cast_nullable_to_non_nullable
                      as String,
            color: null == color
                ? _value.color
                : color // ignore: cast_nullable_to_non_nullable
                      as String,
            cardType: null == cardType
                ? _value.cardType
                : cardType // ignore: cast_nullable_to_non_nullable
                      as String,
            effect: null == effect
                ? _value.effect
                : effect // ignore: cast_nullable_to_non_nullable
                      as String,
            zone: null == zone
                ? _value.zone
                : zone // ignore: cast_nullable_to_non_nullable
                      as String,
            trait: null == trait
                ? _value.trait
                : trait // ignore: cast_nullable_to_non_nullable
                      as String,
            link: null == link
                ? _value.link
                : link // ignore: cast_nullable_to_non_nullable
                      as String,
            ap: null == ap
                ? _value.ap
                : ap // ignore: cast_nullable_to_non_nullable
                      as String,
            hp: null == hp
                ? _value.hp
                : hp // ignore: cast_nullable_to_non_nullable
                      as String,
            sourceTitle: null == sourceTitle
                ? _value.sourceTitle
                : sourceTitle // ignore: cast_nullable_to_non_nullable
                      as String,
            getIt: null == getIt
                ? _value.getIt
                : getIt // ignore: cast_nullable_to_non_nullable
                      as String,
            set: null == set
                ? _value.set
                : set // ignore: cast_nullable_to_non_nullable
                      as SetInfo,
          )
          as $Val,
    );
  }

  /// Create a copy of GundamCard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SetInfoCopyWith<$Res> get set {
    return $SetInfoCopyWith<$Res>(_value.set, (value) {
      return _then(_value.copyWith(set: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$GundamCardImplCopyWith<$Res>
    implements $GundamCardCopyWith<$Res> {
  factory _$$GundamCardImplCopyWith(
    _$GundamCardImpl value,
    $Res Function(_$GundamCardImpl) then,
  ) = __$$GundamCardImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String code,
    String rarity,
    String name,
    Map<String, String> images,
    String level,
    String cost,
    String color,
    String cardType,
    String effect,
    String zone,
    String trait,
    String link,
    String ap,
    String hp,
    String sourceTitle,
    String getIt,
    SetInfo set,
  });

  @override
  $SetInfoCopyWith<$Res> get set;
}

/// @nodoc
class __$$GundamCardImplCopyWithImpl<$Res>
    extends _$GundamCardCopyWithImpl<$Res, _$GundamCardImpl>
    implements _$$GundamCardImplCopyWith<$Res> {
  __$$GundamCardImplCopyWithImpl(
    _$GundamCardImpl _value,
    $Res Function(_$GundamCardImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GundamCard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? code = null,
    Object? rarity = null,
    Object? name = null,
    Object? images = null,
    Object? level = null,
    Object? cost = null,
    Object? color = null,
    Object? cardType = null,
    Object? effect = null,
    Object? zone = null,
    Object? trait = null,
    Object? link = null,
    Object? ap = null,
    Object? hp = null,
    Object? sourceTitle = null,
    Object? getIt = null,
    Object? set = null,
  }) {
    return _then(
      _$GundamCardImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        code: null == code
            ? _value.code
            : code // ignore: cast_nullable_to_non_nullable
                  as String,
        rarity: null == rarity
            ? _value.rarity
            : rarity // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        images: null == images
            ? _value._images
            : images // ignore: cast_nullable_to_non_nullable
                  as Map<String, String>,
        level: null == level
            ? _value.level
            : level // ignore: cast_nullable_to_non_nullable
                  as String,
        cost: null == cost
            ? _value.cost
            : cost // ignore: cast_nullable_to_non_nullable
                  as String,
        color: null == color
            ? _value.color
            : color // ignore: cast_nullable_to_non_nullable
                  as String,
        cardType: null == cardType
            ? _value.cardType
            : cardType // ignore: cast_nullable_to_non_nullable
                  as String,
        effect: null == effect
            ? _value.effect
            : effect // ignore: cast_nullable_to_non_nullable
                  as String,
        zone: null == zone
            ? _value.zone
            : zone // ignore: cast_nullable_to_non_nullable
                  as String,
        trait: null == trait
            ? _value.trait
            : trait // ignore: cast_nullable_to_non_nullable
                  as String,
        link: null == link
            ? _value.link
            : link // ignore: cast_nullable_to_non_nullable
                  as String,
        ap: null == ap
            ? _value.ap
            : ap // ignore: cast_nullable_to_non_nullable
                  as String,
        hp: null == hp
            ? _value.hp
            : hp // ignore: cast_nullable_to_non_nullable
                  as String,
        sourceTitle: null == sourceTitle
            ? _value.sourceTitle
            : sourceTitle // ignore: cast_nullable_to_non_nullable
                  as String,
        getIt: null == getIt
            ? _value.getIt
            : getIt // ignore: cast_nullable_to_non_nullable
                  as String,
        set: null == set
            ? _value.set
            : set // ignore: cast_nullable_to_non_nullable
                  as SetInfo,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$GundamCardImpl implements _GundamCard {
  const _$GundamCardImpl({
    required this.id,
    required this.code,
    required this.rarity,
    required this.name,
    required final Map<String, String> images,
    required this.level,
    required this.cost,
    required this.color,
    required this.cardType,
    required this.effect,
    required this.zone,
    required this.trait,
    required this.link,
    required this.ap,
    required this.hp,
    required this.sourceTitle,
    required this.getIt,
    required this.set,
  }) : _images = images;

  factory _$GundamCardImpl.fromJson(Map<String, dynamic> json) =>
      _$$GundamCardImplFromJson(json);

  @override
  final String id;
  @override
  final String code;
  @override
  final String rarity;
  @override
  final String name;
  final Map<String, String> _images;
  @override
  Map<String, String> get images {
    if (_images is EqualUnmodifiableMapView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_images);
  }

  @override
  final String level;
  @override
  final String cost;
  @override
  final String color;
  @override
  final String cardType;
  @override
  final String effect;
  @override
  final String zone;
  @override
  final String trait;
  @override
  final String link;
  @override
  final String ap;
  @override
  final String hp;
  @override
  final String sourceTitle;
  @override
  final String getIt;
  @override
  final SetInfo set;

  @override
  String toString() {
    return 'GundamCard(id: $id, code: $code, rarity: $rarity, name: $name, images: $images, level: $level, cost: $cost, color: $color, cardType: $cardType, effect: $effect, zone: $zone, trait: $trait, link: $link, ap: $ap, hp: $hp, sourceTitle: $sourceTitle, getIt: $getIt, set: $set)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GundamCardImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.rarity, rarity) || other.rarity == rarity) &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.cost, cost) || other.cost == cost) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.cardType, cardType) ||
                other.cardType == cardType) &&
            (identical(other.effect, effect) || other.effect == effect) &&
            (identical(other.zone, zone) || other.zone == zone) &&
            (identical(other.trait, trait) || other.trait == trait) &&
            (identical(other.link, link) || other.link == link) &&
            (identical(other.ap, ap) || other.ap == ap) &&
            (identical(other.hp, hp) || other.hp == hp) &&
            (identical(other.sourceTitle, sourceTitle) ||
                other.sourceTitle == sourceTitle) &&
            (identical(other.getIt, getIt) || other.getIt == getIt) &&
            (identical(other.set, set) || other.set == set));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    code,
    rarity,
    name,
    const DeepCollectionEquality().hash(_images),
    level,
    cost,
    color,
    cardType,
    effect,
    zone,
    trait,
    link,
    ap,
    hp,
    sourceTitle,
    getIt,
    set,
  );

  /// Create a copy of GundamCard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GundamCardImplCopyWith<_$GundamCardImpl> get copyWith =>
      __$$GundamCardImplCopyWithImpl<_$GundamCardImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GundamCardImplToJson(this);
  }
}

abstract class _GundamCard implements GundamCard {
  const factory _GundamCard({
    required final String id,
    required final String code,
    required final String rarity,
    required final String name,
    required final Map<String, String> images,
    required final String level,
    required final String cost,
    required final String color,
    required final String cardType,
    required final String effect,
    required final String zone,
    required final String trait,
    required final String link,
    required final String ap,
    required final String hp,
    required final String sourceTitle,
    required final String getIt,
    required final SetInfo set,
  }) = _$GundamCardImpl;

  factory _GundamCard.fromJson(Map<String, dynamic> json) =
      _$GundamCardImpl.fromJson;

  @override
  String get id;
  @override
  String get code;
  @override
  String get rarity;
  @override
  String get name;
  @override
  Map<String, String> get images;
  @override
  String get level;
  @override
  String get cost;
  @override
  String get color;
  @override
  String get cardType;
  @override
  String get effect;
  @override
  String get zone;
  @override
  String get trait;
  @override
  String get link;
  @override
  String get ap;
  @override
  String get hp;
  @override
  String get sourceTitle;
  @override
  String get getIt;
  @override
  SetInfo get set;

  /// Create a copy of GundamCard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GundamCardImplCopyWith<_$GundamCardImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
