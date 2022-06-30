//
//  ComicExplainationSheetView.swift
//  xkcd Native
//
//  Created by Alf Jørgen Bråtane on 30/06/2022.
//

import SwiftUI
import WebKit

struct ComicExplainationSheetView: View {
    @Environment(\.dismiss) var dismiss
    @State var explanation: String
    
    var body: some View {
        VStack{
            WebView(text: $explanation)
                .frame(minWidth: 0, maxWidth: UIScreen.main.bounds.width, minHeight: 0, maxHeight: UIScreen.main.bounds.height )
                .padding()
            
            Button("Dismiss") {
                dismiss()
            }
            .padding()
        }
    }
}

struct WebView: UIViewRepresentable {
    @Binding var text: String
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let formattedText = "<html><body><div style=\"font-family:sans-serif;font-size:40px;\">\(text)</div></body></html>"
        uiView.loadHTMLString(formattedText, baseURL: nil)
        
    }
}
