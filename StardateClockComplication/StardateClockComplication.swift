import WidgetKit
import SwiftUI
import Foundation

struct StardateEntry: TimelineEntry {
    let date: Date
    let era: StardateEra

    var stardate: String {
        StardateCalculator.stardateString(for: date, era: era)
    }
}

struct EraStardateProvider: TimelineProvider {
    let era: StardateEra

    func placeholder(in context: Context) -> StardateEntry {
        StardateEntry(date: Date(), era: era)
    }

    func getSnapshot(in context: Context, completion: @escaping (StardateEntry) -> Void) {
        completion(StardateEntry(date: Date(), era: era))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<StardateEntry>) -> Void) {
        let now = Date()

        // Build ~4 hours of 5-minute entries.
        let entries: [StardateEntry] = stride(from: 0, through: 48, by: 1).compactMap { step in
            guard let date = Calendar.current.date(byAdding: .minute, value: step * 5, to: now) else {
                return nil
            }
            return StardateEntry(date: date, era: era)
        }

        // `.atEnd` asks WidgetKit to request a new timeline when this one expires.
        completion(Timeline(entries: entries, policy: .atEnd))
    }
}

struct StardateComplicationEntryView: View {
    let entry: StardateEntry
    let title: String
    @Environment(\.widgetFamily) private var family

    var body: some View {
        switch family {
        case .accessoryInline:
            Text("SD \(entry.stardate)")

        case .accessoryCircular:
            ZStack {
                AccessoryWidgetBackground()
                Text(entry.stardate)
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
            }

        case .accessoryRectangular:
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                Text(entry.stardate)
                    .font(.headline)
                    .minimumScaleFactor(0.6)
                    .lineLimit(1)
            }

        case .accessoryCorner:
            Text(entry.stardate)

        @unknown default:
            Text(entry.stardate)
        }
    }
}

struct StardateClassicComplication: Widget {
    let kind: String = "me.thedawes.stardate.complication.classic"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: EraStardateProvider(era: .classic)) { entry in
            StardateComplicationEntryView(entry: entry, title: "Classic Era")
        }
        .configurationDisplayName("Stardate Classic")
        .description("Shows a science-fiction inspired fictional stardate for Classic Era.")
        .supportedFamilies([
            .accessoryInline,
            .accessoryCircular,
            .accessoryRectangular,
            .accessoryCorner
        ])
    }
}

struct StardateNextCenturyComplication: Widget {
    let kind: String = "me.thedawes.stardate.complication.nextcentury"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: EraStardateProvider(era: .nextCentury)) { entry in
            StardateComplicationEntryView(entry: entry, title: "Next Century Era")
        }
        .configurationDisplayName("Stardate Next Century")
        .description("Shows a science-fiction inspired fictional stardate for Next Century Era.")
        .supportedFamilies([
            .accessoryInline,
            .accessoryCircular,
            .accessoryRectangular,
            .accessoryCorner
        ])
    }
}

struct StardateModernFleetComplication: Widget {
    let kind: String = "me.thedawes.stardate.complication.modernfleet"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: EraStardateProvider(era: .modernFleet)) { entry in
            StardateComplicationEntryView(entry: entry, title: "Modern Fleet Era")
        }
        .configurationDisplayName("Stardate Modern Fleet")
        .description("Shows a science-fiction inspired fictional stardate for Modern Fleet Era.")
        .supportedFamilies([
            .accessoryInline,
            .accessoryCircular,
            .accessoryRectangular,
            .accessoryCorner
        ])
    }
}
