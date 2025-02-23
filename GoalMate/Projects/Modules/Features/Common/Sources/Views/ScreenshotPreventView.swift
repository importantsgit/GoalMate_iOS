//
//  ScreenshotPreventView.swift
//  FeatureCommon
//
//  Created by Importants on 2/22/25.
//

import SwiftUI
import UIKit

struct ScreenshotPreventView<Content: View>: View {
    var content: Content

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content()
    }

    @State private var hostingController: UIHostingController<Content>?

    var body: some View {
        _ScreenshotPreventHelper(hostingController: $hostingController)
            .overlay(
                GeometryReader { geometry in
                    let size = geometry.size
                    Color.clear
                        .preference(key: SizeKey.self, value: size)
                        .onPreferenceChange(SizeKey.self) { newValue in
                            if hostingController == nil {
                                hostingController = UIHostingController(rootView: content)
                                hostingController?.view.backgroundColor = .clear
                                hostingController?.view.frame = CGRect(origin: .zero, size: size)
                            }
                        }
                }
            )
    }
}

fileprivate struct SizeKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

fileprivate struct _ScreenshotPreventHelper<Content: View>: UIViewRepresentable {
    @Binding var hostingController: UIHostingController<Content>?

    func makeUIView(context: Context) -> UIView {
        let secureField = UITextField()
        secureField.isSecureTextEntry = true
        if let textLayoutView = secureField.subviews.first {
            return textLayoutView
        }
        return UIView()
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        // Adding hosting view as a Subview to the TextLayout View
        if let hostingController,
            uiView.subviews.contains(where: { $0.tag == 100 }) == false {
            uiView.addSubview(hostingController.view)
        }
    }
}
