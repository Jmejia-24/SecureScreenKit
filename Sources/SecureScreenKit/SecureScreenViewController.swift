//
//  SecureScreenViewController.swift
//  SecureScreenKit
//
//  Created by Byron on 4/22/25.
//

import UIKit

open class ScreenProtectedViewController: UIViewController {

    private var screenManager: SecureScreenKit?
    private var isProtectionEnabled = false

    open var screenProtectedDetectRecording: Bool { false }
    open var screenProtectedShowBlur: Bool { false }
    open var screenProtectedBlurStyle: UIBlurEffect.Style? { nil }
    open var screenProtectedOverlayColor: UIColor? { nil }
    open var screenProtectedOverlayImage: UIImage? { nil }

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

    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        screenManager?.disablePreventScreenshot()
        screenManager?.removeAllObserver()
        screenManager?.disableBlurScreen()
        screenManager?.disableColorScreen()
        screenManager?.disableImageScreen()

        isProtectionEnabled = false
    }

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
