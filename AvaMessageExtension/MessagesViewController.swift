//
//  MessagesViewController.swift
//  AvaMessageExtension
//
//  Created by Stacey Fitton on 03/04/2026.
//
import UIKit
import SwiftUI
import Messages

final class MessagesViewController: MSMessagesAppViewController {

    @MainActor
    private let container = MessageExtensionContainer(
        appGroupID: "group.com.staceyfitton.ava"
    )

    private var hostingController: UIHostingController<AnyView>?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureHostingController()
    }

    override func willBecomeActive(with conversation: MSConversation) {
        super.willBecomeActive(with: conversation)
        container.updateConversation(conversation)
        updateRootView()
    }

    override func didReceive(_ message: MSMessage, conversation: MSConversation) {
        super.didReceive(message, conversation: conversation)
        container.updateConversation(conversation)

        let payload = parseMessage(message)
        print("Received payload text: \(payload.text ?? "nil")")
        print("Received payload itemID: \(payload.itemID ?? "nil")")

        updateRootView()
    }

    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        super.willTransition(to: presentationStyle)
        updateRootView()
    }

    private func configureHostingController() {
        let controller = UIHostingController(rootView: makeRootView())
        hostingController = controller

        addChild(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(controller.view)

        NSLayoutConstraint.activate([
            controller.view.topAnchor.constraint(equalTo: view.topAnchor),
            controller.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            controller.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            controller.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        controller.didMove(toParent: self)
    }

    private func updateRootView() {
        hostingController?.rootView = makeRootView()
    }

    private func makeRootView() -> AnyView {
        AnyView(
            MessagesRootView()
                .environment(container)
        )
    }

    private func sendMessage(text: String, itemID: String) {
        guard let conversation = activeConversation else {
            print("No active conversation available.")
            return
        }

        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedItemID = itemID.trimmingCharacters(in: .whitespacesAndNewlines)

        let layout = MSMessageTemplateLayout()
        layout.caption = trimmedText.isEmpty ? "Shared from my app" : trimmedText
        layout.subcaption = trimmedItemID.isEmpty ? nil : "Item ID: \(trimmedItemID)"

        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "text", value: trimmedText),
            URLQueryItem(name: "itemID", value: trimmedItemID)
        ]

        let session = conversation.selectedMessage?.session ?? MSSession()
        let message = MSMessage(session: session)
        message.layout = layout
        message.url = components.url

        conversation.insert(message) { [weak self] error in
            if let error = error {
                print("Insert message failed: \(error)")
                return
            }

            self?.dismiss()
        }
    }

    private func parseMessage(_ message: MSMessage) -> (text: String?, itemID: String?) {
        guard
            let url = message.url,
            let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        else {
            return (nil, nil)
        }

        let text = components.queryItems?.first(where: { $0.name == "text" })?.value
        let itemID = components.queryItems?.first(where: { $0.name == "itemID" })?.value
        return (text, itemID)
    }
}
