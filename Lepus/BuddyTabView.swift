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
    @State private var viewRequests = false
    @State private var buddyList:[BuddyRecoUser] = []
    
    
    init(){
        
    }
    var body: some View {
        ZStack{
            VStack{
                VStack{
                    
                    Image("LogoBlack")
                        .resizable()
                        .opacity(0.75)
                        .aspectRatio(contentMode: .fit)
                        .frame(width:70)
                        .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
                     
                    HStack(alignment:.center, spacing:18){
                        Image(systemName: "magnifyingglass")
                        TextField("", text: $searchText)
                            .placeholder(when: searchText.isEmpty) {
                                Text("Find buddy").foregroundColor(Color(UIColor.darkGray))
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
                        //.padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)

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
                                    .font(Font.custom("Rubik-Regular", size:12))
                                    
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
                        Text("\(FBManager.requestList.count) requests")
                            .font(Font.custom("Rubik-Regular", size:14))
                            .onTapGesture {
                                viewRequests = true
                            }
                        NavigationLink(destination: RequestListView(), isActive: $viewRequests)
                        {EmptyView()}
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal)
                
                    List(searchResults){ message in
                        let buddy = FBManager.buddyList.first(where: {$0.id == message.friendID!})
                        if(buddy != nil){
                            MessageListItem(buddy: buddy, message: message)
                        }
                        
                    }
                    .listStyle(GroupedListStyle()).onAppear(perform: {
                        UITableView.appearance().contentInset.top = -35
                        FBManager.messageList.forEach({ i in
                            if FBManager.buddyList.first(where: {$0.id == i.friendID!}) != nil{
                                var item:BuddyRecoUser = FBManager.buddyList.first(where: {$0.id == i.friendID!})!
                            }
                        })

                    })
                 
                    
                }
                .padding(.vertical, 12)
                 
            }
        }
                 
        .onAppear{
            FBManager.getBuddyRecos(records: 10, filter: "All")
            FBManager.getRequestList()
            FBManager.getBuddyList { result in
                FBManager.getLatestMessageList()
            }
        }
        .ignoresSafeArea(.all, edges: .top)
        .background(Color("BackgroundColor"))
    }
    var searchResults: [Message] {
            if searchText.isEmpty {
                return FBManager.messageList
            } else {
                return FBManager.messageList.filter {
                    let friendId = $0.friendID
                    let buddy = FBManager.buddyList.first(where: {$0.id == friendId})
                    return buddy!.name.lowercased().contains(searchText) }
            }
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
    var buddy:BuddyRecoUser?
    @State private var tabBar: UITabBar! = nil
    @State private var Redirect = false
    var message:Message

    var body: some View {
        ZStack{
            NavigationLink(destination: chatView(documentId: message.id!,buddy:buddy!), isActive: $Redirect){
                EmptyView()
            }.opacity(0)
            HStack(alignment:.center){
                Image("profileImg")
                    .resizable()
                    .clipShape(Circle())
                    .scaledToFill()
                    .frame(width: 60.0, height: 60.0)
                VStack(alignment: .leading, spacing:10){
                    HStack{
                        
                        Text(buddy!.name)
                            .font(Font.custom("Rubik-Medium", size:16))
                        Spacer()
                        
                        if (compareDates())
                        {
                            Text(message.datetime, style: .time)
                                .font(Font.custom("Rubik-Regular", size:14))
                        }
                        else
                        {
                            Text(message.datetime, style: .date)
                                .font(Font.custom("Rubik-Regular", size:14))
                        }
                    }
                    HStack(alignment: .center, spacing: 0) {

                        Text(message.message)
                            .font(Font.custom("Rubik-Regular", size:14))
                        Spacer()
                    }
                    
                }
            }.padding(.vertical, 8)
                
        }.listRowBackground(Color("BackgroundColor"))
    }
    
    func compareDates()->Bool
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        let datetime =  dateFormatter.string(from: message.datetime)
        let dateNow = dateFormatter.string(from: Date.now)
        return (datetime == dateNow)
    }
}
