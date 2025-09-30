// lib/models/card.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'card.freezed.dart';
part 'card.g.dart';

@freezed
abstract class TCGCard with _$TCGCard {
  factory TCGCard({
    @JsonKey(name: 'id') required String? id,
    @JsonKey(name: 'game_code') required String? gameCode,
    @JsonKey(name: 'name') required String? name,
    @JsonKey(name: 'game_type') required String? gameType,
    @JsonKey(name: 'version') String? version,
    @JsonKey(name: 'set_name') String? setName,
    @JsonKey(name: 'rarity') String? rarity,
    @JsonKey(name: 'image_ref_small') String? imageRefSmall,
    @JsonKey(name: 'image_ref_large') String? imageRefLarge,
    @JsonKey(name: 'image_embedding') List<double>? imageEmbedding,
    @JsonKey(name: 'text_embedding') List<double>? textEmbedding,
    @JsonKey(name: 'game_specific_data') Map<String, dynamic>? gameSpecificData,
  }) = _TCGCard;

  factory TCGCard.fromJson(Map<String, dynamic> json) =>
      _$TCGCardFromJson(json);
}
