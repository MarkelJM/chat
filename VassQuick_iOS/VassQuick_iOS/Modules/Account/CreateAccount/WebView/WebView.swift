//
//  WebView.swift
//  VassQuick_iOS
//
//  Created by Daniel Cazorro Frias  on 20/3/24.
//

import SwiftUI
import WebKit

struct WebView: View {
    
    // MARK: - Properties
    let url: String
    @Environment(\.presentationMode) var presentationMode

    // MARK: - View
    var body: some View {
        VStack {
            WebViewRepresentable(url: url)
                .edgesIgnoringSafeArea(.all)
            
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("create_account_web_view_back".localized)
                    .padding()
                    .foregroundColor(.white)
            }
        }
    }
}

// MARK: - ViewRepresentable
struct WebViewRepresentable: UIViewRepresentable {
    let url: String

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        if let url = URL(string: url) {
            webView.load(URLRequest(url: url))
        }
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}
}
