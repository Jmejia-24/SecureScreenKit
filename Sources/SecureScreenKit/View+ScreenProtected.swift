//
//  View+ScreenProtected.swift
//  SecureScreenKit
//
//  Created by Byron on 4/22/25.
//

import SwiftUI

/// Adds a screen protection modifier to any SwiftUI view.
/// Prevents screenshots and optionally reacts to screen recording.
public extension View {

    /// Applies screen protection to the current view.
    /// - Parameters:
    ///   - detectRecording: Whether to observe screen recording.
    ///   - blurStyle: Optional blur effect when recording.
    ///   - overlayColor: Optional color overlay when recording.
    ///   - overlayImage: Optional image overlay when recording.
    ///   - onRecordingChange: Callback when recording state changes.
    /// - Returns: A view modified with SecureScreenModifier.
    ///
    /// ### Example:
    /// ```swift
    /// Text("Secure content")
    ///     .screenProtected(
    ///         detectRecording: true,
    ///         blurStyle: .dark
    ///     )
    /// ```
    func screenProtected(
        detectRecording: Bool = false,
        blurStyle: UIBlurEffect.Style? = nil,
        overlayColor: UIColor? = nil,
        overlayImage: UIImage? = nil,
        onRecordingChange: ((Bool) -> Void)? = nil
    ) -> some View {
        self.modifier(
            SecureScreenModifier(
                detectRecording: detectRecording,
                blurStyle: blurStyle,
                overlayColor: overlayColor,
                overlayImage: overlayImage,
                onRecordingChange: onRecordingChange
            )
        )
    }
}

