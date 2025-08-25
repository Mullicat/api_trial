// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'card_model_pokemon.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Card _$CardFromJson(Map<String, dynamic> json) {
  return _Card.fromJson(json);
}

/// @nodoc
mixin _$Card {
  String? get id => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  String? get supertype => throw _privateConstructorUsedError;
  List<String>? get subtypes => throw _privateConstructorUsedError;
  String? get hp => throw _privateConstructorUsedError;
  List<String>? get types => throw _privateConstructorUsedError;
  String? get evolvesFrom => throw _privateConstructorUsedError;
  List<Ability>? get abilities => throw _privateConstructorUsedError;
  List<Attack>? get attacks => throw _privateConstructorUsedError;
  List<Weakness>? get weaknesses => throw _privateConstructorUsedError;
  List<String>? get retreatCost => throw _privateConstructorUsedError;
  int? get convertedRetreatCost => throw _privateConstructorUsedError;
  Set? get set => throw _privateConstructorUsedError;
  String? get number => throw _privateConstructorUsedError;
  String? get artist => throw _privateConstructorUsedError;
  String? get rarity => throw _privateConstructorUsedError;
  String? get flavorText => throw _privateConstructorUsedError;
  List<int>? get nationalPokedexNumbers => throw _privateConstructorUsedError;
  Legalities? get legalities => throw _privateConstructorUsedError;
  Images? get images => throw _privateConstructorUsedError;
  Tcgplayer? get tcgplayer => throw _privateConstructorUsedError;
  Cardmarket? get cardmarket => throw _privateConstructorUsedError;

  /// Serializes this Card to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Card
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CardCopyWith<Card> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CardCopyWith<$Res> {
  factory $CardCopyWith(Card value, $Res Function(Card) then) =
      _$CardCopyWithImpl<$Res, Card>;
  @useResult
  $Res call({
    String? id,
    String? name,
    String? supertype,
    List<String>? subtypes,
    String? hp,
    List<String>? types,
    String? evolvesFrom,
    List<Ability>? abilities,
    List<Attack>? attacks,
    List<Weakness>? weaknesses,
    List<String>? retreatCost,
    int? convertedRetreatCost,
    Set? set,
    String? number,
    String? artist,
    String? rarity,
    String? flavorText,
    List<int>? nationalPokedexNumbers,
    Legalities? legalities,
    Images? images,
    Tcgplayer? tcgplayer,
    Cardmarket? cardmarket,
  });

  $SetCopyWith<$Res>? get set;
  $LegalitiesCopyWith<$Res>? get legalities;
  $ImagesCopyWith<$Res>? get images;
  $TcgplayerCopyWith<$Res>? get tcgplayer;
  $CardmarketCopyWith<$Res>? get cardmarket;
}

/// @nodoc
class _$CardCopyWithImpl<$Res, $Val extends Card>
    implements $CardCopyWith<$Res> {
  _$CardCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Card
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? supertype = freezed,
    Object? subtypes = freezed,
    Object? hp = freezed,
    Object? types = freezed,
    Object? evolvesFrom = freezed,
    Object? abilities = freezed,
    Object? attacks = freezed,
    Object? weaknesses = freezed,
    Object? retreatCost = freezed,
    Object? convertedRetreatCost = freezed,
    Object? set = freezed,
    Object? number = freezed,
    Object? artist = freezed,
    Object? rarity = freezed,
    Object? flavorText = freezed,
    Object? nationalPokedexNumbers = freezed,
    Object? legalities = freezed,
    Object? images = freezed,
    Object? tcgplayer = freezed,
    Object? cardmarket = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String?,
            name: freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String?,
            supertype: freezed == supertype
                ? _value.supertype
                : supertype // ignore: cast_nullable_to_non_nullable
                      as String?,
            subtypes: freezed == subtypes
                ? _value.subtypes
                : subtypes // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            hp: freezed == hp
                ? _value.hp
                : hp // ignore: cast_nullable_to_non_nullable
                      as String?,
            types: freezed == types
                ? _value.types
                : types // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
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
            retreatCost: freezed == retreatCost
                ? _value.retreatCost
                : retreatCost // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            convertedRetreatCost: freezed == convertedRetreatCost
                ? _value.convertedRetreatCost
                : convertedRetreatCost // ignore: cast_nullable_to_non_nullable
                      as int?,
            set: freezed == set
                ? _value.set
                : set // ignore: cast_nullable_to_non_nullable
                      as Set?,
            number: freezed == number
                ? _value.number
                : number // ignore: cast_nullable_to_non_nullable
                      as String?,
            artist: freezed == artist
                ? _value.artist
                : artist // ignore: cast_nullable_to_non_nullable
                      as String?,
            rarity: freezed == rarity
                ? _value.rarity
                : rarity // ignore: cast_nullable_to_non_nullable
                      as String?,
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
                      as Legalities?,
            images: freezed == images
                ? _value.images
                : images // ignore: cast_nullable_to_non_nullable
                      as Images?,
            tcgplayer: freezed == tcgplayer
                ? _value.tcgplayer
                : tcgplayer // ignore: cast_nullable_to_non_nullable
                      as Tcgplayer?,
            cardmarket: freezed == cardmarket
                ? _value.cardmarket
                : cardmarket // ignore: cast_nullable_to_non_nullable
                      as Cardmarket?,
          )
          as $Val,
    );
  }

  /// Create a copy of Card
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SetCopyWith<$Res>? get set {
    if (_value.set == null) {
      return null;
    }

    return $SetCopyWith<$Res>(_value.set!, (value) {
      return _then(_value.copyWith(set: value) as $Val);
    });
  }

  /// Create a copy of Card
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LegalitiesCopyWith<$Res>? get legalities {
    if (_value.legalities == null) {
      return null;
    }

    return $LegalitiesCopyWith<$Res>(_value.legalities!, (value) {
      return _then(_value.copyWith(legalities: value) as $Val);
    });
  }

  /// Create a copy of Card
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ImagesCopyWith<$Res>? get images {
    if (_value.images == null) {
      return null;
    }

    return $ImagesCopyWith<$Res>(_value.images!, (value) {
      return _then(_value.copyWith(images: value) as $Val);
    });
  }

  /// Create a copy of Card
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TcgplayerCopyWith<$Res>? get tcgplayer {
    if (_value.tcgplayer == null) {
      return null;
    }

    return $TcgplayerCopyWith<$Res>(_value.tcgplayer!, (value) {
      return _then(_value.copyWith(tcgplayer: value) as $Val);
    });
  }

  /// Create a copy of Card
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CardmarketCopyWith<$Res>? get cardmarket {
    if (_value.cardmarket == null) {
      return null;
    }

    return $CardmarketCopyWith<$Res>(_value.cardmarket!, (value) {
      return _then(_value.copyWith(cardmarket: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CardImplCopyWith<$Res> implements $CardCopyWith<$Res> {
  factory _$$CardImplCopyWith(
    _$CardImpl value,
    $Res Function(_$CardImpl) then,
  ) = __$$CardImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? id,
    String? name,
    String? supertype,
    List<String>? subtypes,
    String? hp,
    List<String>? types,
    String? evolvesFrom,
    List<Ability>? abilities,
    List<Attack>? attacks,
    List<Weakness>? weaknesses,
    List<String>? retreatCost,
    int? convertedRetreatCost,
    Set? set,
    String? number,
    String? artist,
    String? rarity,
    String? flavorText,
    List<int>? nationalPokedexNumbers,
    Legalities? legalities,
    Images? images,
    Tcgplayer? tcgplayer,
    Cardmarket? cardmarket,
  });

  @override
  $SetCopyWith<$Res>? get set;
  @override
  $LegalitiesCopyWith<$Res>? get legalities;
  @override
  $ImagesCopyWith<$Res>? get images;
  @override
  $TcgplayerCopyWith<$Res>? get tcgplayer;
  @override
  $CardmarketCopyWith<$Res>? get cardmarket;
}

/// @nodoc
class __$$CardImplCopyWithImpl<$Res>
    extends _$CardCopyWithImpl<$Res, _$CardImpl>
    implements _$$CardImplCopyWith<$Res> {
  __$$CardImplCopyWithImpl(_$CardImpl _value, $Res Function(_$CardImpl) _then)
    : super(_value, _then);

  /// Create a copy of Card
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? supertype = freezed,
    Object? subtypes = freezed,
    Object? hp = freezed,
    Object? types = freezed,
    Object? evolvesFrom = freezed,
    Object? abilities = freezed,
    Object? attacks = freezed,
    Object? weaknesses = freezed,
    Object? retreatCost = freezed,
    Object? convertedRetreatCost = freezed,
    Object? set = freezed,
    Object? number = freezed,
    Object? artist = freezed,
    Object? rarity = freezed,
    Object? flavorText = freezed,
    Object? nationalPokedexNumbers = freezed,
    Object? legalities = freezed,
    Object? images = freezed,
    Object? tcgplayer = freezed,
    Object? cardmarket = freezed,
  }) {
    return _then(
      _$CardImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
        name: freezed == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String?,
        supertype: freezed == supertype
            ? _value.supertype
            : supertype // ignore: cast_nullable_to_non_nullable
                  as String?,
        subtypes: freezed == subtypes
            ? _value._subtypes
            : subtypes // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        hp: freezed == hp
            ? _value.hp
            : hp // ignore: cast_nullable_to_non_nullable
                  as String?,
        types: freezed == types
            ? _value._types
            : types // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
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
        retreatCost: freezed == retreatCost
            ? _value._retreatCost
            : retreatCost // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        convertedRetreatCost: freezed == convertedRetreatCost
            ? _value.convertedRetreatCost
            : convertedRetreatCost // ignore: cast_nullable_to_non_nullable
                  as int?,
        set: freezed == set
            ? _value.set
            : set // ignore: cast_nullable_to_non_nullable
                  as Set?,
        number: freezed == number
            ? _value.number
            : number // ignore: cast_nullable_to_non_nullable
                  as String?,
        artist: freezed == artist
            ? _value.artist
            : artist // ignore: cast_nullable_to_non_nullable
                  as String?,
        rarity: freezed == rarity
            ? _value.rarity
            : rarity // ignore: cast_nullable_to_non_nullable
                  as String?,
        flavorText: freezed == flavorText
            ? _value.flavorText
            : flavorText // ignore: cast_nullable_to_non_nullable
                  as String?,
        nationalPokedexNumbers: freezed == nationalPokedexNumbers
            ? _value._nationalPokedexNumbers
            : nationalPokedexNumbers // ignore: cast_nullable_to_non_nullable
                  as List<int>?,
        legalities: freezed == legalities
            ? _value.legalities
            : legalities // ignore: cast_nullable_to_non_nullable
                  as Legalities?,
        images: freezed == images
            ? _value.images
            : images // ignore: cast_nullable_to_non_nullable
                  as Images?,
        tcgplayer: freezed == tcgplayer
            ? _value.tcgplayer
            : tcgplayer // ignore: cast_nullable_to_non_nullable
                  as Tcgplayer?,
        cardmarket: freezed == cardmarket
            ? _value.cardmarket
            : cardmarket // ignore: cast_nullable_to_non_nullable
                  as Cardmarket?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CardImpl implements _Card {
  const _$CardImpl({
    this.id,
    this.name,
    this.supertype,
    final List<String>? subtypes,
    this.hp,
    final List<String>? types,
    this.evolvesFrom,
    final List<Ability>? abilities,
    final List<Attack>? attacks,
    final List<Weakness>? weaknesses,
    final List<String>? retreatCost,
    this.convertedRetreatCost,
    this.set,
    this.number,
    this.artist,
    this.rarity,
    this.flavorText,
    final List<int>? nationalPokedexNumbers,
    this.legalities,
    this.images,
    this.tcgplayer,
    this.cardmarket,
  }) : _subtypes = subtypes,
       _types = types,
       _abilities = abilities,
       _attacks = attacks,
       _weaknesses = weaknesses,
       _retreatCost = retreatCost,
       _nationalPokedexNumbers = nationalPokedexNumbers;

  factory _$CardImpl.fromJson(Map<String, dynamic> json) =>
      _$$CardImplFromJson(json);

  @override
  final String? id;
  @override
  final String? name;
  @override
  final String? supertype;
  final List<String>? _subtypes;
  @override
  List<String>? get subtypes {
    final value = _subtypes;
    if (value == null) return null;
    if (_subtypes is EqualUnmodifiableListView) return _subtypes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? hp;
  final List<String>? _types;
  @override
  List<String>? get types {
    final value = _types;
    if (value == null) return null;
    if (_types is EqualUnmodifiableListView) return _types;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
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
  final Set? set;
  @override
  final String? number;
  @override
  final String? artist;
  @override
  final String? rarity;
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

  @override
  final Legalities? legalities;
  @override
  final Images? images;
  @override
  final Tcgplayer? tcgplayer;
  @override
  final Cardmarket? cardmarket;

  @override
  String toString() {
    return 'Card(id: $id, name: $name, supertype: $supertype, subtypes: $subtypes, hp: $hp, types: $types, evolvesFrom: $evolvesFrom, abilities: $abilities, attacks: $attacks, weaknesses: $weaknesses, retreatCost: $retreatCost, convertedRetreatCost: $convertedRetreatCost, set: $set, number: $number, artist: $artist, rarity: $rarity, flavorText: $flavorText, nationalPokedexNumbers: $nationalPokedexNumbers, legalities: $legalities, images: $images, tcgplayer: $tcgplayer, cardmarket: $cardmarket)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CardImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.supertype, supertype) ||
                other.supertype == supertype) &&
            const DeepCollectionEquality().equals(other._subtypes, _subtypes) &&
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
              other._retreatCost,
              _retreatCost,
            ) &&
            (identical(other.convertedRetreatCost, convertedRetreatCost) ||
                other.convertedRetreatCost == convertedRetreatCost) &&
            (identical(other.set, set) || other.set == set) &&
            (identical(other.number, number) || other.number == number) &&
            (identical(other.artist, artist) || other.artist == artist) &&
            (identical(other.rarity, rarity) || other.rarity == rarity) &&
            (identical(other.flavorText, flavorText) ||
                other.flavorText == flavorText) &&
            const DeepCollectionEquality().equals(
              other._nationalPokedexNumbers,
              _nationalPokedexNumbers,
            ) &&
            (identical(other.legalities, legalities) ||
                other.legalities == legalities) &&
            (identical(other.images, images) || other.images == images) &&
            (identical(other.tcgplayer, tcgplayer) ||
                other.tcgplayer == tcgplayer) &&
            (identical(other.cardmarket, cardmarket) ||
                other.cardmarket == cardmarket));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    name,
    supertype,
    const DeepCollectionEquality().hash(_subtypes),
    hp,
    const DeepCollectionEquality().hash(_types),
    evolvesFrom,
    const DeepCollectionEquality().hash(_abilities),
    const DeepCollectionEquality().hash(_attacks),
    const DeepCollectionEquality().hash(_weaknesses),
    const DeepCollectionEquality().hash(_retreatCost),
    convertedRetreatCost,
    set,
    number,
    artist,
    rarity,
    flavorText,
    const DeepCollectionEquality().hash(_nationalPokedexNumbers),
    legalities,
    images,
    tcgplayer,
    cardmarket,
  ]);

  /// Create a copy of Card
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CardImplCopyWith<_$CardImpl> get copyWith =>
      __$$CardImplCopyWithImpl<_$CardImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CardImplToJson(this);
  }
}

abstract class _Card implements Card {
  const factory _Card({
    final String? id,
    final String? name,
    final String? supertype,
    final List<String>? subtypes,
    final String? hp,
    final List<String>? types,
    final String? evolvesFrom,
    final List<Ability>? abilities,
    final List<Attack>? attacks,
    final List<Weakness>? weaknesses,
    final List<String>? retreatCost,
    final int? convertedRetreatCost,
    final Set? set,
    final String? number,
    final String? artist,
    final String? rarity,
    final String? flavorText,
    final List<int>? nationalPokedexNumbers,
    final Legalities? legalities,
    final Images? images,
    final Tcgplayer? tcgplayer,
    final Cardmarket? cardmarket,
  }) = _$CardImpl;

  factory _Card.fromJson(Map<String, dynamic> json) = _$CardImpl.fromJson;

  @override
  String? get id;
  @override
  String? get name;
  @override
  String? get supertype;
  @override
  List<String>? get subtypes;
  @override
  String? get hp;
  @override
  List<String>? get types;
  @override
  String? get evolvesFrom;
  @override
  List<Ability>? get abilities;
  @override
  List<Attack>? get attacks;
  @override
  List<Weakness>? get weaknesses;
  @override
  List<String>? get retreatCost;
  @override
  int? get convertedRetreatCost;
  @override
  Set? get set;
  @override
  String? get number;
  @override
  String? get artist;
  @override
  String? get rarity;
  @override
  String? get flavorText;
  @override
  List<int>? get nationalPokedexNumbers;
  @override
  Legalities? get legalities;
  @override
  Images? get images;
  @override
  Tcgplayer? get tcgplayer;
  @override
  Cardmarket? get cardmarket;

  /// Create a copy of Card
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CardImplCopyWith<_$CardImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Set _$SetFromJson(Map<String, dynamic> json) {
  return _Set.fromJson(json);
}

/// @nodoc
mixin _$Set {
  String? get id => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  String? get series => throw _privateConstructorUsedError;
  int? get printedTotal => throw _privateConstructorUsedError;
  int? get total => throw _privateConstructorUsedError;
  Legalities? get legalities => throw _privateConstructorUsedError;
  String? get ptcgoCode => throw _privateConstructorUsedError;
  String? get releaseDate => throw _privateConstructorUsedError;
  String? get updatedAt => throw _privateConstructorUsedError;
  Images? get images => throw _privateConstructorUsedError;

  /// Serializes this Set to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Set
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SetCopyWith<Set> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SetCopyWith<$Res> {
  factory $SetCopyWith(Set value, $Res Function(Set) then) =
      _$SetCopyWithImpl<$Res, Set>;
  @useResult
  $Res call({
    String? id,
    String? name,
    String? series,
    int? printedTotal,
    int? total,
    Legalities? legalities,
    String? ptcgoCode,
    String? releaseDate,
    String? updatedAt,
    Images? images,
  });

  $LegalitiesCopyWith<$Res>? get legalities;
  $ImagesCopyWith<$Res>? get images;
}

/// @nodoc
class _$SetCopyWithImpl<$Res, $Val extends Set> implements $SetCopyWith<$Res> {
  _$SetCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Set
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? series = freezed,
    Object? printedTotal = freezed,
    Object? total = freezed,
    Object? legalities = freezed,
    Object? ptcgoCode = freezed,
    Object? releaseDate = freezed,
    Object? updatedAt = freezed,
    Object? images = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String?,
            name: freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String?,
            series: freezed == series
                ? _value.series
                : series // ignore: cast_nullable_to_non_nullable
                      as String?,
            printedTotal: freezed == printedTotal
                ? _value.printedTotal
                : printedTotal // ignore: cast_nullable_to_non_nullable
                      as int?,
            total: freezed == total
                ? _value.total
                : total // ignore: cast_nullable_to_non_nullable
                      as int?,
            legalities: freezed == legalities
                ? _value.legalities
                : legalities // ignore: cast_nullable_to_non_nullable
                      as Legalities?,
            ptcgoCode: freezed == ptcgoCode
                ? _value.ptcgoCode
                : ptcgoCode // ignore: cast_nullable_to_non_nullable
                      as String?,
            releaseDate: freezed == releaseDate
                ? _value.releaseDate
                : releaseDate // ignore: cast_nullable_to_non_nullable
                      as String?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as String?,
            images: freezed == images
                ? _value.images
                : images // ignore: cast_nullable_to_non_nullable
                      as Images?,
          )
          as $Val,
    );
  }

  /// Create a copy of Set
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LegalitiesCopyWith<$Res>? get legalities {
    if (_value.legalities == null) {
      return null;
    }

    return $LegalitiesCopyWith<$Res>(_value.legalities!, (value) {
      return _then(_value.copyWith(legalities: value) as $Val);
    });
  }

  /// Create a copy of Set
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ImagesCopyWith<$Res>? get images {
    if (_value.images == null) {
      return null;
    }

    return $ImagesCopyWith<$Res>(_value.images!, (value) {
      return _then(_value.copyWith(images: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SetImplCopyWith<$Res> implements $SetCopyWith<$Res> {
  factory _$$SetImplCopyWith(_$SetImpl value, $Res Function(_$SetImpl) then) =
      __$$SetImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? id,
    String? name,
    String? series,
    int? printedTotal,
    int? total,
    Legalities? legalities,
    String? ptcgoCode,
    String? releaseDate,
    String? updatedAt,
    Images? images,
  });

  @override
  $LegalitiesCopyWith<$Res>? get legalities;
  @override
  $ImagesCopyWith<$Res>? get images;
}

/// @nodoc
class __$$SetImplCopyWithImpl<$Res> extends _$SetCopyWithImpl<$Res, _$SetImpl>
    implements _$$SetImplCopyWith<$Res> {
  __$$SetImplCopyWithImpl(_$SetImpl _value, $Res Function(_$SetImpl) _then)
    : super(_value, _then);

  /// Create a copy of Set
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? series = freezed,
    Object? printedTotal = freezed,
    Object? total = freezed,
    Object? legalities = freezed,
    Object? ptcgoCode = freezed,
    Object? releaseDate = freezed,
    Object? updatedAt = freezed,
    Object? images = freezed,
  }) {
    return _then(
      _$SetImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
        name: freezed == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String?,
        series: freezed == series
            ? _value.series
            : series // ignore: cast_nullable_to_non_nullable
                  as String?,
        printedTotal: freezed == printedTotal
            ? _value.printedTotal
            : printedTotal // ignore: cast_nullable_to_non_nullable
                  as int?,
        total: freezed == total
            ? _value.total
            : total // ignore: cast_nullable_to_non_nullable
                  as int?,
        legalities: freezed == legalities
            ? _value.legalities
            : legalities // ignore: cast_nullable_to_non_nullable
                  as Legalities?,
        ptcgoCode: freezed == ptcgoCode
            ? _value.ptcgoCode
            : ptcgoCode // ignore: cast_nullable_to_non_nullable
                  as String?,
        releaseDate: freezed == releaseDate
            ? _value.releaseDate
            : releaseDate // ignore: cast_nullable_to_non_nullable
                  as String?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as String?,
        images: freezed == images
            ? _value.images
            : images // ignore: cast_nullable_to_non_nullable
                  as Images?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SetImpl implements _Set {
  const _$SetImpl({
    this.id,
    this.name,
    this.series,
    this.printedTotal,
    this.total,
    this.legalities,
    this.ptcgoCode,
    this.releaseDate,
    this.updatedAt,
    this.images,
  });

  factory _$SetImpl.fromJson(Map<String, dynamic> json) =>
      _$$SetImplFromJson(json);

  @override
  final String? id;
  @override
  final String? name;
  @override
  final String? series;
  @override
  final int? printedTotal;
  @override
  final int? total;
  @override
  final Legalities? legalities;
  @override
  final String? ptcgoCode;
  @override
  final String? releaseDate;
  @override
  final String? updatedAt;
  @override
  final Images? images;

  @override
  String toString() {
    return 'Set(id: $id, name: $name, series: $series, printedTotal: $printedTotal, total: $total, legalities: $legalities, ptcgoCode: $ptcgoCode, releaseDate: $releaseDate, updatedAt: $updatedAt, images: $images)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SetImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.series, series) || other.series == series) &&
            (identical(other.printedTotal, printedTotal) ||
                other.printedTotal == printedTotal) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.legalities, legalities) ||
                other.legalities == legalities) &&
            (identical(other.ptcgoCode, ptcgoCode) ||
                other.ptcgoCode == ptcgoCode) &&
            (identical(other.releaseDate, releaseDate) ||
                other.releaseDate == releaseDate) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.images, images) || other.images == images));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    series,
    printedTotal,
    total,
    legalities,
    ptcgoCode,
    releaseDate,
    updatedAt,
    images,
  );

  /// Create a copy of Set
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SetImplCopyWith<_$SetImpl> get copyWith =>
      __$$SetImplCopyWithImpl<_$SetImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SetImplToJson(this);
  }
}

