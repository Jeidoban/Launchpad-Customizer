//
//  Launchpad_CustomizerApp.swift
//  Launchpad Customizer
//
//  Created by Jade Westover on 7/27/22.
//

import SwiftUI

@main
struct LaunchpadCustomizerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(width: 400, height: 250)
                .onAppear {
                    NSWindow.allowsAutomaticWindowTabbing = false
                }
        }
        .commands {
            LaunchpadCustomizerCommands()
        }
    }
}
