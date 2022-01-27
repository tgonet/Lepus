//
//  Splashscreen.swift
//  Lepus
//
//  Created by Tan Ming Zhe on 27/1/22.
//

import SwiftUI
import Firebase

struct Splashscreen: View {
    
    @ObservedObject var CDManager = CoreDataUserManager()
    @State private var isActiveTab = false
    @State private var isActiveStart = false
    
    var body: some View {
        NavigationView{
            ZStack{
                Spacer()
                Image("Logo").resizable().frame(width: UIScreen.main.bounds.width * 0.6, height: UIScreen.main.bounds.height * 0.15)
                Spacer()
                NavigationLink(destination: TabViewUI(),
                                               isActive: $isActiveTab,
                                               label: { EmptyView() })
                NavigationLink(destination: StartView(),
                                               isActive: $isActiveStart,
                                               label: { EmptyView() })
            }.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height).background(Color("BackgroundColor")).onAppear(perform: {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        if (CDManager.user?.userId != "")
                        {
                            isActiveTab = true
                        }
                        else{
                            isActiveStart = true
                        }
                    }
            })
        }.navigationBarBackButtonHidden(true).navigationBarHidden(true).navigationViewStyle(StackNavigationViewStyle())
    }
}

struct Splashscreen_Previews: PreviewProvider {
    static var previews: some View {
        Splashscreen()
    }
}
