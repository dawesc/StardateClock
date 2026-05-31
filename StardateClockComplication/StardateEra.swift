import Foundation

/// Available science-fiction inspired eras used to calculate a fictional stardate.
enum StardateEra: String, CaseIterable, Identifiable {
    case classic = "classic"
    case nextCentury = "nextCentury"
    case modernFleet = "modernFleet"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .classic:
            return "Classic Era"
        case .nextCentury:
            return "Next Century Era"
        case .modernFleet:
            return "Modern Fleet Era"
        }
    }

    /// Base date anchors that create different era "styles" of fictional stardate output.
    var anchorDate: Date {
        let calendar = Calendar(identifier: .gregorian)
        switch self {
        case .classic:
            return calendar.date(from: DateComponents(year: 1966, month: 9, day: 8)) ?? .distantPast
        case .nextCentury:
            return calendar.date(from: DateComponents(year: 1987, month: 9, day: 28)) ?? .distantPast
        case .modernFleet:
            return calendar.date(from: DateComponents(year: 2020, month: 1, day: 1)) ?? .distantPast
        }
    }

    /// Multiplier controls how quickly the visible stardate advances per day.
    var unitsPerDay: Double {
        switch self {
        case .classic:
            return 8.0
        case .nextCentury:
            return 10.0
        case .modernFleet:
            return 12.5
        }
    }
}
