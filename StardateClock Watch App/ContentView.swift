import SwiftUI
import Combine

struct ContentView: View {
    @State private var selectedEra: StardateEra = SharedSettings.loadEra()
    @State private var now: Date = Date()

    // Refreshes local UI once per minute; complication timeline handles its own cadence.
    private let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()

    private var stardate: String {
        StardateCalculator.stardateString(for: now, era: selectedEra)
    }

    var body: some View {
        VStack(spacing: 10) {
            Image("StardateLogo")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 140)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

            Text(stardate)
                .font(.system(size: 34, weight: .bold, design: .rounded))
                .minimumScaleFactor(0.6)
                .lineLimit(1)

            Text("Fictional Stardate")
                .font(.caption2)
                .foregroundStyle(.secondary)

            Picker("Calculation Era", selection: $selectedEra) {
                ForEach(StardateEra.allCases) { era in
                    Text(era.displayName).tag(era)
                }
            }
            .labelsHidden()
            .pickerStyle(.wheel)
        }
        .padding()
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
