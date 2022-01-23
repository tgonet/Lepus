//
//  LepusApp.swift
//  Lepus
//
//  Created by Tan Ming Zhe on 11/1/22.
//

import SwiftUI
import Firebase
import CoreData

@main
struct LepusApp: App {
    @UIApplicationDelegateAdaptor(Delegate.self) var delegate
    @ObservedObject var CDManager = CoreDataUserManager()
    
    var body: some Scene {
        WindowGroup {
            //let user:User = container.isLoggedIn()
            if (CDManager.user.userId != "")
            {
                TabViewUI()
            }
            else{
                StartView()
            }
            
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
