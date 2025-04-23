//
//  SecureScreenKit.swift
//  SecureScreenKit
//
//  Created by Byron on 4/22/25.
//

import UIKit

/// A utility class for securing screen content by preventing screenshots,
/// detecting screen recordings, and applying visual overlays.
public class SecureScreenKit {

    private var window: UIWindow?

    private var screenImage: UIImageView?
    private var screenBlur: UIView?
    private var screenColor: UIView?
    private var screenPrevent = UITextField()

    private var screenshotObserve: NSObjectProtocol?
    private var screenRecordObserve: NSObjectProtocol?

    /// Initializes the kit with an optional UIWindow reference.
    public init(window: UIWindow?) {
        self.window = window
    }

    /// Configures the secure input field to enable screenshot prevention.
    public func configurePreventionScreenshot() {
        guard let window else { return }

        if !window.subviews.contains(screenPrevent) {
            window.addSubview(screenPrevent)

            NSLayoutConstraint.activate([
                screenPrevent.centerYAnchor.constraint(equalTo: window.centerYAnchor),
                screenPrevent.centerXAnchor.constraint(equalTo: window.centerXAnchor)
            ])

            window.layer.superlayer?.addSublayer(screenPrevent.layer)

            if #available(iOS 17.0, *) {
                screenPrevent.layer.sublayers?.last?.addSublayer(window.layer)
            } else {
                screenPrevent.layer.sublayers?.first?.addSublayer(window.layer)
            }
        }
    }

    /// Enables screenshot prevention using the secure text entry field.
    public func enabledPreventScreenshot() {
        screenPrevent.isSecureTextEntry = true
    }

    /// Disables screenshot prevention.
    public func disablePreventScreenshot() {
        screenPrevent.isSecureTextEntry = false
    }

    /// Applies a blur overlay to the window.
    public func enabledBlurScreen(style: UIBlurEffect.Style = .light) {
        screenBlur = UIScreen.main.snapshotView(afterScreenUpdates: false)

        let blurEffect = UIBlurEffect(style: style)
        let blurBackground = UIVisualEffectView(effect: blurEffect)

        screenBlur?.addSubview(blurBackground)

        guard let screenBlur else { return }

        blurBackground.frame = (screenBlur.frame)

        window?.addSubview(screenBlur)
    }

    /// Removes the blur overlay.
    public func disableBlurScreen() {
        screenBlur?.removeFromSuperview()
        screenBlur = nil
    }

    /// Applies a solid color overlay to the window.
    public func enabledColorScreen(color: UIColor) {
        guard let window else { return }
        screenColor = UIView(frame: window.bounds)

        guard let view = screenColor else { return }

        view.backgroundColor = color

        window.addSubview(view)
    }

    /// Removes the color overlay.
    public func disableColorScreen() {
        screenColor?.removeFromSuperview()
        screenColor = nil
    }

    /// Applies an image overlay to the window.
    public func enabledImageScreen(image: UIImage) {
        screenImage = UIImageView(frame: UIScreen.main.bounds)

        screenImage?.image = image
        screenImage?.isUserInteractionEnabled = false
        screenImage?.contentMode = .scaleAspectFill
        screenImage?.clipsToBounds = true

        guard let screenImage else { return }

        window?.addSubview(screenImage)
    }

    /// Removes the image overlay.
    public func disableImageScreen() {
        screenImage?.removeFromSuperview()
        screenImage = nil
    }

    /// Removes a specific notification observer if it exists.
    public func removeObserver(observer: NSObjectProtocol?) {
        guard let observer else { return }

        NotificationCenter.default.removeObserver(observer)
    }

    /// Removes the screenshot observer.
    public func removeScreenshotObserver() {
        if screenshotObserve != nil {
            removeObserver(observer: screenshotObserve)

            screenshotObserve = nil
        }
    }

    /// Removes the screen recording observer.
    public func removeScreenRecordObserver() {
        if screenRecordObserve != nil {
            removeObserver(observer: screenRecordObserve)

            screenRecordObserve = nil
        }
    }

    /// Removes all screenshot and screen recording observers.
    public func removeAllObserver() {
        removeScreenshotObserver()
        removeScreenRecordObserver()
    }

    /// Sets up a listener for screenshot events.
    public func screenshotObserver(using onScreenshot: @escaping () -> Void) {
        screenshotObserve = NotificationCenter.default.addObserver(
            forName: UIApplication.userDidTakeScreenshotNotification,
            object: nil,
            queue: .main
        ) { _ in
            onScreenshot()
        }
    }

    /// Sets up a listener for screen recording changes.
    @available(iOS 11.0, *)
    public func screenRecordObserver(using onScreenRecord: @escaping (Bool) -> Void) {
        screenRecordObserve = NotificationCenter.default.addObserver(
            forName: UIScreen.capturedDidChangeNotification,
            object: nil,
            queue: .main
        ) { _ in
            onScreenRecord(UIScreen.main.isCaptured)
        }
    }

    /// Checks whether the screen is currently being recorded.
    @available(iOS 11.0, *)
    public func screenIsRecording() -> Bool {
        UIScreen.main.isCaptured
    }
}
