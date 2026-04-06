//
//  MessagesHostingController.swift
//  Ava
//
//  Created by Assistant on 06/04/2026.
//

import UIKit
import SwiftUI
import Messages

final class MessagesHostingController: MSMessagesAppViewController {
    private var hostingController: UIHostingController<AnyView>?
        private let container = MessageExtensionContainer(appGroupID: "group.com.staceyfitton.ava")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rootView = AnyView(
            MessagesRootView()
                .environment(container)
        )
        
        let host = UIHostingController(rootView: rootView)
        addChild(host)
        host.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(host.view)
        NSLayoutConstraint.activate([
            host.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            host.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            host.view.topAnchor.constraint(equalTo: view.topAnchor),
            host.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        host.didMove(toParent: self)
        self.hostingController = host
    }
}
