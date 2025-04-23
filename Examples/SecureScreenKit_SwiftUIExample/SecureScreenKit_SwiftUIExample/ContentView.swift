//
//  ContentView.swift
//  SecureScreenKit_SwiftUIExample
//
//  Created by Byron on 4/22/25.
//

import SwiftUI
import SecureScreenKit

struct ContentView: View {

    @State private var showAlert = false

    var body: some View {
        VStack(spacing: 24) {
            Text("Protected Screen")
                .font(.largeTitle)
                .bold()

            Text("This view blocks screenshots and detects screen recording.")
                .multilineTextAlignment(.center)

            Image(systemName: "eye.slash.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.red)

            Button("Simulate Screenshot") {
                NotificationCenter.default.post(name: UIApplication.userDidTakeScreenshotNotification, object: nil)
                showAlert = true
            }
            .padding()
            .background(.blue)
            .foregroundColor(.white)
            .cornerRadius(12)
        }
        .padding()
        .screenProtected(
            detectRecording: true,
            blurStyle: .dark,
            onRecordingChange: { isRecording in
                print("Recording? \(isRecording)")
            }
        )
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Screenshot Detected"),
                message: Text("This alert simulates a screenshot detection."),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}
