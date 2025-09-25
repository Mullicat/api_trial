# lib/scripts/onepiece_extraction_filter_enums.py
import os
import json
from supabase import create_client, Client
from dotenv import load_dotenv
from collections import defaultdict
import re

# Load environment variables
load_dotenv()
SUPABASE_URL = os.getenv('SUPABASE_URL')
SUPABASE_KEY = os.getenv('SUPABASE_SECRET_KEY')

if not SUPABASE_URL or not SUPABASE_KEY:
    raise ValueError("Supabase credentials not found in .env")

# Initialize Supabase client
supabase: Client = create_client(SUPABASE_URL, SUPABASE_KEY)

# Function to convert string to camelCase for Dart enums
def to_camel_case(value: str, field: str) -> str:
    if field == 'counter' and not value:
        return "none"  # Empty string for counter -> none
    if field == 'trigger':
        return "hasTrigger" if value == "true" else "noTrigger"  # Handle true/false
    # Handle numeric values for cost, power, counter
    if field in ['cost', 'power', 'counter'] and re.match(r'^\d+$', value):
        prefix = 'cost' if field == 'cost' else 'power' if field == 'power' else 'counter'
        return f"{prefix}{value}"
    # Generate camelCase identifier
    cleaned = re.sub(r'[^a-zA-Z0-9\s]', '', value).replace(' ', '_').lower()
    parts = cleaned.split('_')
    if len(parts) == 1:
        identifier = parts[0]
    else:
        identifier = parts[0] + ''.join(p.capitalize() for p in parts[1:])
    # For set_name, prepend 'set' if identifier starts with a digit
    if field == 'set_name' and re.match(r'^\d', identifier):
        return f"set{identifier}"
    return identifier

# Function to capitalize field name for enum (e.g., set_name -> SetName)
def to_pascal_case(field: str) -> str:
    return ''.join(word.capitalize() for word in field.split('_'))

# Function to fetch unique values for a text field
def get_unique_text_field(field: str) -> set:
    try:
        response = supabase.rpc('get_distinct_text', {'field': field}).execute()
        # Exclude empty strings for set_name
        return {row['value'] for row in response.data if row['value'] is not None and (field != 'set_name' or row['value'] != '')}
    except Exception as e:
        print(f"Error fetching unique {field}: {e}")
        return set()

# Function to fetch unique values for a JSONB field (string or array)
def get_unique_jsonb_field(field: str, is_array: bool = False) -> set:
    try:
        func = 'get_distinct_jsonb_array' if is_array else 'get_distinct_jsonb'
        response = supabase.rpc(func, {'field': field}).execute()
        uniques = {row['value'] for row in response.data if row['value'] is not None}
        # For family, filter invalid values (non-alphanumeric or empty)
        if field == 'family':
            uniques = {v for v in uniques if re.match(r'^[a-zA-Z0-9\s\-]+$', v)}
        # For counter, map "" to "None"
        if field == 'counter':
            if '' in uniques:
                uniques.discard('')
                uniques.add('None')
        return uniques
    except Exception as e:
        print(f"Error fetching unique {field}: {e}")
        return set()

# Function to check if trigger exists
def get_trigger_values() -> set:
    try:
        response = supabase.rpc('get_distinct_trigger').execute()
        return {row['value'] for row in response.data}
    except Exception as e:
        print(f"Error fetching unique trigger: {e}")
        return {'true', 'false'}

# Main function to extract uniques and generate Dart enums
def main():
    # Fields to process
    fields = {
        'set_name': {'type': 'text', 'is_array': False},
        'rarity': {'type': 'text', 'is_array': False},
        'cost': {'type': 'jsonb', 'is_array': False},
        'type': {'type': 'jsonb', 'is_array': False},
        'color': {'type': 'jsonb', 'is_array': False},
        'power': {'type': 'jsonb', 'is_array': False},
        'family': {'type': 'jsonb', 'is_array': True},
        'counter': {'type': 'jsonb', 'is_array': False},
        'trigger': {'type': 'boolean', 'is_array': False},
    }

    uniques = defaultdict(set)

    # Fetch unique values for each field
    for field, config in fields.items():
        if config['type'] == 'text':
            uniques[field] = get_unique_text_field(field)
        elif config['type'] == 'jsonb':
            uniques[field] = get_unique_jsonb_field(field, config['is_array'])
        elif config['type'] == 'boolean':
            uniques[field] = get_trigger_values()

    # Generate Dart enums
    dart_output = ["// lib/constants/enums/onepiece_filters.dart", ""]
    for field, values in uniques.items():
        if not values:
            print(f"No values found for {field}")
            continue
        enum_name = to_pascal_case(field)
        dart_values = [to_camel_case(v, field) for v in sorted(values)]
        dart_output.append(f"enum {enum_name} {{")
        for original, camel in zip(sorted(values), dart_values):
            # Escape single quotes in original value
            escaped_value = original.replace("'", "\\'")
            dart_output.append(f"  {camel}('{escaped_value}'),")
        dart_output.append("  ;")
        dart_output.append(f"  final String value;")
        dart_output.append(f"  const {enum_name}(this.value);")

        # Add displayName getter for counter and trigger
        if field in ['counter', 'trigger']:
            dart_output.append(f"  String get displayName {{")
            dart_output.append("    switch (this) {")
            for original, camel in zip(sorted(values), dart_values):
                if field == 'counter' and original == 'None':
                    dart_output.append(f"      case {enum_name}.none:")
                    dart_output.append(f"        return 'None';")
                elif field == 'trigger' and original == 'true':
                    dart_output.append(f"      case {enum_name}.{camel}:")
                    dart_output.append(f"        return 'Trigger';")
                elif field == 'trigger' and original == 'false':
                    dart_output.append(f"      case {enum_name}.{camel}:")
                    dart_output.append(f"        return 'No Trigger';")
                else:
                    dart_output.append(f"      case {enum_name}.{camel}:")
                    dart_output.append(f"        return value;")
            dart_output.append("    }")
            dart_output.append("  }")
        dart_output.append("}\n")

    # Write Dart enums to a .txt file
    with open('onepiece_filters.txt', 'w', encoding='utf-8') as f:
        f.write('\n'.join(dart_output))
    print("\nDart enums saved to onepiece_filters.txt")

    # Save as JSON for reference
    json_output = {field: sorted(list(values)) for field, values in uniques.items()}
    with open('unique_values.json', 'w', encoding='utf-8') as f:
        json.dump(json_output, f, indent=2, ensure_ascii=False)
    print("Unique values saved to unique_values.json")

if __name__ == "__main__":
    main()