abstract class _Set implements Set {
  const factory _Set({
    final String? id,
    final String? name,
    final String? series,
    final int? printedTotal,
    final int? total,
    final Legalities? legalities,
    final String? ptcgoCode,
    final String? releaseDate,
    final String? updatedAt,
    final Images? images,
  }) = _$SetImpl;

  factory _Set.fromJson(Map<String, dynamic> json) = _$SetImpl.fromJson;

  @override
  String? get id;
  @override
  String? get name;
  @override
  String? get series;
  @override
  int? get printedTotal;
  @override
  int? get total;
  @override
  Legalities? get legalities;
  @override
  String? get ptcgoCode;
  @override
  String? get releaseDate;
  @override
  String? get updatedAt;
  @override
  Images? get images;

  /// Create a copy of Set
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SetImplCopyWith<_$SetImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Ability _$AbilityFromJson(Map<String, dynamic> json) {
  return _Ability.fromJson(json);
}

/// @nodoc
mixin _$Ability {
  String? get name => throw _privateConstructorUsedError;
  String? get text => throw _privateConstructorUsedError;
  String? get type => throw _privateConstructorUsedError;

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
  $Res call({String? name, String? text, String? type});
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
  $Res call({
    Object? name = freezed,
    Object? text = freezed,
    Object? type = freezed,
  }) {
    return _then(
      _value.copyWith(
            name: freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String?,
            text: freezed == text
                ? _value.text
                : text // ignore: cast_nullable_to_non_nullable
                      as String?,
            type: freezed == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String?,
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
  $Res call({String? name, String? text, String? type});
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
  $Res call({
    Object? name = freezed,
    Object? text = freezed,
    Object? type = freezed,
  }) {
    return _then(
      _$AbilityImpl(
        name: freezed == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String?,
        text: freezed == text
            ? _value.text
            : text // ignore: cast_nullable_to_non_nullable
                  as String?,
        type: freezed == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AbilityImpl implements _Ability {
  const _$AbilityImpl({this.name, this.text, this.type});

  factory _$AbilityImpl.fromJson(Map<String, dynamic> json) =>
      _$$AbilityImplFromJson(json);

  @override
  final String? name;
  @override
  final String? text;
  @override
  final String? type;

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
    final String? name,
    final String? text,
    final String? type,
  }) = _$AbilityImpl;

  factory _Ability.fromJson(Map<String, dynamic> json) = _$AbilityImpl.fromJson;

  @override
  String? get name;
  @override
  String? get text;
  @override
  String? get type;

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
  String? get name => throw _privateConstructorUsedError;
  String? get text => throw _privateConstructorUsedError;
  List<String>? get cost => throw _privateConstructorUsedError;
  int? get convertedEnergyCost => throw _privateConstructorUsedError;
  String? get damage => throw _privateConstructorUsedError;

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
    String? name,
    String? text,
    List<String>? cost,
    int? convertedEnergyCost,
    String? damage,
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
    Object? name = freezed,
    Object? text = freezed,
    Object? cost = freezed,
    Object? convertedEnergyCost = freezed,
    Object? damage = freezed,
  }) {
    return _then(
      _value.copyWith(
            name: freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String?,
            text: freezed == text
                ? _value.text
                : text // ignore: cast_nullable_to_non_nullable
                      as String?,
            cost: freezed == cost
                ? _value.cost
                : cost // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            convertedEnergyCost: freezed == convertedEnergyCost
                ? _value.convertedEnergyCost
                : convertedEnergyCost // ignore: cast_nullable_to_non_nullable
                      as int?,
            damage: freezed == damage
                ? _value.damage
                : damage // ignore: cast_nullable_to_non_nullable
                      as String?,
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
    String? name,
    String? text,
    List<String>? cost,
    int? convertedEnergyCost,
    String? damage,
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
    Object? name = freezed,
    Object? text = freezed,
    Object? cost = freezed,
    Object? convertedEnergyCost = freezed,
    Object? damage = freezed,
  }) {
    return _then(
      _$AttackImpl(
        name: freezed == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String?,
        text: freezed == text
            ? _value.text
            : text // ignore: cast_nullable_to_non_nullable
                  as String?,
        cost: freezed == cost
            ? _value._cost
            : cost // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        convertedEnergyCost: freezed == convertedEnergyCost
            ? _value.convertedEnergyCost
            : convertedEnergyCost // ignore: cast_nullable_to_non_nullable
                  as int?,
        damage: freezed == damage
            ? _value.damage
            : damage // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AttackImpl implements _Attack {
  const _$AttackImpl({
    this.name,
    this.text,
    final List<String>? cost,
    this.convertedEnergyCost,
    this.damage,
  }) : _cost = cost;

  factory _$AttackImpl.fromJson(Map<String, dynamic> json) =>
      _$$AttackImplFromJson(json);

  @override
  final String? name;
  @override
  final String? text;
  final List<String>? _cost;
  @override
  List<String>? get cost {
    final value = _cost;
    if (value == null) return null;
    if (_cost is EqualUnmodifiableListView) return _cost;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final int? convertedEnergyCost;
  @override
  final String? damage;

  @override
  String toString() {
    return 'Attack(name: $name, text: $text, cost: $cost, convertedEnergyCost: $convertedEnergyCost, damage: $damage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AttackImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.text, text) || other.text == text) &&
            const DeepCollectionEquality().equals(other._cost, _cost) &&
            (identical(other.convertedEnergyCost, convertedEnergyCost) ||
                other.convertedEnergyCost == convertedEnergyCost) &&
            (identical(other.damage, damage) || other.damage == damage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    name,
    text,
    const DeepCollectionEquality().hash(_cost),
    convertedEnergyCost,
    damage,
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
    final String? name,
    final String? text,
    final List<String>? cost,
    final int? convertedEnergyCost,
    final String? damage,
  }) = _$AttackImpl;

  factory _Attack.fromJson(Map<String, dynamic> json) = _$AttackImpl.fromJson;

  @override
  String? get name;
  @override
  String? get text;
  @override
  List<String>? get cost;
  @override
  int? get convertedEnergyCost;
  @override
  String? get damage;

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
  String? get type => throw _privateConstructorUsedError;
  String? get value => throw _privateConstructorUsedError;

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
  $Res call({String? type, String? value});
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
  $Res call({Object? type = freezed, Object? value = freezed}) {
    return _then(
      _value.copyWith(
            type: freezed == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String?,
            value: freezed == value
                ? _value.value
                : value // ignore: cast_nullable_to_non_nullable
                      as String?,
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
  $Res call({String? type, String? value});
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
  $Res call({Object? type = freezed, Object? value = freezed}) {
    return _then(
      _$WeaknessImpl(
        type: freezed == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String?,
        value: freezed == value
            ? _value.value
            : value // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$WeaknessImpl implements _Weakness {
  const _$WeaknessImpl({this.type, this.value});

  factory _$WeaknessImpl.fromJson(Map<String, dynamic> json) =>
      _$$WeaknessImplFromJson(json);

  @override
  final String? type;
  @override
  final String? value;

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
  const factory _Weakness({final String? type, final String? value}) =
      _$WeaknessImpl;

  factory _Weakness.fromJson(Map<String, dynamic> json) =
      _$WeaknessImpl.fromJson;

  @override
  String? get type;
  @override
  String? get value;

  /// Create a copy of Weakness
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WeaknessImplCopyWith<_$WeaknessImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Legalities _$LegalitiesFromJson(Map<String, dynamic> json) {
  return _Legalities.fromJson(json);
}

/// @nodoc
mixin _$Legalities {
  String? get unlimited => throw _privateConstructorUsedError;
  String? get standard => throw _privateConstructorUsedError;
  String? get expanded => throw _privateConstructorUsedError;

  /// Serializes this Legalities to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Legalities
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LegalitiesCopyWith<Legalities> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LegalitiesCopyWith<$Res> {
  factory $LegalitiesCopyWith(
    Legalities value,
    $Res Function(Legalities) then,
  ) = _$LegalitiesCopyWithImpl<$Res, Legalities>;
  @useResult
  $Res call({String? unlimited, String? standard, String? expanded});
}

/// @nodoc
class _$LegalitiesCopyWithImpl<$Res, $Val extends Legalities>
    implements $LegalitiesCopyWith<$Res> {
  _$LegalitiesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Legalities
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? unlimited = freezed,
    Object? standard = freezed,
    Object? expanded = freezed,
  }) {
    return _then(
      _value.copyWith(
            unlimited: freezed == unlimited
                ? _value.unlimited
                : unlimited // ignore: cast_nullable_to_non_nullable
                      as String?,
            standard: freezed == standard
                ? _value.standard
                : standard // ignore: cast_nullable_to_non_nullable
                      as String?,
            expanded: freezed == expanded
                ? _value.expanded
                : expanded // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LegalitiesImplCopyWith<$Res>
    implements $LegalitiesCopyWith<$Res> {
  factory _$$LegalitiesImplCopyWith(
    _$LegalitiesImpl value,
    $Res Function(_$LegalitiesImpl) then,
  ) = __$$LegalitiesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? unlimited, String? standard, String? expanded});
}

/// @nodoc
class __$$LegalitiesImplCopyWithImpl<$Res>
    extends _$LegalitiesCopyWithImpl<$Res, _$LegalitiesImpl>
    implements _$$LegalitiesImplCopyWith<$Res> {
  __$$LegalitiesImplCopyWithImpl(
    _$LegalitiesImpl _value,
    $Res Function(_$LegalitiesImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Legalities
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? unlimited = freezed,
    Object? standard = freezed,
    Object? expanded = freezed,
  }) {
    return _then(
      _$LegalitiesImpl(
        unlimited: freezed == unlimited
            ? _value.unlimited
            : unlimited // ignore: cast_nullable_to_non_nullable
                  as String?,
        standard: freezed == standard
            ? _value.standard
            : standard // ignore: cast_nullable_to_non_nullable
                  as String?,
        expanded: freezed == expanded
            ? _value.expanded
            : expanded // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LegalitiesImpl implements _Legalities {
  const _$LegalitiesImpl({this.unlimited, this.standard, this.expanded});

  factory _$LegalitiesImpl.fromJson(Map<String, dynamic> json) =>
      _$$LegalitiesImplFromJson(json);

  @override
  final String? unlimited;
  @override
  final String? standard;
  @override
  final String? expanded;

  @override
  String toString() {
    return 'Legalities(unlimited: $unlimited, standard: $standard, expanded: $expanded)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LegalitiesImpl &&
            (identical(other.unlimited, unlimited) ||
                other.unlimited == unlimited) &&
            (identical(other.standard, standard) ||
                other.standard == standard) &&
            (identical(other.expanded, expanded) ||
                other.expanded == expanded));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, unlimited, standard, expanded);

  /// Create a copy of Legalities
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LegalitiesImplCopyWith<_$LegalitiesImpl> get copyWith =>
      __$$LegalitiesImplCopyWithImpl<_$LegalitiesImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LegalitiesImplToJson(this);
  }
}

abstract class _Legalities implements Legalities {
  const factory _Legalities({
    final String? unlimited,
    final String? standard,
    final String? expanded,
  }) = _$LegalitiesImpl;

  factory _Legalities.fromJson(Map<String, dynamic> json) =
      _$LegalitiesImpl.fromJson;

  @override
  String? get unlimited;
  @override
  String? get standard;
  @override
  String? get expanded;

  /// Create a copy of Legalities
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LegalitiesImplCopyWith<_$LegalitiesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Images _$ImagesFromJson(Map<String, dynamic> json) {
  return _Images.fromJson(json);
}

/// @nodoc
mixin _$Images {
  String? get small => throw _privateConstructorUsedError;
  String? get large => throw _privateConstructorUsedError;

  /// Serializes this Images to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Images
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ImagesCopyWith<Images> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ImagesCopyWith<$Res> {
  factory $ImagesCopyWith(Images value, $Res Function(Images) then) =
      _$ImagesCopyWithImpl<$Res, Images>;
  @useResult
  $Res call({String? small, String? large});
}

/// @nodoc
class _$ImagesCopyWithImpl<$Res, $Val extends Images>
    implements $ImagesCopyWith<$Res> {
  _$ImagesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Images
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? small = freezed, Object? large = freezed}) {
    return _then(
      _value.copyWith(
            small: freezed == small
                ? _value.small
                : small // ignore: cast_nullable_to_non_nullable
                      as String?,
            large: freezed == large
                ? _value.large
                : large // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ImagesImplCopyWith<$Res> implements $ImagesCopyWith<$Res> {
  factory _$$ImagesImplCopyWith(
    _$ImagesImpl value,
    $Res Function(_$ImagesImpl) then,
  ) = __$$ImagesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? small, String? large});
}

/// @nodoc
class __$$ImagesImplCopyWithImpl<$Res>
    extends _$ImagesCopyWithImpl<$Res, _$ImagesImpl>
    implements _$$ImagesImplCopyWith<$Res> {
  __$$ImagesImplCopyWithImpl(
    _$ImagesImpl _value,
    $Res Function(_$ImagesImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Images
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? small = freezed, Object? large = freezed}) {
    return _then(
      _$ImagesImpl(
        small: freezed == small
            ? _value.small
            : small // ignore: cast_nullable_to_non_nullable
                  as String?,
        large: freezed == large
            ? _value.large
            : large // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ImagesImpl implements _Images {
  const _$ImagesImpl({this.small, this.large});

  factory _$ImagesImpl.fromJson(Map<String, dynamic> json) =>
      _$$ImagesImplFromJson(json);

  @override
  final String? small;
  @override
  final String? large;

  @override
  String toString() {
    return 'Images(small: $small, large: $large)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ImagesImpl &&
            (identical(other.small, small) || other.small == small) &&
            (identical(other.large, large) || other.large == large));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, small, large);

  /// Create a copy of Images
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ImagesImplCopyWith<_$ImagesImpl> get copyWith =>
      __$$ImagesImplCopyWithImpl<_$ImagesImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ImagesImplToJson(this);
  }
}

abstract class _Images implements Images {
  const factory _Images({final String? small, final String? large}) =
      _$ImagesImpl;

  factory _Images.fromJson(Map<String, dynamic> json) = _$ImagesImpl.fromJson;

  @override
  String? get small;
  @override
  String? get large;

  /// Create a copy of Images
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ImagesImplCopyWith<_$ImagesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Tcgplayer _$TcgplayerFromJson(Map<String, dynamic> json) {
  return _Tcgplayer.fromJson(json);
}

/// @nodoc
mixin _$Tcgplayer {
  String? get url => throw _privateConstructorUsedError;
  String? get updatedAt => throw _privateConstructorUsedError;
  TcgplayerPrices? get prices => throw _privateConstructorUsedError;

  /// Serializes this Tcgplayer to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Tcgplayer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TcgplayerCopyWith<Tcgplayer> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TcgplayerCopyWith<$Res> {
  factory $TcgplayerCopyWith(Tcgplayer value, $Res Function(Tcgplayer) then) =
      _$TcgplayerCopyWithImpl<$Res, Tcgplayer>;
  @useResult
  $Res call({String? url, String? updatedAt, TcgplayerPrices? prices});

  $TcgplayerPricesCopyWith<$Res>? get prices;
}

/// @nodoc
class _$TcgplayerCopyWithImpl<$Res, $Val extends Tcgplayer>
    implements $TcgplayerCopyWith<$Res> {
  _$TcgplayerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Tcgplayer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = freezed,
    Object? updatedAt = freezed,
    Object? prices = freezed,
  }) {
    return _then(
      _value.copyWith(
            url: freezed == url
                ? _value.url
                : url // ignore: cast_nullable_to_non_nullable
                      as String?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as String?,
            prices: freezed == prices
                ? _value.prices
                : prices // ignore: cast_nullable_to_non_nullable
                      as TcgplayerPrices?,
          )
          as $Val,
    );
  }

  /// Create a copy of Tcgplayer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TcgplayerPricesCopyWith<$Res>? get prices {
    if (_value.prices == null) {
      return null;
    }

    return $TcgplayerPricesCopyWith<$Res>(_value.prices!, (value) {
      return _then(_value.copyWith(prices: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TcgplayerImplCopyWith<$Res>
    implements $TcgplayerCopyWith<$Res> {
  factory _$$TcgplayerImplCopyWith(
    _$TcgplayerImpl value,
    $Res Function(_$TcgplayerImpl) then,
  ) = __$$TcgplayerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? url, String? updatedAt, TcgplayerPrices? prices});

  @override
  $TcgplayerPricesCopyWith<$Res>? get prices;
}

/// @nodoc
class __$$TcgplayerImplCopyWithImpl<$Res>
    extends _$TcgplayerCopyWithImpl<$Res, _$TcgplayerImpl>
    implements _$$TcgplayerImplCopyWith<$Res> {
  __$$TcgplayerImplCopyWithImpl(
    _$TcgplayerImpl _value,
    $Res Function(_$TcgplayerImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Tcgplayer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = freezed,
    Object? updatedAt = freezed,
    Object? prices = freezed,
  }) {
    return _then(
      _$TcgplayerImpl(
        url: freezed == url
            ? _value.url
            : url // ignore: cast_nullable_to_non_nullable
                  as String?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as String?,
        prices: freezed == prices
            ? _value.prices
            : prices // ignore: cast_nullable_to_non_nullable
                  as TcgplayerPrices?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TcgplayerImpl implements _Tcgplayer {
  const _$TcgplayerImpl({this.url, this.updatedAt, this.prices});

  factory _$TcgplayerImpl.fromJson(Map<String, dynamic> json) =>
      _$$TcgplayerImplFromJson(json);

  @override
  final String? url;
  @override
  final String? updatedAt;
  @override
  final TcgplayerPrices? prices;

  @override
  String toString() {
    return 'Tcgplayer(url: $url, updatedAt: $updatedAt, prices: $prices)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TcgplayerImpl &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.prices, prices) || other.prices == prices));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, url, updatedAt, prices);

  /// Create a copy of Tcgplayer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TcgplayerImplCopyWith<_$TcgplayerImpl> get copyWith =>
      __$$TcgplayerImplCopyWithImpl<_$TcgplayerImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TcgplayerImplToJson(this);
  }
}

abstract class _Tcgplayer implements Tcgplayer {
  const factory _Tcgplayer({
    final String? url,
    final String? updatedAt,
    final TcgplayerPrices? prices,
  }) = _$TcgplayerImpl;

  factory _Tcgplayer.fromJson(Map<String, dynamic> json) =
      _$TcgplayerImpl.fromJson;

  @override
  String? get url;
  @override
  String? get updatedAt;
  @override
  TcgplayerPrices? get prices;

  /// Create a copy of Tcgplayer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TcgplayerImplCopyWith<_$TcgplayerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TcgplayerPrices _$TcgplayerPricesFromJson(Map<String, dynamic> json) {
  return _TcgplayerPrices.fromJson(json);
}

/// @nodoc
mixin _$TcgplayerPrices {
  double? get low => throw _privateConstructorUsedError;
  double? get mid => throw _privateConstructorUsedError;
  double? get high => throw _privateConstructorUsedError;
  double? get market => throw _privateConstructorUsedError;
  double? get directLow => throw _privateConstructorUsedError;

  /// Serializes this TcgplayerPrices to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TcgplayerPrices
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TcgplayerPricesCopyWith<TcgplayerPrices> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TcgplayerPricesCopyWith<$Res> {
  factory $TcgplayerPricesCopyWith(
    TcgplayerPrices value,
    $Res Function(TcgplayerPrices) then,
  ) = _$TcgplayerPricesCopyWithImpl<$Res, TcgplayerPrices>;
  @useResult
  $Res call({
    double? low,
    double? mid,
    double? high,
    double? market,
    double? directLow,
  });
}

/// @nodoc
class _$TcgplayerPricesCopyWithImpl<$Res, $Val extends TcgplayerPrices>
    implements $TcgplayerPricesCopyWith<$Res> {
  _$TcgplayerPricesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TcgplayerPrices
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? low = freezed,
    Object? mid = freezed,
    Object? high = freezed,
    Object? market = freezed,
    Object? directLow = freezed,
  }) {
    return _then(
      _value.copyWith(
            low: freezed == low
                ? _value.low
                : low // ignore: cast_nullable_to_non_nullable
                      as double?,
            mid: freezed == mid
                ? _value.mid
                : mid // ignore: cast_nullable_to_non_nullable
                      as double?,
            high: freezed == high
                ? _value.high
                : high // ignore: cast_nullable_to_non_nullable
                      as double?,
            market: freezed == market
                ? _value.market
                : market // ignore: cast_nullable_to_non_nullable
                      as double?,
            directLow: freezed == directLow
                ? _value.directLow
                : directLow // ignore: cast_nullable_to_non_nullable
                      as double?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TcgplayerPricesImplCopyWith<$Res>
    implements $TcgplayerPricesCopyWith<$Res> {
  factory _$$TcgplayerPricesImplCopyWith(
    _$TcgplayerPricesImpl value,
    $Res Function(_$TcgplayerPricesImpl) then,
  ) = __$$TcgplayerPricesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    double? low,
    double? mid,
    double? high,
    double? market,
    double? directLow,
  });
}

/// @nodoc
class __$$TcgplayerPricesImplCopyWithImpl<$Res>
    extends _$TcgplayerPricesCopyWithImpl<$Res, _$TcgplayerPricesImpl>
    implements _$$TcgplayerPricesImplCopyWith<$Res> {
  __$$TcgplayerPricesImplCopyWithImpl(
    _$TcgplayerPricesImpl _value,
    $Res Function(_$TcgplayerPricesImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TcgplayerPrices
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? low = freezed,
    Object? mid = freezed,
    Object? high = freezed,
    Object? market = freezed,
    Object? directLow = freezed,
  }) {
    return _then(
      _$TcgplayerPricesImpl(
        low: freezed == low
            ? _value.low
            : low // ignore: cast_nullable_to_non_nullable
                  as double?,
        mid: freezed == mid
            ? _value.mid
            : mid // ignore: cast_nullable_to_non_nullable
                  as double?,
        high: freezed == high
            ? _value.high
            : high // ignore: cast_nullable_to_non_nullable
                  as double?,
        market: freezed == market
            ? _value.market
            : market // ignore: cast_nullable_to_non_nullable
                  as double?,
        directLow: freezed == directLow
            ? _value.directLow
            : directLow // ignore: cast_nullable_to_non_nullable
                  as double?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TcgplayerPricesImpl implements _TcgplayerPrices {
  const _$TcgplayerPricesImpl({
    this.low,
    this.mid,
    this.high,
    this.market,
    this.directLow,
  });

  factory _$TcgplayerPricesImpl.fromJson(Map<String, dynamic> json) =>
      _$$TcgplayerPricesImplFromJson(json);

  @override
  final double? low;
  @override
  final double? mid;
  @override
  final double? high;
  @override
  final double? market;
  @override
  final double? directLow;

  @override
  String toString() {
    return 'TcgplayerPrices(low: $low, mid: $mid, high: $high, market: $market, directLow: $directLow)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TcgplayerPricesImpl &&
            (identical(other.low, low) || other.low == low) &&
            (identical(other.mid, mid) || other.mid == mid) &&
            (identical(other.high, high) || other.high == high) &&
            (identical(other.market, market) || other.market == market) &&
            (identical(other.directLow, directLow) ||
                other.directLow == directLow));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, low, mid, high, market, directLow);

  /// Create a copy of TcgplayerPrices
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TcgplayerPricesImplCopyWith<_$TcgplayerPricesImpl> get copyWith =>
      __$$TcgplayerPricesImplCopyWithImpl<_$TcgplayerPricesImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TcgplayerPricesImplToJson(this);
  }
}

abstract class _TcgplayerPrices implements TcgplayerPrices {
  const factory _TcgplayerPrices({
    final double? low,
    final double? mid,
    final double? high,
    final double? market,
    final double? directLow,
  }) = _$TcgplayerPricesImpl;

  factory _TcgplayerPrices.fromJson(Map<String, dynamic> json) =
      _$TcgplayerPricesImpl.fromJson;

  @override
  double? get low;
  @override
  double? get mid;
  @override
  double? get high;
  @override
  double? get market;
  @override
  double? get directLow;

  /// Create a copy of TcgplayerPrices
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TcgplayerPricesImplCopyWith<_$TcgplayerPricesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Cardmarket _$CardmarketFromJson(Map<String, dynamic> json) {
  return _Cardmarket.fromJson(json);
}

/// @nodoc
mixin _$Cardmarket {
  String? get url => throw _privateConstructorUsedError;
  String? get updatedAt => throw _privateConstructorUsedError;
  CardmarketPrices? get prices => throw _privateConstructorUsedError;

  /// Serializes this Cardmarket to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Cardmarket
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CardmarketCopyWith<Cardmarket> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CardmarketCopyWith<$Res> {
  factory $CardmarketCopyWith(
    Cardmarket value,
    $Res Function(Cardmarket) then,
  ) = _$CardmarketCopyWithImpl<$Res, Cardmarket>;
  @useResult
  $Res call({String? url, String? updatedAt, CardmarketPrices? prices});

  $CardmarketPricesCopyWith<$Res>? get prices;
}

/// @nodoc
class _$CardmarketCopyWithImpl<$Res, $Val extends Cardmarket>
    implements $CardmarketCopyWith<$Res> {
  _$CardmarketCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Cardmarket
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = freezed,
    Object? updatedAt = freezed,
    Object? prices = freezed,
  }) {
    return _then(
      _value.copyWith(
            url: freezed == url
                ? _value.url
                : url // ignore: cast_nullable_to_non_nullable
                      as String?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as String?,
            prices: freezed == prices
                ? _value.prices
                : prices // ignore: cast_nullable_to_non_nullable
                      as CardmarketPrices?,
          )
          as $Val,
    );
  }

  /// Create a copy of Cardmarket
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CardmarketPricesCopyWith<$Res>? get prices {
    if (_value.prices == null) {
      return null;
    }

    return $CardmarketPricesCopyWith<$Res>(_value.prices!, (value) {
      return _then(_value.copyWith(prices: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CardmarketImplCopyWith<$Res>
    implements $CardmarketCopyWith<$Res> {
  factory _$$CardmarketImplCopyWith(
    _$CardmarketImpl value,
    $Res Function(_$CardmarketImpl) then,
  ) = __$$CardmarketImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? url, String? updatedAt, CardmarketPrices? prices});

  @override
  $CardmarketPricesCopyWith<$Res>? get prices;
}

/// @nodoc
class __$$CardmarketImplCopyWithImpl<$Res>
    extends _$CardmarketCopyWithImpl<$Res, _$CardmarketImpl>
    implements _$$CardmarketImplCopyWith<$Res> {
  __$$CardmarketImplCopyWithImpl(
    _$CardmarketImpl _value,
    $Res Function(_$CardmarketImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Cardmarket
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = freezed,
    Object? updatedAt = freezed,
    Object? prices = freezed,
  }) {
    return _then(
      _$CardmarketImpl(
        url: freezed == url
            ? _value.url
            : url // ignore: cast_nullable_to_non_nullable
                  as String?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as String?,
        prices: freezed == prices
            ? _value.prices
            : prices // ignore: cast_nullable_to_non_nullable
                  as CardmarketPrices?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CardmarketImpl implements _Cardmarket {
  const _$CardmarketImpl({this.url, this.updatedAt, this.prices});

  factory _$CardmarketImpl.fromJson(Map<String, dynamic> json) =>
      _$$CardmarketImplFromJson(json);

  @override
  final String? url;
  @override
  final String? updatedAt;
  @override
  final CardmarketPrices? prices;

  @override
  String toString() {
    return 'Cardmarket(url: $url, updatedAt: $updatedAt, prices: $prices)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CardmarketImpl &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.prices, prices) || other.prices == prices));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, url, updatedAt, prices);

  /// Create a copy of Cardmarket
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CardmarketImplCopyWith<_$CardmarketImpl> get copyWith =>
      __$$CardmarketImplCopyWithImpl<_$CardmarketImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CardmarketImplToJson(this);
  }
}

abstract class _Cardmarket implements Cardmarket {
  const factory _Cardmarket({
    final String? url,
    final String? updatedAt,
    final CardmarketPrices? prices,
  }) = _$CardmarketImpl;

  factory _Cardmarket.fromJson(Map<String, dynamic> json) =
      _$CardmarketImpl.fromJson;

  @override
  String? get url;
  @override
  String? get updatedAt;
  @override
  CardmarketPrices? get prices;

  /// Create a copy of Cardmarket
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CardmarketImplCopyWith<_$CardmarketImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CardmarketPrices _$CardmarketPricesFromJson(Map<String, dynamic> json) {
  return _CardmarketPrices.fromJson(json);
}

/// @nodoc
mixin _$CardmarketPrices {
  double? get averageSellPrice => throw _privateConstructorUsedError;
  double? get lowPrice => throw _privateConstructorUsedError;
  double? get trendPrice => throw _privateConstructorUsedError;

  /// Serializes this CardmarketPrices to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CardmarketPrices
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CardmarketPricesCopyWith<CardmarketPrices> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CardmarketPricesCopyWith<$Res> {
  factory $CardmarketPricesCopyWith(
    CardmarketPrices value,
    $Res Function(CardmarketPrices) then,
  ) = _$CardmarketPricesCopyWithImpl<$Res, CardmarketPrices>;
  @useResult
  $Res call({double? averageSellPrice, double? lowPrice, double? trendPrice});
}

/// @nodoc
class _$CardmarketPricesCopyWithImpl<$Res, $Val extends CardmarketPrices>
    implements $CardmarketPricesCopyWith<$Res> {
  _$CardmarketPricesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CardmarketPrices
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? averageSellPrice = freezed,
    Object? lowPrice = freezed,
    Object? trendPrice = freezed,
  }) {
    return _then(
      _value.copyWith(
            averageSellPrice: freezed == averageSellPrice
                ? _value.averageSellPrice
                : averageSellPrice // ignore: cast_nullable_to_non_nullable
                      as double?,
            lowPrice: freezed == lowPrice
                ? _value.lowPrice
                : lowPrice // ignore: cast_nullable_to_non_nullable
                      as double?,
            trendPrice: freezed == trendPrice
                ? _value.trendPrice
                : trendPrice // ignore: cast_nullable_to_non_nullable
                      as double?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CardmarketPricesImplCopyWith<$Res>
    implements $CardmarketPricesCopyWith<$Res> {
  factory _$$CardmarketPricesImplCopyWith(
    _$CardmarketPricesImpl value,
    $Res Function(_$CardmarketPricesImpl) then,
  ) = __$$CardmarketPricesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double? averageSellPrice, double? lowPrice, double? trendPrice});
}

/// @nodoc
class __$$CardmarketPricesImplCopyWithImpl<$Res>
    extends _$CardmarketPricesCopyWithImpl<$Res, _$CardmarketPricesImpl>
    implements _$$CardmarketPricesImplCopyWith<$Res> {
  __$$CardmarketPricesImplCopyWithImpl(
    _$CardmarketPricesImpl _value,
    $Res Function(_$CardmarketPricesImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CardmarketPrices
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? averageSellPrice = freezed,
    Object? lowPrice = freezed,
    Object? trendPrice = freezed,
  }) {
    return _then(
      _$CardmarketPricesImpl(
        averageSellPrice: freezed == averageSellPrice
            ? _value.averageSellPrice
            : averageSellPrice // ignore: cast_nullable_to_non_nullable
                  as double?,
        lowPrice: freezed == lowPrice
            ? _value.lowPrice
            : lowPrice // ignore: cast_nullable_to_non_nullable
                  as double?,
        trendPrice: freezed == trendPrice
            ? _value.trendPrice
            : trendPrice // ignore: cast_nullable_to_non_nullable
                  as double?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CardmarketPricesImpl implements _CardmarketPrices {
  const _$CardmarketPricesImpl({
    this.averageSellPrice,
    this.lowPrice,
    this.trendPrice,
  });

  factory _$CardmarketPricesImpl.fromJson(Map<String, dynamic> json) =>
      _$$CardmarketPricesImplFromJson(json);

  @override
  final double? averageSellPrice;
  @override
  final double? lowPrice;
  @override
  final double? trendPrice;

  @override
  String toString() {
    return 'CardmarketPrices(averageSellPrice: $averageSellPrice, lowPrice: $lowPrice, trendPrice: $trendPrice)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CardmarketPricesImpl &&
            (identical(other.averageSellPrice, averageSellPrice) ||
                other.averageSellPrice == averageSellPrice) &&
            (identical(other.lowPrice, lowPrice) ||
                other.lowPrice == lowPrice) &&
            (identical(other.trendPrice, trendPrice) ||
                other.trendPrice == trendPrice));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, averageSellPrice, lowPrice, trendPrice);

  /// Create a copy of CardmarketPrices
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CardmarketPricesImplCopyWith<_$CardmarketPricesImpl> get copyWith =>
      __$$CardmarketPricesImplCopyWithImpl<_$CardmarketPricesImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CardmarketPricesImplToJson(this);
  }
}

abstract class _CardmarketPrices implements CardmarketPrices {
  const factory _CardmarketPrices({
    final double? averageSellPrice,
    final double? lowPrice,
    final double? trendPrice,
  }) = _$CardmarketPricesImpl;

  factory _CardmarketPrices.fromJson(Map<String, dynamic> json) =
      _$CardmarketPricesImpl.fromJson;

  @override
  double? get averageSellPrice;
  @override
  double? get lowPrice;
  @override
  double? get trendPrice;

  /// Create a copy of CardmarketPrices
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CardmarketPricesImplCopyWith<_$CardmarketPricesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
