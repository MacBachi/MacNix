#!/bin/bash

# Liest alle Domains als eine einzelne, kommagetrennte Zeichenkette
domains=$(defaults domains)

# Setzt den internen Feldseparator auf ein Komma, um die Zeichenkette zu splitten
IFS=','

# Iteriert über jede Domain
for domain in $domains
do
  # Entfernt führende Leerzeichen
  domain=$(echo "$domain" | xargs)

  # Gibt den formatierten Header für die Domain aus
  echo ""
  echo "🍎💻 DOMAIN: $domain 💻🍎"
  echo "----------------------------------------"

  # Liest alle Einstellungen für die Domain und gibt jede in einer neuen Zeile aus
  defaults read "$domain" 2>/dev/null
done

# Setzt den internen Feldseparator auf den Standardwert zurück
unset IFS

