//
//  BuddyListView.swift
//  Lepus
//
//  Created by Tan Ming Zhe on 27/1/22.
//

import SwiftUI
import Kingfisher

struct BuddyListView: View {
    @ObservedObject var firebaseManager = FirebaseManager()
    @State private var buddyList:[BuddyRecoUser] = []
    
    init() {
        UITableView.appearance().backgroundColor = UIColor(Color("BackgroundColor"))
    }
    
    var body: some View {
        VStack {
            NavigationLink(destination: RequestListView())
                        {
                            HStack{
                                VStack (alignment: .leading){
                                    Text("Follow Request").foregroundColor(Color("AccentColor2"))
                                    Text("Approve or Delete requests").font(Font.custom("Rubik-Regular", size:14)).foregroundColor(Color("TextColor"))
                                }
                                Spacer()
                            }.frame(maxWidth: .infinity).padding(.horizontal).padding(.top)
                        }
            HStack{
                Text("\(firebaseManager.buddyList.count) Buddies")
                    .font(Font.custom("Rubik-Medium", size:16))
                    .foregroundColor(Color("AccentColor2"))
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
            .padding(.top)
            
            List(firebaseManager.buddyList){user in
                BuddyListItem(user:user,firebaseManager: firebaseManager)
            }.listStyle(GroupedListStyle())
        }.background(Color("BackgroundColor"))
            .navigationTitle("Buddy List")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear(perform: {
                firebaseManager.getBuddyList(completion: { budList in
                    //buddyList = budList
                })
            })
    }
}

struct BuddyListView_Previews: PreviewProvider {
    static var previews: some View {
        BuddyListView()
    }
}

struct BuddyListItem:View{
    @Environment(\.presentationMode) var presentationMode
    @State private var removeBuddy = false
    var user:BuddyRecoUser?
    @State private var selection = ""
    var firebaseManager:FirebaseManager

    var body: some View{
        ZStack{
            NavigationLink(destination: BuddyProfileView(id: user!.id, name: user!.name, url: URL(string: user!.profilePic)!))
            {
                EmptyView()
            }.opacity(0)
            HStack(alignment: .center){
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
                        Button(action:{}, label:{
                        Text("Buddies")
                            .font(Font.custom("Rubik-Medium", size:12))
                            .padding(.horizontal, 20)
                            .padding(.vertical, 7)
                            .overlay(RoundedRectangle(cornerRadius: 8)
                            .stroke(Color("AccentColor"), lineWidth: 1))
                        }).onTapGesture {
                            removeBuddy = true
                        }.confirmationDialog("Confirm to remove buddy?", isPresented: $removeBuddy, titleVisibility: .visible) {
                            Button("Stay Buddies") {}
                            Button("Remove Buddy", role: .destructive) {
                                firebaseManager.removeBuddy(bUser: user!)
                            }
                        }
                    }
                }
                .padding(.vertical, 8)
                .listRowBackground(Color("BackgroundColor")).listRowSeparator(.hidden)
            }
        }
    }
        
}
