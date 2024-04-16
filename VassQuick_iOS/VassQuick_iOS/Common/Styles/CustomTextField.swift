//
//  CustomTextField.swift
//  VassQuick_iOS
//
//  Created by Daniel Cazorro Frias  on 9/3/24.
//

import Combine
import SwiftUI
import UIKit

struct CustomTextField: View {
    @Binding var text: String
    var placeholder: String

    var body: some View {
        TextField(placeholder, text: $text)
            .padding()
            .cornerRadius(8.0)
    }
}

struct CustomSecureField: View {
    var placeholder: String
    @Binding var text: String
    var isSecured: Bool

    var body: some View {
        ZStack(alignment: .leading) {
            if isSecured {
                SecureField(placeholder, text: $text)
                    .foregroundColor(.white)
            } else {
                TextField(placeholder, text: $text)
                    .foregroundColor(.white)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(8.0)
    }
}

struct FilledButton: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .padding()
            .background(Color.blue)
            .cornerRadius(8.0)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)

    }
}

struct SecureInputView: View {
    
    @Binding private var text: String
    @State private var isSecured: Bool = true
    private var title: String
    
    init(_ title: String, text: Binding<String>) {
        self.title = title
        self._text = text
    }
    
    var body: some View {
        ZStack(alignment: .trailing) {
            if isSecured {
                SecureField(title, text: $text)
            } else {
                TextField(title, text: $text)
            }
            
            Button {
                isSecured.toggle()
            } label: {
                Image(systemName: isSecured ? "eye.slash" : "eye")
                    .accentColor(.gray)
            }
            .padding(.trailing, 8) 
        }
    }
}

struct TextFieldIcon: View {
    
    @Binding private var text: String
    @State private var isSecured: Bool = true
    private var title: String
    
    init(_ title: String, text: Binding<String>) {
        self.title = title
        self._text = text
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            if isSecured {
                SecureField(title, text: $text)
            } else {
                TextField(title, text: $text)
            }
            
            Button {
                isSecured.toggle()
            } label: {
                Image(systemName: isSecured ? "person.cirle" : "person.crop.circle")
                    .accentColor(.gray)
            }
            .padding(.trailing, 8)
        }
    }
}

extension String {
    func translated() -> String {
        NSLocalizedString(self, comment: "")
    }
}

extension UIImage {
    func resizeTo(width: CGFloat) -> UIImage? {
        let scale = width / self.size.width
        let newHeight = self.size.height * scale
        UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: newHeight), false, 0)
        self.draw(in: CGRect(x: 0, y: 0, width: width, height: newHeight))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage
    }
}
