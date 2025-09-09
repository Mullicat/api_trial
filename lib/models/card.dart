// lib/models/card.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart'; // Optional, for devtools support

part 'card.freezed.dart';
part 'card.g.dart';

@freezed
abstract class TCGCard with _$TCGCard {
  const factory TCGCard({
    required String id, // App-unique ID (e.g., UUID or gameType-gameCode)
    required String gameCode, // API-specific ID (e.g., 'swsh4-25', '6983839')
    required String name, // Card name (e.g., 'Charizard', 'Tornado Dragon')
    required String
    gameType, // e.g., 'pokemon', 'yugioh', 'magic', 'optcg', 'dragonball', 'digimon', 'unionarena', 'gundam'
    String? setName, // e.g., 'Vivid Voltage', 'Battles of Legend'
    String? rarity, // e.g., 'Rare', 'Mythic Rare'
    String? imageRefSmall, // Supabase bucket path for small image (grid view)
    String? imageRefLarge, // Supabase bucket path for large image (detail view)
    DateTime? lastUpdated, // Timestamp of last update
    List<double>? imageEmbedding, // pgvector embedding for image searches
    List<double>? textEmbedding, // pgvector embedding for text searches
    Map<String, dynamic>? gameSpecificData, // JSONB for game-specific fields
  }) = _TCGCard;

  factory TCGCard.fromJson(Map<String, dynamic> json) =>
      _$TCGCardFromJson(json);
}
