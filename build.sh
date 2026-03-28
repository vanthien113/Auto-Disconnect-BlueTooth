#!/bin/bash
TARGET="DisconnectBL"
APP_DIR="${TARGET}.app"
MAC_OS_DIR="${APP_DIR}/Contents/MacOS"
RESOURCES_DIR="${APP_DIR}/Contents/Resources"

# Clean
rm -rf "${APP_DIR}"

mkdir -p "${MAC_OS_DIR}"
mkdir -p "${RESOURCES_DIR}"

echo "Compiling swift files..."
swiftc Sources/*.swift \
    -o "${MAC_OS_DIR}/${TARGET}" \
    -framework Cocoa \
    -framework IOBluetooth \
    -framework SwiftUI \
    -target arm64-apple-macosx13.0

# Generate Info.plist
cat <<EOF > "${APP_DIR}/Contents/Info.plist"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>${TARGET}</string>
    <key>CFBundleIconFile</key>
    <string>AppIcon</string>
    <key>CFBundleIdentifier</key>
    <string>com.vanthien113.${TARGET}</string>
    <key>CFBundleName</key>
    <string>${TARGET}</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleVersion</key>
    <string>1.0</string>
    <key>LSUIElement</key>
    <true/>
    <key>NSBluetoothAlwaysUsageDescription</key>
    <string>The app needs Bluetooth access to disconnect and reconnect your selected device automatically.</string>
</dict>
</plist>
EOF

echo "Copying resources..."
if [ -f "AppIcon.icns" ]; then
    cp AppIcon.icns "${RESOURCES_DIR}/"
fi

echo "Signing app..."
codesign --force --deep -s - "${APP_DIR}"

echo "Done building ${APP_DIR}!"
