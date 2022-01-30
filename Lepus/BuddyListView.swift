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
    @State private var tabBar: UITabBar! = nil
    
    init() {
        UITableView.appearance().backgroundColor = UIColor(Color("BackgroundColor"))
    }
    
    var body: some View {
        VStack {
            /*
            VStack{
                Text("Buddy Count : 10").font(Font.custom("Rubik-Medium", size:20))
            }.padding(20).background(Color("AccentColor")).clipShape(RoundedRectangle(cornerRadius: 8))
             */
            HStack{
                Text("\(firebaseManager.recoList.count) Buddies")
                    .font(Font.custom("Rubik-Medium", size:16))
                    .foregroundColor(Color("AccentColor2"))
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
            .padding(.top)
            
            List(firebaseManager.recoList){user in
                BuddyListItem(user:user,firebaseManager: firebaseManager)
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
    @Environment(\.presentationMode) var presentationMode
    @State private var Redirect = false
    @State private var removeBuddy = false
    var user:BuddyRecoUser?
    @State private var selection = ""
    var firebaseManager:FirebaseManager

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
                    Spacer()
                    Button(action:{removeBuddy = true}, label:{
                    Text("Buddies")
                        .font(Font.custom("Rubik-Medium", size:12))
                        .padding(.horizontal, 20)
                        .padding(.vertical, 7)
                        .overlay(RoundedRectangle(cornerRadius: 8)
                        .stroke(Color("AccentColor"), lineWidth: 1))
                    })
                        .confirmationDialog("Confirm to remove buddy?", isPresented: $removeBuddy, titleVisibility: .visible) {
                        Button("Stay Buddies") {}
                        Button("Remove Buddy", role: .destructive) {
                            firebaseManager.removeBuddy(bUser: user!)
                        }
                    }
//                        .alert(isPresented: $removeBuddy)
//                        {
//                            Alert(title: Text("Confirm to remove buddy?"),
//                              primaryButton: .default(Text("Stay Buddies")),
//                              secondaryButton: .destructive(Text("Remove Buddy"))
//                              )
//                        }
                             
                }
                NavigationLink(destination: BuddyProfileView(id: user!.id, name: user!.name, url: URL(string: user!.profilePic)!), isActive: $Redirect)
                {EmptyView()}
                .hidden()
                .frame(width:0)
            }
            .padding(.vertical, 8)
            .listRowBackground(Color("BackgroundColor")).listRowSeparator(.hidden)
        }.onTapGesture {Redirect = true}
    }

}
