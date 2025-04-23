//
//  SecureScreenViewController.swift
//  SecureScreenKit
//
//  Created by Byron on 4/22/25.
//

import UIKit

/// A base UIViewController subclass that enables automatic screen protection.
/// Supports screenshot prevention and optional screen recording handling.
///
/// ### Example:
/// ```swift
/// final class SecureVC: SecureScreenViewController {
///     override var screenProtectedDetectRecording: Bool { true }
///     override var screenProtectedBlurStyle: UIBlurEffect.Style? { .dark }
/// }
/// ```
open class SecureScreenViewController: UIViewController {

    private var screenManager: SecureScreenKit?
    private var isProtectionEnabled = false

    /// Indicates if screen recording should be observed.
    open var screenProtectedDetectRecording: Bool { false }

    /// Determines whether a blur overlay should be applied when recording.
    open var screenProtectedShowBlur: Bool { false }

    /// Optional blur style to apply during screen recording.
    open var screenProtectedBlurStyle: UIBlurEffect.Style? { nil }

    /// Optional color overlay to apply during screen recording.
    open var screenProtectedOverlayColor: UIColor? { nil }

    /// Optional image overlay to apply during screen recording.
    open var screenProtectedOverlayImage: UIImage? { nil }

    /// Activates protection when the view appears, and configures optional recording detection.
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        guard !isProtectionEnabled else { return }
        guard let window = view.window else {
            print("⚠️ UIWindow is not available yet during viewDidAppear execution.")
            return
        }

        screenManager = SecureScreenKit(window: window)
        screenManager?.configurePreventionScreenshot()
        screenManager?.enabledPreventScreenshot()
        isProtectionEnabled = true

        if screenProtectedDetectRecording {
            screenManager?.screenRecordObserver { [weak self] isCaptured in
                self?.handleScreenProtectedRecordingState(isCaptured)
            }
        }
    }

    /// Disables protection and removes overlays and observers when the view disappears.
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        screenManager?.disablePreventScreenshot()
        screenManager?.removeAllObserver()
        screenManager?.disableBlurScreen()
        screenManager?.disableColorScreen()
        screenManager?.disableImageScreen()

        isProtectionEnabled = false
    }

    /// Applies or removes visual overlays depending on the current screen recording state.
    /// - Parameter isCaptured: Whether the screen is currently being recorded.
    open func handleScreenProtectedRecordingState(_ isCaptured: Bool) {
        guard let screenManager else { return }

        if isCaptured {
            if let style = screenProtectedBlurStyle {
                screenManager.enabledBlurScreen(style: style)
            } else if let color = screenProtectedOverlayColor {
                screenManager.enabledColorScreen(color: color)
            } else if let image = screenProtectedOverlayImage {
                screenManager.enabledImageScreen(image: image)
            }
        } else {
            screenManager.disableBlurScreen()
            screenManager.disableColorScreen()
            screenManager.disableImageScreen()
        }
    }
}
