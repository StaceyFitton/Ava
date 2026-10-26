//
//  0View.swift
//  Ava
//
//  C0reated by Assistant on 06/04/2026.
//

import SwiftUI


struct MessagesRootView: View {
    @Environment(MessageExtensionContainer.self) private var container

    @State private var statusMessage: String?
    @State private var errorMessage: String?
    #if DEBUG
    @State private var mockSenderName: String = "Test Contact"
    @State private var mockIncomingText: String = "Hey, can you reply from the extension?"
    #endif

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Ava Messages Extension")
                    .font(.headline)
                replyComposerSection

                conversationStatus

//                if let mockIncomingMessage = container.mockIncomingMessage {
//                    incomingMessageCard(mockIncomingMessage)
//                }

                #if DEBUG
                debugSimulatorSection
                #endif

            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
    }

    private var conversationStatus: some View {
        Group {
            if let selectedMessageSummary = container.selectedMessageSummary {
                Text("Selected message: \(selectedMessageSummary)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            } else if container.activeConversation != nil {
                Text("Active conversation with \(container.participantCount) participant(s)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            } else {
                Text("Waiting for conversation context")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }

    #if DEBUG
    private var debugSimulatorSection: some View {
        GroupBox("Debug Incoming Message") {
            VStack(alignment: .leading, spacing: 12) {
                TextField("Sender name", text: $mockSenderName)
                    .textFieldStyle(.roundedBorder)

                TextField("Incoming message text", text: $mockIncomingText, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .lineLimit(2...5)

                HStack(spacing: 12) {
                    Button("Simulate Incoming") {
                        do {
                            // Inject the message into the conversation harness first.
                            try container.injectMockIncomingMessage(
                                senderName: mockSenderName,
                                text: mockIncomingText
                            )
                            statusMessage = "Debug incoming message injected."
                            errorMessage = nil
                        } catch {
                            statusMessage = nil
                            errorMessage = error.localizedDescription
                            return
                        }

                        Task {
                            do {
                                let generatedReplies = try await container.aiService.generateResponseOptions(
                                    to: mockIncomingText
                                )
                                statusMessage = "Debug incoming message injected. Generated \(generatedReplies.count) reply option(s)."
                                errorMessage = nil
                            } catch {
                                statusMessage = nil
                                errorMessage = error.localizedDescription
                            }
                        }
                    }
                    .buttonStyle(.bordered)

                    Button("Clear") {
                        container.clearMockIncomingMessage()
                        statusMessage = "Debug incoming message cleared."
                        errorMessage = nil
                    }
                    .buttonStyle(.bordered)
                }
            }
        }
    }
    #endif

    private var replyComposerSection: some View {
        GroupBox("Reply Harness") {
            VStack(alignment: .leading, spacing: 12) {
                Text("Choose a reply to send:")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                ForEach(replyOptions, id: \.self) { reply in
                    Button(reply) {
                        Task {
                            await performConversationAction(
                                successMessage: "Reply sent to the conversation."
                            ) {
                                try await container.sendText(reply)
                            }
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(container.activeConversation == nil)
                }

                if let statusMessage {
                    Text(statusMessage)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }

                if let errorMessage {
                    Text(errorMessage)
                        .font(.footnote)
                        .foregroundStyle(.red)
                }

            }
        }
    }

    private var replyOptions: [String] {
        [
            "Yes, that works for me.",
            "I need a bit more time.",
            "Can you share more details?"
        ]
    }

    private func incomingMessageCard(
        _ message: MessageExtensionContainer.MockIncomingMessage
    ) -> some View {
        GroupBox("Simulated Incoming") {
            VStack(alignment: .leading, spacing: 8) {
                Text(message.senderName)
                    .font(.subheadline.weight(.semibold))

                Text(message.text)
                    .font(.body)

                Text(message.date.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private func performConversationAction(
        successMessage: String,
        action: @escaping () async throws -> Void
    ) async {
        statusMessage = nil
        errorMessage = nil

        do {
            try await action()
            statusMessage = successMessage
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

#Preview {
    let container = MessageExtensionContainer(appGroupID: "group.example.app")
     MessagesRootView()
        .environment(container)
}
