//
//  NotificationsView.swift
//  Ava
//
//  Created by Stacey Fitton on 03/04/2026.
//


import SwiftUI

struct NotificationsView: View {
    @State var viewModel: NotificationsViewModel

    var body: some View {
        List {
            ForEach(viewModel.items) { item in
                HStack(alignment: .top) {
                    Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                        .foregroundStyle(item.isCompleted ? .green : .secondary)
                        .onTapGesture { viewModel.toggleCompleted(item) }
                    VStack(alignment: .leading, spacing: 4) {
                        Text(item.title).font(.headline)
                        Text(item.detail).font(.subheadline).foregroundStyle(.secondary)
                    }
                }
            }
        }
        .navigationTitle("Notifications")
    }
}

#Preview {
    NavigationStack { NotificationsView(viewModel: NotificationsViewModel()) }
}
