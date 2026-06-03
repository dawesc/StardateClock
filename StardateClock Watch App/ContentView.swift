import SwiftUI
import Combine
import StardateCore

struct ContentView: View {
    @State private var selectedEra: StardateEra = SharedSettings.loadEra()
    @State private var now: Date = Date()

    // Refreshes local UI once per minute; complication timeline handles its own cadence.
    private let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()

    private var stardate: String {
        StardateCalculator.stardateString(for: now, era: selectedEra)
    }

    var body: some View {
        ZStack {
            StardatePalette.background
                .ignoresSafeArea()

            VStack(spacing: 8) {
                Image("StardateLogo")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 135, height: 70)
                    .clipShape(Rectangle())
                    .overlay {
                        Rectangle()
                            .stroke(StardatePalette.secondary.opacity(0.75), lineWidth: 1)
                    }
                    .shadow(color: StardatePalette.accent.opacity(0.55), radius: 10)

                VStack(spacing: 1) {
                    Text(stardate)
                        .font(.system(size: 34, weight: .semibold, design: .rounded))
                        .foregroundStyle(StardatePalette.primary)
                        .minimumScaleFactor(0.55)
                        .lineLimit(1)

                    Text("Fictional Stardate")
                        .font(.system(size: 10, weight: .medium, design: .rounded))
                        .foregroundStyle(StardatePalette.secondary)
                }

                VStack(spacing: 2) {
                    Text(selectedEra.displayName)
                        .font(.system(size: 10, weight: .semibold, design: .rounded))
                        .foregroundStyle(StardatePalette.accent)

                    Picker("Calculation Era", selection: $selectedEra) {
                        ForEach(StardateEra.allCases) { era in
                            Text(era.displayName).tag(era)
                        }
                    }
                    .labelsHidden()
                    .pickerStyle(.wheel)
                    .frame(height: 48)
                    .clipped()
                    .tint(StardatePalette.accent)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 5)
                .background(
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(StardatePalette.panel)
                )
                .overlay {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .stroke(StardatePalette.secondary.opacity(0.45), lineWidth: 1)
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
        }
        .colorScheme(.dark)
        .onAppear {
            selectedEra = SharedSettings.loadEra()
            now = Date()
        }
        .onChange(of: selectedEra) { _, newValue in
            SharedSettings.saveEra(newValue)
        }
        .onReceive(timer) { tick in
            now = tick
        }
    }
}

#Preview {
    ContentView()
}

private enum StardatePalette {
    static let background = LinearGradient(
        colors: [
            Color(red: 0.039, green: 0.122, blue: 0.302),
            Color(red: 0.004, green: 0.055, blue: 0.169)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    static let primary = Color.white
    static let secondary = Color(red: 0.741, green: 0.902, blue: 1.0)
    static let accent = Color(red: 0.0, green: 0.898, blue: 1.0)
    static let panel = Color(red: 0.039, green: 0.122, blue: 0.302).opacity(0.72)
}
