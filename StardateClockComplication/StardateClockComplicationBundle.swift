//
//  StardateClockComplicationBundle.swift
//  StardateClockComplication
//
//  Created by Christopher Dawes on 2026-05-31.
//

import WidgetKit
import SwiftUI

@main
struct StardateClockComplicationBundle: WidgetBundle {
    var body: some Widget {
        StardateClassicComplication()
        StardateNextCenturyComplication()
        StardateModernFleetComplication()
    }
}
