//
//  MessageComposerView.swift
//  Ava
//
//  Created by Stacey Fitton on 03/04/2026.
//


import SwiftUI
import Messages

struct MessageComposerView: View {
    let presentationStyle: MSMessagesAppPresentationStyle
    let onRequestExpand: () -> Void
    let onSend: (_ text: String, _ itemID: String) -> Void

    @State private var messageText = ""
    @State private var itemID = ""

    private var canSend: Bool {
        !messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
        !itemID.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                if presentationStyle == .compact {
                    compactContent
                } else {
                    expandedContent
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Message Sender")
        }
    }

    private var compactContent: some View {
        VStack(spacing: 12) {
            Text("Share a message or item")
                .font(.headline)

            Button("Open Composer") {
                onRequestExpand()
            }
            .buttonStyle(.borderedProminent)
        }
    }

    private var expandedContent: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Compose")
                .font(.title2.bold())

            VStack(alignment: .leading, spacing: 8) {
                Text("Message")
                    .font(.subheadline.weight(.medium))

                TextField("Enter message text", text: $messageText)
                    .textFieldStyle(.roundedBorder)
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("Shared value")
                    .font(.subheadline.weight(.medium))

                TextField("Enter item ID", text: $itemID)
                    .textFieldStyle(.roundedBorder)
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("Preview")
                    .font(.headline)

                GroupBox {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(messageText.isEmpty ? "Shared from my app" : messageText)
                            .font(.body)

                        if !itemID.isEmpty {
                            Text("Item ID: \(itemID)")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }

            Button("Send") {
                onSend(messageText, itemID)
            }
            .buttonStyle(.borderedProminent)
            .disabled(!canSend)
        }
    }
}