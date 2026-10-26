//
//  MessageExtensionContainer.swift
//  Ava
//
//  Created by Stacey Fitton on 06/04/2026.
//

import Foundation
import Messages

@MainActor
@Observable
public final class MessageExtensionContainer {
    public struct MockIncomingMessage: Equatable {
        public let senderName: String
        public let text: String
        public let date: Date

        public init(senderName: String, text: String, date: Date = .now) {
            self.senderName = senderName
            self.text = text
            self.date = date
        }
    }

    public enum ConversationHarnessError: LocalizedError {
        case noActiveConversation
        case emptyText

        public var errorDescription: String? {
            switch self {
            case .noActiveConversation:
                return "No active conversation is available."
            case .emptyText:
                return "Enter some text first."
            }
        }
    }

    public let sharedUserService: SharedUserService
    public let aiService: AIServiceProtocol
    public private(set) var activeConversation: MSConversation?
    public private(set) var mockIncomingMessage: MockIncomingMessage?

    public var participantCount: Int {
        activeConversation?.remoteParticipantIdentifiers.count ?? 0
    }

    public var selectedMessageSummary: String? {
        activeConversation?.selectedMessage?.summaryText
    }

    public init(appGroupID: String) {
        let store = AppGroupStore(appGroupID: appGroupID)
        self.sharedUserService = SharedUserService(store: store)
        self.aiService = MessagesFoundationModelsService()
    }

    public func updateConversation(_ conversation: MSConversation?) {
        activeConversation = conversation
    }

    public func injectMockIncomingMessage(senderName: String, text: String) throws {
        let trimmedSenderName = senderName.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedSenderName.isEmpty, !trimmedText.isEmpty else {
            throw ConversationHarnessError.emptyText
        }

        mockIncomingMessage = MockIncomingMessage(
            senderName: trimmedSenderName,
            text: trimmedText
        )
    }

    public func clearMockIncomingMessage() {
        mockIncomingMessage = nil
    }

//    public func stageText(_ text: String) async throws {
//        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
//        guard !trimmedText.isEmpty else {
//            throw ConversationHarnessError.emptyText
//        }
//
//        guard let activeConversation else {
//            throw ConversationHarnessError.noActiveConversation
//        }
//
//        try await activeConversation.insertText(trimmedText)
//    }

    public func sendText(_ text: String) async throws {
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty else {
            throw ConversationHarnessError.emptyText
        }

        guard let activeConversation else {
            throw ConversationHarnessError.noActiveConversation
        }

        //  try await activeConversation.sendText(trimmedText) - Giving error on direct send
        try await activeConversation.insertText(trimmedText)
    }
}

// MARK: - Mock for previews/tests
struct MockAIService: AIServiceProtocol {
    func generateResponseOptions(to prompt: String) async throws -> [String] {
        return ["Summary: Hmmm..... "]
    }
    
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
