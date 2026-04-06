//
//  AvaApp.swift
//  Ava
//
//  Created by Stacey Fitton on 02/04/2026.
//

import SwiftUI

@main
struct AvaApp: App {
    @State private var container = AvaAppContainer(
           appGroupID: "group.com.staceyfitton.ava"
       )

    var body: some Scene {
        WindowGroup {
            //RootTabView(container: container)
            RootTabView()
                .environment(container)
                //.environment(container.)
        }
    }
}

