import 'package:freezed_annotation/freezed_annotation.dart';

part 'card.freezed.dart';
part 'card.g.dart';

@freezed
abstract class TCGCard with _$TCGCard {
  factory TCGCard({
    required String id,
    required String gameCode,
    required String name,
    required String gameType,
    String? version,
    String? setName,
    String? rarity,
    String? imageRefSmall,
    String? imageRefLarge,
    List<double>? imageEmbedding,
    List<double>? textEmbedding,
    Map<String, dynamic>? gameSpecificData,
  }) = _TCGCard;

  factory TCGCard.fromJson(Map<String, dynamic> json) =>
      _$TCGCardFromJson(json);
}
