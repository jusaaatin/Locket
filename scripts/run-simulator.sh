#!/bin/zsh

set -euo pipefail

readonly project_root="${0:A:h:h}"
readonly derived_data_path="${project_root}/.build/DerivedData"
readonly source_packages_path="${project_root}/.build/SourcePackages"
readonly app_path="${derived_data_path}/Build/Products/Debug-iphonesimulator/Locket.app"
readonly bundle_identifier="jusaaatin.Locket"

if [[ -z "${DEVELOPER_DIR:-}" ]]; then
    if [[ -d /Applications/Xcode-beta.app/Contents/Developer ]]; then
        export DEVELOPER_DIR=/Applications/Xcode-beta.app/Contents/Developer
    else
        export DEVELOPER_DIR="$(xcode-select -p)"
    fi
fi

device_id="${LOCKET_SIMULATOR_UDID:-}"
if [[ -z "${device_id}" ]]; then
    device_id="$(xcrun simctl list devices available | awk -F '[()]' '/iPhone/ && /Booted/ { print $2; exit }')"
fi
if [[ -z "${device_id}" ]]; then
    # simctl lists runtimes oldest to newest, so the last available iPhone
    # selects the newest installed runtime (iOS 27 when present).
    device_id="$(xcrun simctl list devices available | awk -F '[()]' '/iPhone/ { device = $2 } END { print device }')"
fi
if [[ -z "${device_id}" ]]; then
    print -u2 "No available iPhone Simulator was found. Install an iOS 27 simulator runtime in Xcode Settings > Components."
    exit 1
fi

if ! xcrun simctl list devices | grep -F "${device_id}" | grep -q 'Booted'; then
    xcrun simctl boot "${device_id}"
fi
xcrun simctl bootstatus "${device_id}" -b

if [[ -d /Applications/Simulator.app ]]; then
    open /Applications/Simulator.app --args -CurrentDeviceUDID "${device_id}"
elif [[ -d "${DEVELOPER_DIR:h}/Applications/Simulator.app" ]]; then
    open "${DEVELOPER_DIR:h}/Applications/Simulator.app" --args -CurrentDeviceUDID "${device_id}"
elif [[ -d "${DEVELOPER_DIR:h}/Applications/DeviceHub.app" ]]; then
    # Xcode 27 replaces the standalone Simulator app with DeviceHub.
    open "${DEVELOPER_DIR:h}/Applications/DeviceHub.app"
else
    print -u2 "Simulator UI not found; continuing with the booted simulator device."
fi

xcodebuild \
    -project "${project_root}/Locket.xcodeproj" \
    -scheme Locket \
    -configuration Debug \
    -destination "platform=iOS Simulator,id=${device_id}" \
    -derivedDataPath "${derived_data_path}" \
    -clonedSourcePackagesDirPath "${source_packages_path}" \
    CODE_SIGNING_ALLOWED=NO \
    build

xcrun simctl install "${device_id}" "${app_path}"
xcrun simctl launch --terminate-running-process "${device_id}" "${bundle_identifier}"

print "Locket is running in the iOS Simulator."
