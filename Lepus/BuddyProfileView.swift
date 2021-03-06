//
//  BuddyProfile.swift
//  Lepus
//
//  Created by Tan Ming Zhe on 26/1/22.
//

import SwiftUI
import Firebase
import Kingfisher

struct BuddyProfileView: View {
    @ObservedObject var firebaseManager:FirebaseManager = FirebaseManager()
    @ObservedObject var CDManager = CoreDataUserManager()
    @State private var removeBuddy = false
    var id:String
    var name:String
    var url:URL
    @State private var friends:String = ""
    
    init(id:String, name:String, url:URL){
        UITableView.appearance().backgroundColor = UIColor(Color("BackgroundColor"))
        self.id = id
        self.name = name
        self.url = url
        firebaseManager.readRuns(id: id)
        firebaseManager.getBuddyList(completion: { budList in
            //buddyList = budList
        })
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
                        .clipShape(Circle())
                        .scaledToFill()
                        .frame(width: 65.0, height: 65.0).padding(.trailing,20)
                    Text(name)
                    
                    Spacer()
                    
                    if (friends == "pending") {
                        Text("Request Sent")
                        .font(Font.custom("Rubik-Medium", size:12)).padding(.horizontal, 20).padding(.vertical, 7).overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color("DarkYellow"), lineWidth: 1.5)).onTapGesture {
                                    firebaseManager.removeRequest(id: id)
                                    friends = "false"
                                }
                         
                    }
                    else if(friends == "false"){
                        Button(action: {
                            firebaseManager.makeRequest(id: id)
                            friends = "pending"
                        }, label: {
                            Text("Add Buddy").foregroundColor(Color.black)
                            .font(Font.custom("Rubik-Medium", size:12)).padding(.horizontal, 20).padding(.vertical, 7)
                        }).background(Color("AccentColor")).clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    else if(friends == "toAccept"){
                        Button(action: {
                            firebaseManager.acceptRequest(id: id)
                            friends = "true"
                        }, label: {
                            Text("Accept").foregroundColor(Color.black)
                            .font(Font.custom("Rubik-Medium", size:12)).padding(.horizontal, 20).padding(.vertical, 7)
                        }).background(Color("AccentColor")).clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    else {
                        Text("Buddies")
                            .font(Font.custom("Rubik-Medium", size:12)).padding(.horizontal, 20).padding(.vertical, 7).overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color("DarkYellow"), lineWidth: 1.5)).onTapGesture {
                                        removeBuddy = true
                                    }.confirmationDialog("Confirm to remove buddy?", isPresented: $removeBuddy, titleVisibility: .visible) {
                                        Button("Stay Buddies") {}
                                        Button("Remove Buddy", role: .destructive) {
                                            firebaseManager.removeBuddy(bUser: BuddyRecoUser(id: id, name: name, profilePic: ""))
                                            friends = "false"
                                        }
                                    }
                    }
                }.padding(.horizontal, 15).padding(.top)

                if (friends == "true") {
                    if (firebaseManager.runList.count == 0){
                        VStack {
                            Spacer()
                            Text("Friend does not have any run!")
                            Spacer()
                        }
                    }
                    else{
                        List(firebaseManager.runList) {run in
                            RunRow(run: run, url: url)
                        }.listStyle(GroupedListStyle()).onAppear(perform: {
                            UITableView.appearance().contentInset.top = -35
                        })
                    }
                    
                }
                else {
                    VStack {
                        Spacer()
                        Text("History will be shown once you guys are friends")
                        Spacer()
                    }
                }
            }.background(Color("BackgroundColor")).navigationBarBackButtonHidden(false).onAppear(perform: {
                firebaseManager.isBuddy(buddyId: id, completion: {(result)-> Void in
                    self.friends = result
                })
            })
    }
}

struct BuddyProfile_Previews: PreviewProvider {
    static var previews: some View {
        BuddyProfileView(id: "1", name: "2", url: URL(string: "help")!)
    }
}
