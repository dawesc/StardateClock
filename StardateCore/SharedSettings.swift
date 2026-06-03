import Foundation

public struct SharedSettings {
    /// Replace this with your real App Group in Apple Developer portal + target signing settings.
    /// `group.me.thedawes.StardateClock`
    public static let appGroupIdentifier = "group.me.thedawes.StardateClock"

    private static let eraKey = "selectedStardateEra"

    public static var sharedDefaults: UserDefaults {
        UserDefaults(suiteName: appGroupIdentifier) ?? .standard
    }

    public static func loadEra() -> StardateEra {
        guard
            let rawValue = sharedDefaults.string(forKey: eraKey),
            let era = StardateEra(rawValue: rawValue)
        else {
            return .modernFleet
        }
        return era
    }

    public static func saveEra(_ era: StardateEra) {
        sharedDefaults.set(era.rawValue, forKey: eraKey)
    }
}
