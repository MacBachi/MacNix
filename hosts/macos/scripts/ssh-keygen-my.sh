#!/usr/bin/env bash

# === SSH Key Generator ===
# Erstellt einen neuen ed25519 SSH-Key mit einem dynamischen Kommentar
# und einem eindeutigen Dateinamen und erstellt Symlinks darauf.

# Stellt sicher, dass das Skript bei einem Fehler abbricht
set -e

# --- Variablen ---
KEY_TYPE="ed25519"
SSH_DIR="$HOME/.ssh"
HOSTNAME=$(hostname -s) # Holt den kurzen Hostnamen
DATE=$(date +%Y-%m-%d)
EMAIL="${HOSTNAME}@guggug.at-${DATE}"
EMAIL_USER=$(echo "$EMAIL" | cut -d'@' -f1)
USERNAME=$(whoami)

# --- Kommentar und Dateipfad zusammensetzen ---
COMMENT="${EMAIL_USER}@${HOSTNAME}_${USERNAME}_${DATE}"
KEY_FILENAME="id_${KEY_TYPE}_${HOSTNAME}_${DATE}"
KEY_PATH="${SSH_DIR}/${KEY_FILENAME}"

# --- Hauptlogik ---
echo "🔑 Erstelle einen neuen ${KEY_TYPE} SSH-Key..."
echo "   - Kommentar: ${COMMENT}"
echo "   - Speicherort: ${KEY_PATH}"
echo ""

# Führe ssh-keygen aus. Die Anführungszeichen sind wichtig für die Robustheit.
ssh-keygen -t "${KEY_TYPE}" -C "${COMMENT}" -f "${KEY_PATH}"

# --- Symlinks erstellen ---
echo "🔗 Erstelle Symlinks 'defaultKey' und 'defaultKey.pub'..."
# Die Option -s erstellt einen symbolischen Link, -f überschreibt ihn, falls er existiert.
ln -sf "${KEY_PATH}" "${SSH_DIR}/defaultKey"
ln -sf "${KEY_PATH}.pub" "${SSH_DIR}/defaultKey.pub"

# --- Erfolgsmeldung ---
echo ""
echo "✅ Fertig!"
echo "Dein neuer privater Schlüssel ist hier: ${KEY_PATH}"
echo "Dein neuer öffentlicher Schlüssel ist hier: ${KEY_PATH}.pub"
echo "   -> Symlinks 'defaultKey' und 'defaultKey.pub' zeigen nun auf diese Dateien."
echo ""
echo "WICHTIG: Sichere deinen privaten Schlüssel an einem sicheren Ort (z.B. Passwort-Manager)."
echo "         Füge den Inhalt von '${KEY_FILENAME}.pub' zu GitHub, GitLab etc. hinzu."
