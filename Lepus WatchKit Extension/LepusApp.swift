//
//  LepusApp.swift
//  Lepus WatchKit Extension
//
//  Created by Tan Ming Zhe on 11/1/22.
//

import SwiftUI

@main
struct LepusApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
