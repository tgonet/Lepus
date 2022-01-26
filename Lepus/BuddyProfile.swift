//
//  BuddyProfile.swift
//  Lepus
//
//  Created by Tan Ming Zhe on 26/1/22.
//

import SwiftUI
import Firebase
import Kingfisher

struct BuddyProfile: View {
    @ObservedObject var firebaseManager:FirebaseManager = FirebaseManager()
    @ObservedObject var CDManager = CoreDataUserManager()
    @State var user:Firebase.User? = Auth.auth().currentUser
    @State private var tabBar: UITabBar! = nil
    @State private var friends:String = "false"
    
    init(){
        UITableView.appearance().backgroundColor = UIColor.clear
        firebaseManager.readRuns()
    }
    var body: some View {
            VStack{
                HStack{
                    KFImage.url(user?.photoURL)
                        .placeholder{Image("profileImg").clipShape(Circle()).frame(width: 65.0, height: 65.0).padding(.trailing,20)}
                        .resizable()
                        .loadDiskFileSynchronously()
                        .cacheOriginalImage()
                        .onProgress { receivedSize, totalSize in  }
                        .onSuccess { result in  }
                        .onFailure { error in }
                        .clipShape(Circle()).frame(width: 65.0, height: 65.0).padding(.trailing,20)
                    Text(user!.displayName!)
                    
                    Spacer()
                    
                    if friends == "pending" {
                        Button(action: {
                            //LogOut()
                        }, label: {
                            Text("Request Sent").foregroundColor(Color.black)
                            .font(Font.custom("Rubik-Medium", size:12)).padding(.horizontal, 20).padding(.vertical, 7)
                        }).overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color("AccentColor"), lineWidth: 1))
                    }
                    else if(friends == "false"){
                        Button(action: {
                            //LogOut()
                        }, label: {
                            Text("Add Buddy")
                            .font(Font.custom("Rubik-Medium", size:12)).foregroundColor(Color.black).padding(.horizontal, 20).padding(.vertical, 7)
                        }).background(Color("AccentColor")).clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    else {
                        Button(action: {}, label: {
                            Text("Buddies").foregroundColor(Color.black)
                                .font(Font.custom("Rubik-Medium", size:12)).padding(.horizontal, 20).padding(.vertical, 7)
                        }).overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color("AccentColor"), lineWidth: 1))
                    }
                }.padding(.horizontal, 15)//.padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)

                
                if (friends == "true") {
                    List(firebaseManager.runList.sorted(by: {$0.date > $1.date})) {run in
                        RunRow(run: run, url: user!.photoURL!)
                    }.listStyle(GroupedListStyle()).onAppear(perform: {
                        UITableView.appearance().contentInset.top = -35
                    })
                }
                else {
                    VStack {
                        Spacer()
                        Text("History will be shown once you guys are friends")
                        Spacer()
                    }
                    
                }
            }
                 
    }
}

struct BuddyProfile_Previews: PreviewProvider {
    static var previews: some View {
        BuddyProfile()
    }
}
