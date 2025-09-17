#!/bin/bash

# Script to build all icon formats from a source PNG
# Usage: ./scripts/build-icons.sh [source-image.png]

SOURCE="${1:-resources/icon.png}"
ICONSET_DIR="resources/icon.iconset"

if [ ! -f "$SOURCE" ]; then
    echo "Error: Source image not found: $SOURCE"
    exit 1
fi

echo "Building icons from: $SOURCE"

# Create iconset directory
mkdir -p "$ICONSET_DIR"

# Generate all required icon sizes for macOS
echo "Creating macOS iconset..."
magick "$SOURCE" -resize 16x16     "$ICONSET_DIR/icon_16x16.png"
magick "$SOURCE" -resize 32x32     "$ICONSET_DIR/icon_16x16@2x.png"
magick "$SOURCE" -resize 32x32     "$ICONSET_DIR/icon_32x32.png"
magick "$SOURCE" -resize 64x64     "$ICONSET_DIR/icon_32x32@2x.png"
magick "$SOURCE" -resize 128x128   "$ICONSET_DIR/icon_128x128.png"
magick "$SOURCE" -resize 256x256   "$ICONSET_DIR/icon_128x128@2x.png"
magick "$SOURCE" -resize 256x256   "$ICONSET_DIR/icon_256x256.png"
magick "$SOURCE" -resize 512x512   "$ICONSET_DIR/icon_256x256@2x.png"
magick "$SOURCE" -resize 512x512   "$ICONSET_DIR/icon_512x512.png"
magick "$SOURCE" -resize 1024x1024 "$ICONSET_DIR/icon_512x512@2x.png"

# Build the .icns file
echo "Building icon.icns..."
iconutil -c icns "$ICONSET_DIR" -o resources/icon.icns

# Generate Windows icon
echo "Building Windows icon.ico..."
magick "$SOURCE" -resize 16x16   resources/icon-16.png
magick "$SOURCE" -resize 32x32   resources/icon-32.png
magick "$SOURCE" -resize 48x48   resources/icon-48.png
magick "$SOURCE" -resize 64x64   resources/icon-64.png
magick "$SOURCE" -resize 128x128 resources/icon-128.png
magick "$SOURCE" -resize 256x256 resources/icon-256.png

# Combine into ICO file
magick resources/icon-16.png resources/icon-32.png resources/icon-48.png \
       resources/icon-64.png resources/icon-128.png resources/icon-256.png \
       resources/icon.ico

# Clean up temporary files
rm -f resources/icon-*.png

# Generate Linux icon (just copy the PNG)
echo "Copying Linux icon..."
cp "$SOURCE" resources/icon.png

echo "✅ All icons generated successfully!"
echo ""
echo "Generated files:"
echo "  - resources/icon.icns (macOS)"
echo "  - resources/icon.ico (Windows)"
echo "  - resources/icon.png (Linux)"
echo "  - resources/icon.iconset/ (macOS iconset folder)"