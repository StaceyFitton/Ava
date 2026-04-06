import Foundation
import SwiftUI
import Observation

@Observable
final class GatherViewModel {
    struct AppSource: Identifiable, Hashable {
        enum Kind: String { case notes = "Notes", journal = "Journal", photos = "Photos" }
        let id = UUID()
        let kind: Kind
        var isEnabled: Bool
    }

    var sources: [AppSource] = [
        .init(kind: .notes, isEnabled: false),
        .init(kind: .journal, isEnabled: false),
        .init(kind: .photos, isEnabled: false)
    ]

    @MainActor
    func toggle(_ source: AppSource) {
        if let idx = sources.firstIndex(of: source) {
            sources[idx].isEnabled.toggle()
        }
    }
}
#Preview {
    
}
