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
    }
}

struct TabViewUI_Previews: PreviewProvider {
    static var previews: some View {
        TabViewUI()
    }
}
