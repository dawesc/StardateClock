import Foundation

struct StardateCalculator {
    /// Returns a formatted fictional stardate string for the supplied date and era.
    static func stardateString(for date: Date = Date(), era: StardateEra) -> String {
        let elapsedSeconds = date.timeIntervalSince(era.anchorDate)
        let elapsedDays = elapsedSeconds / 86_400

        // Keep values positive and stable for display.
        let stardateValue = max(0, 1_000 + (elapsedDays * era.unitsPerDay))
        return String(format: "%.2f", stardateValue)
    }
}
