//
//  SecureScreenKit.swift
//  SecureScreenKit
//
//  Created by Byron on 4/22/25.
//

import UIKit

public class SecureScreenKit {

    private var window: UIWindow?

    private var screenImage: UIImageView?
    private var screenBlur: UIView?
    private var screenColor: UIView?
    private var screenPrevent = UITextField()

    private var screenshotObserve: NSObjectProtocol?
    private var screenRecordObserve: NSObjectProtocol?

    public init(window: UIWindow?) {
        self.window = window
    }

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

    public func enabledPreventScreenshot() {
        screenPrevent.isSecureTextEntry = true
    }

    public func disablePreventScreenshot() {
        screenPrevent.isSecureTextEntry = false
    }

    public func enabledBlurScreen(style: UIBlurEffect.Style = .light) {
        screenBlur = UIScreen.main.snapshotView(afterScreenUpdates: false)

        let blurEffect = UIBlurEffect(style: style)
        let blurBackground = UIVisualEffectView(effect: blurEffect)

        screenBlur?.addSubview(blurBackground)

        guard let screenBlur else { return }

        blurBackground.frame = (screenBlur.frame)

        window?.addSubview(screenBlur)
    }

    public func disableBlurScreen() {
        screenBlur?.removeFromSuperview()
        screenBlur = nil
    }

    public func enabledColorScreen(color: UIColor) {
        guard let window else { return }
        screenColor = UIView(frame: window.bounds)

        guard let view = screenColor else { return }

        view.backgroundColor = color

        window.addSubview(view)
    }

    public func disableColorScreen() {
        screenColor?.removeFromSuperview()
        screenColor = nil
    }

    public func enabledImageScreen(image: UIImage) {
        screenImage = UIImageView(frame: UIScreen.main.bounds)

        screenImage?.image = image
        screenImage?.isUserInteractionEnabled = false
        screenImage?.contentMode = .scaleAspectFill
        screenImage?.clipsToBounds = true

        guard let screenImage else { return }

        window?.addSubview(screenImage)
    }

    public func disableImageScreen() {
        screenImage?.removeFromSuperview()
        screenImage = nil
    }

    public func removeObserver(observer: NSObjectProtocol?) {
        guard let observer else { return }

        NotificationCenter.default.removeObserver(observer)
    }

    public func removeScreenshotObserver() {
        if screenshotObserve != nil {
            removeObserver(observer: screenshotObserve)

            screenshotObserve = nil
        }
    }

    public func removeScreenRecordObserver() {
        if screenRecordObserve != nil {
            removeObserver(observer: screenRecordObserve)

            screenRecordObserve = nil
        }
    }

    public func removeAllObserver() {
        removeScreenshotObserver()
        removeScreenRecordObserver()
    }

    public func screenshotObserver(using onScreenshot: @escaping () -> Void) {
        screenshotObserve = NotificationCenter.default.addObserver(
            forName: UIApplication.userDidTakeScreenshotNotification,
            object: nil,
            queue: .main
        ) { _ in
            onScreenshot()
        }
    }

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

    @available(iOS 11.0, *)
    public func screenIsRecording() -> Bool {
        UIScreen.main.isCaptured
    }
}
