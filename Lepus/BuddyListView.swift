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
    
    init() {
        UITableView.appearance().backgroundColor = UIColor(Color("BackgroundColor"))
    }
    
    var body: some View {
        VStack(spacing:10) {
            /*
            VStack{
                Text("Buddy Count : 10").font(Font.custom("Rubik-Medium", size:20))
            }.padding(20).background(Color("AccentColor")).clipShape(RoundedRectangle(cornerRadius: 8))
             */
            HStack{
                Text("\(firebaseManager.recoList.count) Buddies")
                    .font(Font.custom("Rubik-Medium", size:16))
                Spacer()
            }
            .foregroundColor(Color.black)
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
            
            List(firebaseManager.recoList){user in
                BuddyListItem(user:user)
            }.listStyle(GroupedListStyle())
        }.background(Color("BackgroundColor")).navigationTitle("Buddy List").navigationBarTitleDisplayMode(.inline).onAppear(perform: {firebaseManager.getBuddyList()})
    }
}

struct BuddyListView_Previews: PreviewProvider {
    static var previews: some View {
        BuddyListView()
    }
}

struct BuddyListItem:View{
    @State private var showAlert = false
    @State private var tabBar: UITabBar! = nil
    @State private var Redirect = false
    var user:BuddyRecoUser?

    var body: some View{
        
        HStack(alignment:.center){
            KFImage.url(URL(string: user!.profilePic))
                .placeholder{Image("profileImg").clipShape(Circle()).frame(width: 60.0, height: 60.0).padding(.trailing,20)}
                .resizable()
                .loadDiskFileSynchronously()
                .cacheOriginalImage()
                .onProgress { receivedSize, totalSize in  }
                .onSuccess { result in  }
                .onFailure { error in }
                .clipShape(Circle()).frame(width: 65.0, height: 65.0).padding(.trailing,20) .onChange(of: user!.profilePic) { newImage in
                    //updateUserImage()
                }
            VStack(alignment: .leading, spacing:10){
                HStack{
                    Text(user!.name)
                        .font(Font.custom("Rubik-Medium", size:16))
                }
            }
            
//            NavigationLink(destination: chatView(message: message)
//                    .onAppear { self.tabBar.isHidden = true }
//                            .onDisappear { self.tabBar.isHidden = false } , isActive: $Redirect) {}
        }
        .alert(isPresented: $showAlert){
            Alert(title: Text(String(Redirect)), message: Text("Password and Confirm Password do not match"), dismissButton: .default(Text("Ok")))
        }
        .onTapGesture {
                      showAlert = true
                      Redirect = true
                  }
        .padding(.vertical, 8)
        .listRowBackground(Color("BackgroundColor")).listRowSeparator(.hidden)
    }
}

