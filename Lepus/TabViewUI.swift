//
//  SwiftUIView.swift
//  Lepus
//
//  Created by Tan Ming Zhe on 15/1/22.
//

import SwiftUI

struct TabViewUI: View {
    init() {
           UITabBar.appearance().backgroundColor = UIColor(Color("BackgroundColor"))
       }
    
    var body: some View {
        NavigationView {
            TabView {
                RunTabView()
                    .tabItem {
                        Label("Run",systemImage:"figure.walk")
                    }
                
                HistoryView().tabItem{ Label("History", systemImage:"list.dash")}
            }
        }.navigationBarHidden(true).navigationBarBackButtonHidden(true)
        TabView {
            BuddyView()
                .tabItem{
                    Label("Buddies", systemImage:"person.2.fill")
                }
            RunTabView()
                .tabItem {
                    Label("Run",systemImage:"figure.walk")
                }
            
            HistoryView()
                .tabItem{
                    Label("History", systemImage:"list.dash")
                }
        }
    }
}

struct TabViewUI_Previews: PreviewProvider {
    static var previews: some View {
        TabViewUI()
    }
}
