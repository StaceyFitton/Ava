//
//  NotificationsViewModel.swift
//  Ava
//
//  Created by Stacey Fitton on 03/04/2026.
//


import Foundation
import Observation

@Observable
final class NotificationsViewModel {
    struct NotificationItem: Identifiable, Hashable {
        let id = UUID()
        var title: String
        var detail: String
        var isCompleted: Bool = false
    }

    var items: [NotificationItem] = [
        .init(title: "Review today's notes", detail: "Summarize and tag important points."),
        .init(title: "Add journal entry", detail: "Reflect on your day."),
        .init(title: "Select photos to keep", detail: "Curate your recent photos.")
    ]

    @MainActor
    func toggleCompleted(_ item: NotificationItem) {
        if let idx = items.firstIndex(of: item) {
            items[idx].isCompleted.toggle()
        }
    }
}
