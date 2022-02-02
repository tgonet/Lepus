//
//  RequestListView.swift
//  Lepus
//
//  Created by Tan Ming Zhe on 31/1/22.
//

import SwiftUI
import Kingfisher

struct RequestListView: View {
    @ObservedObject var firebaseManager = FirebaseManager()
    @State private var list:[BuddyRecoUser] = []
    
    var body: some View {
        VStack{
            HStack{
                Text("\(firebaseManager.requestList.count) Requests")
                    .font(Font.custom("Rubik-Medium", size:16))
                    .foregroundColor(Color("AccentColor2"))
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
            .padding(.top)
            
            List(firebaseManager.requestList){user in
                BuddyRequestListItem(user:user,firebaseManager: firebaseManager)
            }.listStyle(GroupedListStyle())
        }.background(Color("BackgroundColor"))
            .navigationTitle("Request List")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear(perform: {
                firebaseManager.getRequestList(completion: {reqList in
                    //list = reqList
                })
            })
    }
}

struct RequestListView_Previews: PreviewProvider {
    static var previews: some View {
        RequestListView()
    }
}

struct BuddyRequestListItem:View{
    @Environment(\.presentationMode) var presentationMode
    @State private var removeBuddy = false
    @State private var friends = "false"
    var user:BuddyRecoUser?
    @State private var selection = ""
    var firebaseManager:FirebaseManager

    var body: some View{
        ZStack{
            NavigationLink(destination: BuddyProfileView(id: user!.id, name: user!.name, url: URL(string: user!.profilePic)!))
            {
                EmptyView()
            }.opacity(0)
            HStack(alignment:.center){
                KFImage.url(URL(string: user!.profilePic))
                    .placeholder{Image("profileImg").clipShape(Circle()).frame(width: 60.0, height: 60.0).padding(.trailing,20)}
                    .resizable()
                    .loadDiskFileSynchronously()
                    .cacheOriginalImage()
                    .onProgress { receivedSize, totalSize in  }
                    .onSuccess { result in  }
                    .onFailure { error in }
                    .scaledToFill()
                    .clipShape(Circle()).frame(width: 65.0, height: 65.0).padding(.trailing,20) .onChange(of: user!.profilePic) { newImage in
                        
                }
                VStack(alignment: .leading, spacing:10){
                    HStack{
                        Text(user!.name)
                            .font(Font.custom("Rubik-Medium", size:16))
                        Spacer()
                        if(friends != "true"){
                            Button(action: {}, label: {
                                Text("Accept").foregroundColor(Color.black)
                                .font(Font.custom("Rubik-Medium", size:12)).padding(.horizontal, 20).padding(.vertical, 7)
                            }).background(Color("AccentColor")).clipShape(RoundedRectangle(cornerRadius: 8)).onTapGesture {
                                firebaseManager.acceptRequest(id: user!.id)
                                friends = "true"
                            }
                        }
                        else{
                            Text("Buddies")
                                .font(Font.custom("Rubik-Medium", size:12)).padding(.horizontal, 20).padding(.vertical, 7).overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color("AccentColor"), lineWidth: 1))
                        }
                    }
                    
                }
                .padding(.vertical, 8)
            }
        }.listRowBackground(Color("BackgroundColor")).listRowSeparator(.hidden)
    }
}

