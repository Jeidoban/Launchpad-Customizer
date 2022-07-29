//
//  Commands.swift
//  Launchpad Customizer
//
//  Created by Jade Westover on 7/28/22.
//

import Foundation
import SwiftUI

extension View {
    private func newWindowInternal(title: String, geometry: NSRect, style: NSWindow.StyleMask, delegate: NSWindowDelegate?) -> NSWindow {
        let window = NSWindow(
            contentRect: geometry,
            styleMask: style,
            backing: .buffered,
            defer: false)
        window.center()
        window.isReleasedWhenClosed = false
        window.title = title
        window.makeKeyAndOrderFront(nil)
        if delegate != nil {
            window.delegate = delegate
        }
        return window
    }
    
    func openNewWindow(title: String, delegate: NSWindowDelegate? = nil, geometry: NSRect = NSRect(x: 20, y: 20, width: 600, height: 550), style: NSWindow.StyleMask = [.titled, .closable, .miniaturizable, .resizable]) {
        self.newWindowInternal(title: title, geometry: geometry, style: style, delegate: delegate).contentView = NSHostingView(rootView: self)
    }
}

struct LaunchpadCustomizerCommands: Commands {
    var body: some Commands {
        CommandGroup(replacing: .pasteboard) {}
        CommandGroup(replacing: .undoRedo) {}
        CommandGroup(replacing: .systemServices) {}
        CommandGroup(after: .appInfo) {
            Button("Support the Developer") {
                guard let url = URL(string: "https://jeidoban.github.io/TotalyPages/supportme.html") else {
                    return
                }
                
                WebView(url: url)
                    .frame(minWidth: 600, maxWidth: .infinity, minHeight: 550, maxHeight: .infinity)
                    .openNewWindow(title: "Support the Developer")
            }
            Divider()
            Button("Attributions") {
                guard let url = URL(string: "https://jeidoban.github.io/TotalyPages/attributions.html") else {
                    return
                }
                
                WebView(url: url)
                    .frame(minWidth: 600, maxWidth: .infinity, minHeight: 550, maxHeight: .infinity)
                    .openNewWindow(title: "Attributions")
            }

        }
        CommandGroup(replacing: .help){
            Button("Contact the Developer") {
                guard let url = URL(string: "https://jeidoban.github.io/TotalyPages/support.html") else {
                    return
                }
                
                WebView(url: url)
                    .frame(minWidth: 600, maxWidth: .infinity, minHeight: 550, maxHeight: .infinity)
                    .openNewWindow(title: "Contact the Developer")
            }
        }
    }
}

