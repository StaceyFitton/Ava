//
//  MessageExtensionContainer.swift
//  Ava
//
//  Created by Stacey Fitton on 06/04/2026.
//

import Foundation

@MainActor
@Observable
public final class MessageExtensionContainer {
    public let sharedUserService: SharedUserService
    public let aiService: AIServiceProtocol
    
    public init(appGroupID: String) {
        let store = AppGroupStore(appGroupID: appGroupID)
        self.sharedUserService = SharedUserService(store: store)
        self.aiService = MessagesFoundationModelsService()
    }
}

// MARK: - Mock for previews/tests
struct MockAIService: AIServiceProtocol {
    func summarize(text: String) async throws -> String {
        return "Summary: \(text.prefix(40))…"
    }

    func generateResponse(to prompt: String) async throws -> String {
        return "Generated response to: \(prompt)"
    }

    func classify(text: String, labels: [String]) async throws -> String {
        return labels.first ?? "unknown"
    }
}
