//
//  SwiftUIView.swift
//  Lepus
//
//  Created by Tan Ming Zhe on 15/1/22.
//

import SwiftUI
import Firebase
import CoreData
import MapKit

struct TabViewUI: View {
    let firebaseManager = FirebaseManager()
    var coreDataManager = CoreDataManager()
    @ObservedObject var networkManager = NetworkManager()
    var runList:[CDRun] = []
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor(Color("BackgroundColor"))
        if(networkManager.isConnected){
            runList = coreDataManager.getRuns()
            //print(runList.count)
            if(runList.count > 0){
                for run in runList {
                    firebaseManager.saveRun(duration: run.duration!, pace: run.pace, distance: run.distance, url: "", coord: CLLocationCoordinate2D(latitude: run.startLatitude, longitude: run.startLongitude))
                }
            }
                
        }
       }
    
    var body: some View {
        TabView {
            BuddyTabView()
                .tabItem{
                    Label("Buddies", systemImage:"person.2.fill")
                }
            RunTabView()
                .tabItem {
                    Label("Run",systemImage:"figure.walk")
                }
            
            ProfileTabView().tabItem{ Label("Profile", systemImage:"person.fill")}
        }.navigationBarHidden(true).navigationBarBackButtonHidden(true)
    }
}

struct TabViewUI_Previews: PreviewProvider {
    static var previews: some View {
        TabViewUI()
    }
}
