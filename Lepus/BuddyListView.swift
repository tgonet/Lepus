//
//  BuddyListView.swift
//  Lepus
//
//  Created by Tan Ming Zhe on 27/1/22.
//

import SwiftUI

struct BuddyListView: View {
    
    init() {
        UITableView.appearance().backgroundColor = UIColor(Color("BackgroundColor"))
    }
    
    var body: some View {
        VStack {
            VStack{
                Text("Buddy Count : 10").font(Font.custom("Rubik-Medium", size:20))
            }.padding(20).background(Color("AccentColor")).clipShape(RoundedRectangle(cornerRadius: 8))
            List{
                BuddyListItem()
            }.listStyle(GroupedListStyle())
        }.background(Color("BackgroundColor")).navigationTitle("Buddy List").navigationBarTitleDisplayMode(.inline)
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

    var body: some View{
        
        HStack(alignment:.center){
    
            Image("profileImg")
                .resizable()
                .clipShape(Circle()).frame(width: 60.0, height: 60.0)
            VStack(alignment: .leading, spacing:10){
                HStack{
                    Text("Name")
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

