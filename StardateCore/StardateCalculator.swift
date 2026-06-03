import Foundation

public struct StardateCalculator {
    /// Returns a canon-inspired stardate string for the supplied date and era.
    /// Note: historical Star Trek stardates are not globally deterministic across all series,
    /// so these formulas are intentionally "best-fit" by era.
    public static func stardateString(for date: Date = Date(), era: StardateEra) -> String {
        let value: Double
        switch era {
        case .classic:
            value = classicEraStardate(for: date)
        case .nextCentury:
            value = nextGeneration(for: date)
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

    private static let gregorian: Calendar = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        return calendar
      }()
    
    private static func date(
      year: Int,
      month: Int,
      day: Int,
      hour: Int = 0,
      minute: Int = 0
    ) -> Date {
      DateComponents(
        calendar: gregorian,
        timeZone: TimeZone(secondsFromGMT: 0),
        year: year,
        month: month,
        day: day,
        hour: hour,
        minute: minute
      ).date!
    }

    private static func rounded(_ value: Double, places: Int) -> Double {
      let factor = pow(10.0, Double(places))
      return (value * factor).rounded() / factor
    }
    
    private static let secondsPerYear: Double = 365.2425 * 86_400.0

    /// TNG-and-later style approximation: ~1000 stardate units per year.
    private static func linearStardate(for date: Date, anchorDate: Date, anchorStardate: Double) -> Double {
        let elapsed = date.timeIntervalSince(anchorDate)
        let units = (elapsed / secondsPerYear) * 1_000.0
        return max(0, anchorStardate + units)
    }

    private static func dateFromUTC(year: Int, month: Int, day: Int) -> Date {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0) ?? .gmt
        return calendar.date(from: DateComponents(year: year, month: month, day: day)) ?? .distantPast
    }

    private static let epochTNG = date(year: 2318, month: 7, day: 5, hour: 12)
    private static let secondsPerStardateTNG = 34_367.0564

    /// TNG-and-later style approximation: ~1000 stardate units per year.
    public static func nextGeneration(for date: Date) -> Double {
        return rounded(date.timeIntervalSince(epochTNG) / secondsPerStardateTNG, places: 1)
    }

    private static let classicEpoch: Date = date(year: 2265, month: 4, day: 25)
    private static let meanSolarYearDaysClassic: Double = 365.2422
    private static let stardatesPerYearClassic: Double = 2635.10833
    private static let secondsPerStardateClassic = (meanSolarYearDaysClassic * 86_400.0) / stardatesPerYearClassic

    /// TOS-style approximation using two commonly cited endpoints:
    private static func classicEraStardate(for date: Date) -> Double {
        let epoch = self.date(year: 2265, month: 4, day: 25)
        return rounded(date.timeIntervalSince(classicEpoch) / secondsPerStardateClassic, places: 1)
    }
}
