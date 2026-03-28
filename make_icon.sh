#!/bin/bash
IMG="/Users/vanthien113/.gemini/antigravity/brain/9adaaeb0-dd75-4ae1-adb5-c56ce34f06e8/app_icon_clean_1774698360361.png"
mkdir -p AppIcon.iconset

sips -z 16 16 "$IMG" -s format png --out AppIcon.iconset/icon_16x16.png
sips -z 32 32 "$IMG" -s format png --out AppIcon.iconset/icon_16x16@2x.png
sips -z 32 32 "$IMG" -s format png --out AppIcon.iconset/icon_32x32.png
sips -z 64 64 "$IMG" -s format png --out AppIcon.iconset/icon_32x32@2x.png
sips -z 128 128 "$IMG" -s format png --out AppIcon.iconset/icon_128x128.png
sips -z 256 256 "$IMG" -s format png --out AppIcon.iconset/icon_128x128@2x.png
sips -z 256 256 "$IMG" -s format png --out AppIcon.iconset/icon_256x256.png
sips -z 512 512 "$IMG" -s format png --out AppIcon.iconset/icon_256x256@2x.png
sips -z 512 512 "$IMG" -s format png --out AppIcon.iconset/icon_512x512.png
sips -z 1024 1024 "$IMG" -s format png --out AppIcon.iconset/icon_512x512@2x.png

iconutil -c icns AppIcon.iconset
rm -rf AppIcon.iconset
