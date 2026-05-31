# Stardate Clock (watchOS) Setup Notes

Namespace / bundle ID prefix: `me.thedawes.stardate`

## Targets to create in Xcode

1. `StardateClockWatchApp` (watchOS App, SwiftUI lifecycle)
2. `StardateClockComplication` (Widget Extension for watchOS complications)

## Bundle identifiers (recommended)

- App target: `me.thedawes.stardate.watchapp`
- Widget target: `me.thedawes.stardate.complication`

## App Group setup (required)

1. In Apple Developer portal, create App Group (example placeholder in code):
   - `group.me.thedawes.StardateClock`
2. In Xcode Signing & Capabilities, add **App Groups** capability to both targets.
3. Enable the same App Group for both targets.
4. Replace placeholder string in:
   - `StardateClockWatchApp/SharedSettings.swift`
   - `StardateClockWatchApp/StardateClockWatchApp.entitlements`
   - `StardateClockComplication/StardateClockComplication.entitlements`

## Files to include in both targets

Shared model/logic files needed in app + extension:
- `StardateClockWatchApp/StardateEra.swift`
- `StardateClockWatchApp/StardateCalculator.swift`
- `StardateClockWatchApp/SharedSettings.swift`

App target only:
- `StardateClockWatchApp/ContentView.swift`
- `StardateClockWatchApp/StardateWatchApp.swift`

Widget target only:
- `StardateClockComplication/StardateComplication.swift`

## Notes

- This project intentionally provides WidgetKit complications only.
- It does not implement a custom Apple Watch face.
