import Foundation

struct SharedSettings {
    /// Replace this with your real App Group in Apple Developer portal + target signing settings.
    /// Example placeholder required by this project brief:
    /// `group.me.thedawes.StardateClock`
    static let appGroupIdentifier = "group.me.thedawes.StardateClock"

    private static let eraKey = "selectedStardateEra"

    static var sharedDefaults: UserDefaults {
        UserDefaults(suiteName: appGroupIdentifier) ?? .standard
    }

    static func loadEra() -> StardateEra {
        guard
            let rawValue = sharedDefaults.string(forKey: eraKey),
            let era = StardateEra(rawValue: rawValue)
        else {
            return .modernFleet
        }
        return era
    }

    static func saveEra(_ era: StardateEra) {
        sharedDefaults.set(era.rawValue, forKey: eraKey)
    }
}
