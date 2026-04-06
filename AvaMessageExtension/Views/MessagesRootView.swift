//
//  MessagesRootView.swift
//  Ava
//
//  Created by Assistant on 06/04/2026.
//

import SwiftUI

struct MessagesRootView: View {
    @Environment(MessageExtensionContainer.self) private var container

    @State private var input: String = ""

    var body: some View {
        VStack(spacing: 12) {
            Text("Ava Messages Extension")
                .font(.headline)

            TextField("Type a prompt…", text: $input)
                .textFieldStyle(.roundedBorder)

            Button("Generate") {
                Task {
                    do {
                        _ = try await container.aiService.generateResponse(to: input)
                    } catch {
                        // Handle error appropriately
                    }
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

#Preview {
    let container = MessageExtensionContainer(appGroupID: "group.example.app")
     MessagesRootView()
        .environment(container)
}
