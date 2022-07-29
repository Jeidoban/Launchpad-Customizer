//
//  WebView.swift
//  Launchpad Customizer
//
//  Created by Jade Westover on 7/28/22.
//

import Foundation
import SwiftUI
import WebKit

struct WebView: NSViewRepresentable {
    var url: URL
    
    func makeNSView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateNSView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
