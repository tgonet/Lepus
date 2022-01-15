//
//  LepusApp.swift
//  Lepus
//
//  Created by Tan Ming Zhe on 11/1/22.
//

import SwiftUI
import Firebase

@main
struct LepusApp: App {
    @UIApplicationDelegateAdaptor(Delegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            RunView()
        }
    }
}

//Initialize Firebase

class Delegate: NSObject, UIApplicationDelegate{
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
    
    
    
}
