import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/card.dart';
import '../services/onepiece_service.dart';
import '../screens/screen_single.dart';
import '../constants/enums/game_type.dart';
import '../constants/enums/onepiece_filters.dart';

class ScanResultsScreen extends StatelessWidget {
  final String title;
  final List<TCGCard> cards;
  final OnePieceTcgService service;

  const ScanResultsScreen({
    super.key,
    required this.title,
    required this.cards,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title.isEmpty ? 'Scan Results' : title)),
      body: cards.isEmpty
          ? const Center(child: Text('No cards found. Please rescan.'))
          : ListView.separated(
              itemCount: cards.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final c = cards[index];
                return ListTile(
                  leading:
                      (c.imageRefSmall != null && c.imageRefSmall!.isNotEmpty)
                      ? CachedNetworkImage(
                          imageUrl: c.imageRefSmall!,
                          width: 56,
                          height: 56,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.broken_image),
                        )
                      : const Icon(Icons.image_not_supported),
                  title: Text(c.name ?? 'Unknown'),
                  subtitle: Text(
                    [
                      if (c.setName != null && c.setName!.isNotEmpty)
                        c.setName!,
                      if (c.rarity != null && c.rarity!.isNotEmpty) c.rarity!,
                      if (c.gameCode != null && c.gameCode!.isNotEmpty)
                        c.gameCode!,
                    ].join(' • '),
                  ),
                  onTap: () {
                    if (c.id == null || c.id!.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Invalid card id')),
                      );
                      return;
                    }
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ScreenSingle(
                          id: c.id!, // Supabase UUID
                          gameType: GameType.onePiece,
                          service: service,
                          getCardType: GetCardType.fromSupabase,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
