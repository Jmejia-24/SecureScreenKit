//
//  SecureScreenManager.swift
//  SecureScreenKit
//
//  Created by Byron on 4/22/25.
//

import UIKit

public final class SecureScreenManager {

    private var screenProtector: SecureScreenKit?

    public init() {}

    public func enable(recordingDetection: Bool = false, onRecordingChange: ((Bool) -> Void)? = nil) {
        guard let window = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow }) else {
#if DEBUG
            print("⚠️ SecureScreen:  No active UIWindow found")
#endif
            return
        }

        let protector = SecureScreenKit(window: window)
        protector.configurePreventionScreenshot()
        protector.enabledPreventScreenshot()
        self.screenProtector = protector

        if recordingDetection, #available(iOS 11.0, *) {
            protector.screenRecordObserver { isCaptured in
                onRecordingChange?(isCaptured)
            }
        }
    }

    public func disable() {
        screenProtector?.disablePreventScreenshot()
        screenProtector?.removeAllObserver()
        screenProtector = nil
    }

    public var raw: SecureScreenKit? {
        return screenProtector
    }
}
