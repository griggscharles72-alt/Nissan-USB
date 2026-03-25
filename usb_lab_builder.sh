#!/usr/bin/env bash

# =========================================================
# USB LAB BUILDER — DETERMINISTIC + LAYERED
# =========================================================
# PURPOSE:
# Build a repeatable USB structure for media enumeration tests
#
# DESIGN:
# - Structure = fixed
# - Layers = toggled
# - MP3 = manually controlled (you own this layer)
#
# =========================================================

set -u

TARGET="${1:-/media/$USER/USB}"

echo "[*] Target: $TARGET"

# --- SAFETY CHECK ---
if [[ ! -d "$TARGET" ]]; then
    echo "[!] Target path does not exist"
    exit 1
fi

# --- CLEAN ---
echo "[*] Resetting USB..."
rm -rf "${TARGET:?}/"*

# --- CORE STRUCTURE ---
echo "[*] Building core structure..."

mkdir -p \
"$TARGET/MUSIC/Artist/Album" \
"$TARGET/PLAYLISTS" \
"$TARGET/PICTURES" \
"$TARGET/EXPERIMENT/A/B/C" \
"$TARGET/LOGS"

# --- ROOT FILE (ENUMERATION TRIGGER) ---
touch "$TARGET/random.mp3"

# --- CONTROL SLOTS (YOU REPLACE THESE) ---
touch "$TARGET/MUSIC/Artist/Album/01_control.mp3"
touch "$TARGET/MUSIC/Artist/Album/02_test.mp3"

# --- EXPERIMENT FILE ---
touch "$TARGET/EXPERIMENT/A/B/C/file.mp3"

# --- PLAYLIST ---
cat <<EOF > "$TARGET/PLAYLISTS/test.m3u"
../MUSIC/Artist/Album/01_control.mp3
../MUSIC/Artist/Album/02_test.mp3
../random.mp3
../EXPERIMENT/A/B/C/file.mp3
../missing.mp3
EOF

# =========================================================
# LAYER SWITCHES (EDIT THESE ONLY)
# =========================================================

ENABLE_IMAGES=1
ENABLE_CORRUPT=1
ENABLE_STRESS=0
ENABLE_HIDDEN=1

# --- LAYER: IMAGES ---
if [[ "$ENABLE_IMAGES" -eq 1 ]]; then
    echo "[*] Adding images..."
    dd if=/dev/zero of="$TARGET/PICTURES/image.jpg" bs=1K count=50 2>/dev/null
    dd if=/dev/zero of="$TARGET/PICTURES/large.jpg" bs=1K count=5000 2>/dev/null
fi

# --- LAYER: CORRUPT FILE ---
if [[ "$ENABLE_CORRUPT" -eq 1 ]]; then
    echo "[*] Adding corrupt image..."
    head -c 100 /dev/urandom > "$TARGET/PICTURES/broken.jpg"
fi

# --- LAYER: STRESS ---
if [[ "$ENABLE_STRESS" -eq 1 ]]; then
    echo "[*] Adding stress files..."
    for i in {1..300}; do
        touch "$TARGET/file_$i.txt"
    done
fi

# --- LAYER: HIDDEN ---
if [[ "$ENABLE_HIDDEN" -eq 1 ]]; then
    echo "[*] Adding hidden/system files..."
    touch "$TARGET/.DS_Store"
    touch "$TARGET/Thumbs.db"
    touch "$TARGET/.hidden"
fi

# --- COMPLETE ---
echo "[✓] Build complete."

echo ""
echo "================ NEXT STEPS ================"
echo "1. Replace:"
echo "   - 01_control.mp3"
echo "   - 02_test.mp3"
echo ""
echo "2. Keep control unchanged"
echo "3. Modify ONLY 02_test.mp3 per run"
echo ""
echo "4. Insert USB → let system index"
echo "5. Remove USB → run delta scanner"
echo "6. Repeat with ONE change only"
echo "============================================"
