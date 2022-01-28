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
    var id:String
    var name:String
    var url:URL
    //@State var user:Firebase.User? = Auth.auth().currentUser
    @State private var tabBar: UITabBar! = UITabBar()
    @State private var friends:String = "pending"
    
    init(id:String, name:String, url:URL){
        UITableView.appearance().backgroundColor = UIColor.clear
        self.id = id
        self.name = name
        self.url = url
        tabBar.isHidden = true
    }
    
    var body: some View {
            VStack{
                HStack{
                    KFImage.url(url)
                        .placeholder{Image("profileImg").clipShape(Circle()).frame(width: 65.0, height: 65.0).padding(.trailing,20)}
                        .resizable()
                        .loadDiskFileSynchronously()
                        .cacheOriginalImage()
                        .onProgress { receivedSize, totalSize in  }
                        .onSuccess { result in  }
                        .onFailure { error in }
                        .clipShape(Circle()).frame(width: 65.0, height: 65.0).padding(.trailing,20)
                    Text(name)
                    
                    Spacer()
                    
                    if friends == "pending" {
                        Text("Request Sent")
                        .font(Font.custom("Rubik-Medium", size:12)).padding(.horizontal, 20).padding(.vertical, 7).overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color("AccentColor"), lineWidth: 1))
                    }
                    else if(friends == "false"){
                        Button(action: {
                            //LogOut()
                        }, label: {
                            Text("Add Buddy").foregroundColor(Color.black)
                            .font(Font.custom("Rubik-Medium", size:12)).padding(.horizontal, 20).padding(.vertical, 7)
                        }).background(Color("AccentColor")).clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    else {
                        Text("Buddies")
                            .font(Font.custom("Rubik-Medium", size:12)).padding(.horizontal, 20).padding(.vertical, 7).overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color("AccentColor"), lineWidth: 1))
                    }
                }.padding(.horizontal, 15).padding(.top)

                
                if (friends == "true") {
                    List(firebaseManager.runList.sorted(by: {$0.date > $1.date})) {run in
                        RunRow(run: run, url: url)
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
            }.background(Color("BackgroundColor")).background(TabBarAccessor { tabbar in   // << here !!
                self.tabBar = tabbar
                self.tabBar.isHidden = true
            }).onAppear(perform: {
                self.firebaseManager.readRuns(id: id)
            }).onChange(of: tabBar) { newImage in
                print(tabBar.isHidden)
                print("Changed")
                tabBar.isHidden = true
                
            }
    }
}

struct BuddyProfile_Previews: PreviewProvider {
    static var previews: some View {
        BuddyProfile(id: "1", name: "2", url: URL(string: "help")!)
    }
}
