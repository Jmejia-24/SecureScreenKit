//
//  SecureScreenModifier.swift
//  SecureScreenKit
//
//  Created by Byron on 4/22/25.
//

import SwiftUI

public struct SecureScreenModifier: ViewModifier {

    @State private var manager = SecureScreenKit(window: UIApplication.shared.connectedScenes
        .compactMap { $0 as? UIWindowScene }
        .flatMap { $0.windows }
        .first { $0.isKeyWindow })

    @State private var isRecording = false

    private let detectRecording: Bool
    private let blurStyle: UIBlurEffect.Style?
    private let overlayColor: UIColor?
    private let overlayImage: UIImage?
    private let onRecordingChange: ((Bool) -> Void)?

    public init(
        detectRecording: Bool = false,
        blurStyle: UIBlurEffect.Style? = nil,
        overlayColor: UIColor? = nil,
        overlayImage: UIImage? = nil,
        onRecordingChange: ((Bool) -> Void)? = nil
    ) {
        self.detectRecording = detectRecording
        self.blurStyle = blurStyle
        self.overlayColor = overlayColor
        self.overlayImage = overlayImage
        self.onRecordingChange = onRecordingChange
    }

    public func body(content: Content) -> some View {
        ZStack {
            content
                .onAppear {
                    manager.configurePreventionScreenshot()
                    manager.enabledPreventScreenshot()

                    if detectRecording {
                        manager.screenRecordObserver { isCaptured in
                            isRecording = isCaptured
                            onRecordingChange?(isCaptured)

                            if isCaptured {
                                if let blurStyle {
                                    manager.enabledBlurScreen(style: blurStyle)
                                } else if let overlayColor {
                                    manager.enabledColorScreen(color: overlayColor)
                                } else if let overlayImage {
                                    manager.enabledImageScreen(image: overlayImage)
                                }
                            } else {
                                manager.disableBlurScreen()
                                manager.disableColorScreen()
                                manager.disableImageScreen()
                            }
                        }
                    }
                }
                .onDisappear {
                    manager.disablePreventScreenshot()
                    manager.removeAllObserver()
                }
        }
    }
}
