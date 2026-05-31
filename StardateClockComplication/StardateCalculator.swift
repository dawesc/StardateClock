import Foundation

struct StardateCalculator {
    /// Returns a canon-inspired stardate string for the supplied date and era.
    /// Note: historical Star Trek stardates are not globally deterministic across all series,
    /// so these formulas are intentionally "best-fit" by era.
    static func stardateString(for date: Date = Date(), era: StardateEra) -> String {
        let value: Double
        switch era {
        case .classic:
            value = classicEraStardate(for: date)
        case .nextCentury:
            value = linearStardate(
                for: date,
                anchorDate: dateFromUTC(year: 1987, month: 9, day: 28),
                anchorStardate: 41_153.7
            )
        case .modernFleet:
            value = linearStardate(
                for: date,
                anchorDate: dateFromUTC(year: 2023, month: 3, day: 9),
                anchorStardate: 78_183.10
            )
        }
        let format = (era == .modernFleet) ? "%.2f" : "%.1f"
        return String(format: format, value)
    }

    private static let secondsPerYear: Double = 365.2425 * 86_400.0

    /// TNG-and-later style approximation: ~1000 stardate units per year.
    private static func linearStardate(for date: Date, anchorDate: Date, anchorStardate: Double) -> Double {
        let elapsed = date.timeIntervalSince(anchorDate)
        let units = (elapsed / secondsPerYear) * 1_000.0
        return max(0, anchorStardate + units)
    }

    /// TOS-style approximation using two commonly cited endpoints:
    /// - 1312.4 near series start
    /// - 5928.5 near end of original run
    private static func classicEraStardate(for date: Date) -> Double {
        let startDate = dateFromUTC(year: 1966, month: 9, day: 8)
        let endDate = dateFromUTC(year: 1969, month: 6, day: 3)
        let startSD = 1_312.4
        let endSD = 5_928.5

        let spanSeconds = endDate.timeIntervalSince(startDate)
        guard spanSeconds > 0 else { return startSD }

        let unitsPerSecond = (endSD - startSD) / spanSeconds
        let elapsed = date.timeIntervalSince(startDate)
        return max(0, startSD + (elapsed * unitsPerSecond))
    }

    private static func dateFromUTC(year: Int, month: Int, day: Int) -> Date {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0) ?? .gmt
        return calendar.date(from: DateComponents(year: year, month: month, day: day)) ?? .distantPast
    }
}
