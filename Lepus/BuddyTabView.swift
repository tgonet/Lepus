//
//  BuddyTabView.swift
//  Lepus
//
//  Created by Aw Joey on 24/1/22.
//

import SwiftUI
import Kingfisher
import UIKit

struct BuddyTabView: View {
    @State var searchText = ""
    @ObservedObject var CDManager = CoreDataUserManager()
    @ObservedObject var FBManager:FirebaseManager = FirebaseManager()
    @State private var viewMoreRecos = false

    
    let messages = [
        Message(user: "Ming Zhe", datetime: Date(), message: "Hello, what time are we meeting?"),
        Message(user: "Zhi Qi", datetime:Date(), message:"Hi, I'm Zhi Qi! :)"),
        Message(user: "Zheng Hao", datetime:Date(), message:"Hi Joey!")
        ]
    
    var body: some View {
        ZStack{
            VStack{
                VStack{
                    HStack(alignment:.center, spacing:18){
                        Image(systemName: "magnifyingglass")
                        TextField("", text: $searchText)
                            .placeholder(when: searchText.isEmpty) {
                                Text("Find someone").foregroundColor(Color(UIColor.darkGray))
                            }
                            .autocapitalization(.none)
                            .font(Font.custom("Rubik-Regular", size:18))
                            .disableAutocorrection(true)
                        }
                        .padding(.vertical,12)
                        .padding(.horizontal)
                        .background(Color.white)
                        .foregroundColor(Color.black)
                        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 5, y: 5)
                        .shadow(color: Color.black.opacity(0.05), radius: 5, x: -5, y: -5)
                        .cornerRadius(10)
                        .padding()
                        .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)

                    HStack{
                        Text("Buddy Recommendations")
                            .font(Font.custom("Rubik-Medium", size:16))
                        Spacer()
                        NavigationLink(destination: BuddyRecoView(), isActive: $viewMoreRecos)
                        {EmptyView()}

                        Text("View more...")
                            .font(Font.custom("Rubik-Regular", size:14))
                            .onTapGesture {
                                viewMoreRecos = true
                            }
                            
                    }
                    .foregroundColor(Color.black)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal)
                    
                    ScrollView (.horizontal, showsIndicators: false) {
                        HStack{
                            if (FBManager.noStatistics)
                            {
                                Text("Start recording your runs to see buddy recommendations!")
                                    .font(Font.custom("Rubik-Regular", size:14))
                                    .frame(maxWidth:.infinity, alignment:.center)

                            }
                            else if (FBManager.noMatches)
                            {
                                Text("No matches found yet!")
                                    .font(Font.custom("Rubik-Regular", size:14))
                                    .frame(maxWidth:.infinity, alignment:.center)
                            }
                            else{
                                ForEach(FBManager.recoList) {
                                    user in BuddyRecommendationItem(id: user.id, url: URL(string:user.profilePic), name: user.name)
                                        .padding(8)
                                    }
                                }
                            }
            
                         }
                        .frame(height: 50)
                        .foregroundColor(Color.black)
                        .padding(.horizontal)
                        .padding(.vertical, 20)
                 }
                .padding(.vertical, 12)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color("DarkYellow"), Color("LightYellow")]),
                    startPoint: .bottomLeading, endPoint: .topLeading))
                .cornerRadius(radius:20, corner: .bottomLeft)
                .cornerRadius(radius:20, corner: .bottomRight)
                
                VStack{
                    HStack{
                        Text("Messages")
                            .font(Font.custom("Rubik-Medium", size:16))
                        Spacer()
                        Text("0 requests")
                            .font(Font.custom("Rubik-Regular", size:14))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal)
                    
                    List(messages) {
                        message in
                        MessageListItem(message:message)
                    }
                    .listStyle(GroupedListStyle()).onAppear(perform: {
                        UITableView.appearance().contentInset.top = -35
                    })
                    
                }
                .padding(.vertical, 12)
            }
 
            
        }
        .onAppear{
            FBManager.getBuddyRecos(records: 10, filter: "All")
        }
        .ignoresSafeArea(.all, edges: .top)
        .background(Color("BackgroundColor"))
    }
}

struct BuddyTabView_Previews: PreviewProvider {
    static var previews: some View {
        BuddyTabView()
    }
}

struct BuddyRecommendationItem:View{
    var id:String
    var url:URL?
    var name:String
    @State private var Redirect = false
    
    
    var body:some View{
        VStack{
            NavigationLink(destination: BuddyProfileView(id: id, name: name, url: url!).navigationBarTitleDisplayMode(.inline) , isActive: $Redirect) {EmptyView()}
            if(url != nil)
            {
                KFImage.url(url)
                    .resizable()
                    .clipShape(Circle())
                    .scaledToFill()
                    .frame(width: 60.0, height: 60.0)
            }
            else{
                Image("profileImg")
                    .resizable()
                    .clipShape(Circle()).frame(width: 60.0, height: 60.0)
            }
            Text(name)
                .font(Font.custom("Rubik-Regular", size:15))
        }
        .foregroundColor(Color.black).onTapGesture {
            Redirect = true
        }
    }
}

struct MessageListItem:View{
    var message:Message
    @State private var tabBar: UITabBar! = nil
    @State private var Redirect = false


    var body: some View {
        NavigationLink(destination: chatView(documentId:"docId"), isActive: $Redirect){
            HStack(alignment:.center){
                Image("profileImg")
                    .resizable()
                    .clipShape(Circle())
                    .scaledToFill()
                    .frame(width: 60.0, height: 60.0)
                VStack(alignment: .leading, spacing:10){
                    HStack{
                        
                        Text(message.user)
                            .font(Font.custom("Rubik-Medium", size:16))
                        Spacer()
                        let dateFormatter = DateFormatter()
                        let datetime =  dateFormatter.string(from: message.datetime)
                        Text(datetime)
                            .font(Font.custom("Rubik-Regular", size:14))
                    }
                    Text(message.message)
                        .font(Font.custom("Rubik-Regular", size:14))
                }
            }
        }
        .padding(.vertical, 8)
        .listRowBackground(Color("BackgroundColor"))
    }
}
