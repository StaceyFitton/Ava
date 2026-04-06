//
//  GatherView.swift
//  Ava
//
//  Created by Stacey Fitton on 03/04/2026.
//


import SwiftUI

struct GatherView: View {
    @State var viewModel: GatherViewModel

    var body: some View {
        List {
            ForEach(viewModel.sources) { source in
                Toggle(isOn: Binding(
                    get: { source.isEnabled },
                    set: { _ in viewModel.toggle(source) }
                )) {
                    Label(source.kind.rawValue, systemImage: icon(for: source.kind))
                }
            }
        }
        .navigationTitle("Gather")
    }

    private func icon(for kind: GatherViewModel.AppSource.Kind) -> String {
        switch kind {
        case .notes: return "note.text"
        case .journal: return "book"
        case .photos: return "photo"
        }
    }
}

#Preview {
    NavigationStack { GatherView(viewModel: GatherViewModel()) }
}
