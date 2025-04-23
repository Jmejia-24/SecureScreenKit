//
//  View+ScreenProtected.swift
//  SecureScreenKit
//
//  Created by Byron on 4/22/25.
//

import SwiftUI

public extension View {
    
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
