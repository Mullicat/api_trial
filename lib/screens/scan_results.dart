// ============================================================================
// FILE: scan_results.dart
// PURPOSE: Simple results list after a scan/lookup returns multiple TCG cards.
// ARCHITECTURE: Stateless screen that receives data + service via constructor.
// NAVIGATION: Tapping a card opens ScreenSingle (details) using Supabase UUID.
// UX NOTES:
// - Shows a placeholder if no results.
// - Each row shows small art, name, and a compact meta line (set • rarity • code).
// - Uses CachedNetworkImage for lightweight image loading with a spinner.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../models/card.dart';
import '../services/onepiece_service.dart';
import '../screens/screen_single.dart';
import '../constants/enums/game_type.dart';
import '../constants/enums/onepiece_filters.dart';

// ============================================================================
// WIDGET: ScanResultsScreen
// ROLE: Display a selectable list of cards that matched the scan/search.
// INPUTS:
//   - title:    Optional title for the AppBar.
//   - cards:    The result set to render.
//   - service:  The OnePieceTcgService instance to pass along to details screen.
// ============================================================================
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
    // ------------------------------------------------------------------------
    // SCAFFOLD: AppBar + body
    // - Title falls back to "Scan Results" when empty.
    // - Body renders either a placeholder or a separated ListView of results.
    // ------------------------------------------------------------------------
    return Scaffold(
      appBar: AppBar(title: Text(title.isEmpty ? 'Scan Results' : title)),

      // ----------------------------------------------------------------------
      // EMPTY STATE: No results were found
      // ----------------------------------------------------------------------
      body: cards.isEmpty
          ? const Center(child: Text('No cards found. Please rescan.'))
          // ------------------------------------------------------------------
          // RESULTS LIST: One row per TCGCard
          // - leading: small cached image (or fallback icon)
          // - title:   card name
          // - subtitle: compact meta (set • rarity • game code), only if present
          // - onTap:  navigate to ScreenSingle using card.id (Supabase UUID)
          // ------------------------------------------------------------------
          : ListView.separated(
              itemCount: cards.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final c = cards[index];

                // Build a compact "•" separated subtitle from available fields.
                final subtitle = [
                  if (c.setName != null && c.setName!.isNotEmpty) c.setName!,
                  if (c.rarity != null && c.rarity!.isNotEmpty) c.rarity!,
                  if (c.gameCode != null && c.gameCode!.isNotEmpty) c.gameCode!,
                ].join(' • ');

                return ListTile(
                  // ----------------------------------------------------------
                  // LEADING: card image thumb (cached) or fallback icon
                  // ----------------------------------------------------------
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

                  // ----------------------------------------------------------
                  // TITLE + SUBTITLE
                  // ----------------------------------------------------------
                  title: Text(c.name ?? 'Unknown'),
                  subtitle: Text(subtitle),

                  // ----------------------------------------------------------
                  // TAP: open details screen
                  // Guard: require a valid Supabase UUID (c.id)
                  // ----------------------------------------------------------
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
