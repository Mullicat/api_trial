import os
import json
from supabase import create_client, Client
from dotenv import load_dotenv
from collections import defaultdict

load_dotenv()

# Supabase credentials
SUPABASE_URL = os.getenv('SUPABASE_URL')
SUPABASE_KEY = os.getenv('SUPABASE_SECRET_KEY')

if not SUPABASE_URL or not SUPABASE_KEY:
    raise ValueError("Supabase credentials not found in .env")

supabase: Client = create_client(SUPABASE_URL, SUPABASE_KEY)

# Directory with JSONs
DATA_DIR = '../data/gameData'

# Game-type mapping
GAME_TYPES = {
    'onepiece': 'onepiece',
    'dragonball': 'dragonball',
    'gundam': 'gundam',
    'digimon': 'digimon',
    'unionarena': 'unionarena',
}

# Global counters
stats = {
    "attempted": 0,
    "supabase_success": 0,
    "supabase_fail": 0,
    "local_duplicates": 0,
}

def parse_version(card_id, card_code):
    if card_id == card_code:
        return 'standard'
    suffix = card_id.replace(card_code, '').lstrip('_').lower()
    return suffix if suffix else 'standard'

def check_duplicates(cards):
    """Check duplicates locally based on rule."""
    seen = defaultdict(list)
    duplicates = []

    for card in cards:
        key = (
            card['game_code'],
            card['game_type'],
            card['set_name'],
            card['image_ref_small']
        )
        if key in seen:
            duplicates.append(card)
        seen[key].append(card)

    if duplicates:
        print("\n⚠️ Local duplicates detected (rejected by rule):")
        for card in duplicates[:10]:  # preview first 10
            print(f" - {card['game_code']} | {card['name']} | {card['set_name']}")

    stats["local_duplicates"] += len(duplicates)
    return duplicates

def process_json(game_folder, json_file):
    file_path = os.path.join(DATA_DIR, game_folder, json_file)
    if not os.path.exists(file_path):
        return []

    with open(file_path, 'r', encoding='utf-8') as f:
        try:
            data = json.load(f)
        except json.JSONDecodeError as e:
            print(f"❌ Error decoding JSON {file_path}: {e}")
            return []

    card_list = data if isinstance(data, list) else data.get('data', [])
    cards_data = []

    for card_json in card_list:
        try:
            game_code = card_json.get('code', card_json.get('id', 'unknown'))
            card_id = card_json.get('id', game_code)
            version = parse_version(card_id, game_code)

            # Remove query parameters from image URLs
            image_ref_small = card_json.get('images', {}).get('small', '')
            image_ref_large = card_json.get('images', {}).get('large', '')
            normalized_image_ref_small = image_ref_small.split('?')[0] if image_ref_small else ''
            normalized_image_ref_large = image_ref_large.split('?')[0] if image_ref_large else ''

            card = {
                'game_code': game_code,
                'name': card_json.get('name', 'Unknown Card'),
                'game_type': GAME_TYPES.get(game_folder, game_folder),
                'version': version,
                'set_name': card_json.get('set', {}).get('name', ''),
                'rarity': card_json.get('rarity', ''),
                'image_ref_small': normalized_image_ref_small,
                'image_ref_large': normalized_image_ref_large,
                'game_specific_data': {
                    k: v for k, v in card_json.items()
                    if k not in ['id', 'code', 'name', 'rarity', 'set', 'images']
                },
            }
            if 'set' in card_json:
                card['game_specific_data']['set_id'] = card_json['set'].get('id', '')

            cards_data.append(card)
        except Exception as e:
            print(f"❌ Error processing card in {json_file}: {e}")

    stats["attempted"] += len(cards_data)
    return cards_data

def upsert_to_supabase(cards, batch_size=500):
    if not cards:
        return

    # Remove local duplicates
    duplicates = check_duplicates(cards)
    valid_cards = [c for c in cards if c not in duplicates]

    def process_batch(batch):
        try:
            response = (
                supabase.table("cards")
                .upsert(
                    batch,
                    on_conflict="game_code,game_type,set_name,image_ref_small",
                )
                .execute()
            )
            stats["supabase_success"] += len(batch)
        except Exception:
            stats["supabase_fail"] += len(batch)

            if len(batch) > 1:
                mid = len(batch) // 2
                process_batch(batch[:mid])
                process_batch(batch[mid:])
            else:
                # Already counted fail for this card
                pass

    for i in range(0, len(valid_cards), batch_size):
        process_batch(valid_cards[i:i + batch_size])

def main():
    for game_folder in GAME_TYPES.keys():
        game_dir = os.path.join(DATA_DIR, game_folder)
        if not os.path.exists(game_dir):
            continue

        all_cards = []
        for json_file in os.listdir(game_dir):
            if json_file.endswith('.json'):
                all_cards.extend(process_json(game_folder, json_file))

        if all_cards:
            upsert_to_supabase(all_cards)

    # Final summary
    print("\n📊 Import Summary:")
    print(f" - Attempted (from JSON): {stats['attempted']}")
    print(f" - Inserted/Upserted in Supabase: {stats['supabase_success']}")
    print(f" - Failed in Supabase: {stats['supabase_fail']}")
    print(f" - Rejected by local rule (duplicates): {stats['local_duplicates']}")

if __name__ == "__main__":
    main()