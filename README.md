# Locket

Locket is an iOS app for saving photos, details, and memories about the people closest to you.

## Requirements

- Xcode 27 with the iOS 27 SDK and an iPhone Simulator runtime
- macOS with Xcode command-line tools selected
- VS Code with the recommended Swift and CodeLLDB extensions

The app uses the iOS 27 SDK while retaining iOS 18 as its minimum deployment target.

## Run from VS Code

1. Open this repository folder in VS Code and install the recommended extensions when prompted.
2. Open **Run and Debug**, select **Locket: Build and Run iOS Simulator**, and press the play button (or press `F5`).
3. The task selects an already-booted iPhone simulator, or boots the first available iPhone, then builds, installs, and launches Locket.

`Cmd+Shift+B` runs the same default build task. To target a particular simulator, set `LOCKET_SIMULATOR_UDID` in the terminal environment before starting VS Code.

If Xcode is installed somewhere other than `/Applications/Xcode-beta.app`, set `DEVELOPER_DIR` to its `Contents/Developer` directory and update `swift.path` and `lldb.library` in `.vscode/settings.json`.

## Command-line build

```sh
xcodebuild \
  -project Locket.xcodeproj \
  -scheme Locket \
  -sdk iphonesimulator \
  -destination 'generic/platform=iOS Simulator' \
  -derivedDataPath .build/DerivedData \
  CODE_SIGNING_ALLOWED=NO \
  build
```
