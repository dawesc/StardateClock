import Foundation

/// Available science-fiction inspired eras used to calculate a fictional stardate.
public enum StardateEra: String, CaseIterable, Identifiable {
    case classic = "classic"
    case nextCentury = "nextCentury"
    case modernFleet = "modernFleet"

    public var id: String { rawValue }

    public var displayName: String {
        switch self {
        case .classic:
            return "Classic Era"
        case .nextCentury:
            return "Next Century Era"
        case .modernFleet:
            return "Modern Fleet Era"
        }
    }
}
