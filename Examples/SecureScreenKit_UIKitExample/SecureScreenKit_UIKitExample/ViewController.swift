//
//  ViewController.swift
//  SecureScreenKit_UIKitExample
//
//  Created by Byron on 4/22/25.
//

import UIKit
import SecureScreenKit

class ViewController: SecureScreenViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func didTapButton(_ sender: Any) {
        NotificationCenter.default.post(
            name: UIApplication.userDidTakeScreenshotNotification,
            object: nil
        )

        presentScreenshotAlert()
    }
}

private extension ViewController {

    func presentScreenshotAlert() {
        let alert = UIAlertController(
            title: "Screenshot Detected",
            message: "This alert simulates a screenshot detection.",
            preferredStyle: .alert
        )

        alert.addAction(
            UIAlertAction(
                title: "OK",
                style: .default
            )
        )

        present(alert, animated: true)
    }
}
