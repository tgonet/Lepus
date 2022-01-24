//
//  BuddyTabView.swift
//  Lepus
//
//  Created by Aw Joey on 24/1/22.
//

import SwiftUI
import Kingfisher

struct BuddyTabView: View {
    @State var searchText = ""
    @ObservedObject var CDManager = CoreDataUserManager()
    @ObservedObject var firebaseManager:FirebaseManager = FirebaseManager()
    //let user:Firebase.User = Auth.auth().currentUser!
    /*
    let users:[BuddyRecoUser] = [
        BuddyRecoUser(name: "Joey", profilePic: URL(string: "https://instagram.fsin2-1.fna.fbcdn.net/v/t51.2885-19/s320x320/51685961_246382309580298_7945062956360794112_n.jpg?_nc_ht=instagram.fsin2-1.fna.fbcdn.net&_nc_cat=106&_nc_ohc=df1nko7vrqMAX8etMpC&edm=ABfd0MgBAAAA&ccb=7-4&oh=00_AT8ksztLd0auWZhm_NVQheduCz7Lsz2VhzRIJXPQZn5qug&oe=61F3D2EF&_nc_sid=7bff83")),
        BuddyRecoUser(name: "Ye Cheng", profilePic: URL(string: "https://firebasestorage.googleapis.com/v0/b/lepus-d32ce.appspot.com/o/placeholder.jpeg?alt=media&token=1701b9cd-8f50-4a9a-bc99-cddb913c7ff0")),
        BuddyRecoUser(name: "Ming Zhe", profilePic: nil),
        BuddyRecoUser(name: "Joern", profilePic: URL(string: "")),
        BuddyRecoUser(name: "Zhi Qi", profilePic: URL(string: "")),
        BuddyRecoUser(name: "Wei Yang", profilePic: URL(string: "")),
        BuddyRecoUser(name: "Zheng Hao", profilePic: URL(string: "")),
        BuddyRecoUser(name: "Edgar", profilePic: URL(string: ""))
    ]
    
    let messages = [
        Message(user: "Ming Zhe", datetime: Date(), content: "Hello, what time are we meeting?"),
        Message(user: "Ye Cheng", datetime:Date(), content:"Hi, I'm Ye Cheng!"),
        Message(user: "Joey", datetime:Date(), content:"Hi there, I'm Joey!")
        ]
    */
    var body: some View {
        ZStack{
            VStack{
                VStack{
                    HStack(alignment:.center, spacing:18){
                        Image(systemName: "magnifyingglass")
                        TextField("Find someone", text: $searchText)
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
                        Text("View more...")
                            .font(Font.custom("Rubik-Regular", size:14))
                    }
                    .foregroundColor(Color.black)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal)
                    /*
                    ScrollView (.horizontal, showsIndicators: false) {
                        HStack{
                            ForEach(users) {
                                user in BuddyRecommendationItem(url: user.profilePic, name: user.name)
                                    .padding(8)
                                }
                            }
                            /*
                            ForEach(0...10, id: \.self) {
                                index in BuddyRecommendationItem()
                                    .padding(8)
                                }
                            }
                             */
                         }
                        .frame(height: 50)
                        .padding(.horizontal)
                        .padding(.vertical, 20)
                     */
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
                    /*
                    List(messages) {
                        message in
                        MessageListItem(message:message)
                    }
                    .listStyle(GroupedListStyle()).onAppear(perform: {
                        UITableView.appearance().contentInset.top = -35
                    })
                     */
                }
                .padding(.vertical, 12)
            }
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
    var url:URL?
    var name:String
    
    var body:some View{
        VStack{
            if(url != nil)
            {
                KFImage.url(url)
                    .resizable()
                    .clipShape(Circle()).frame(width: 60.0, height: 60.0)
            }
            else{
                Image("profileImg")
                    .resizable()
                    .clipShape(Circle()).frame(width: 60.0, height: 60.0)
            }
            Text(name)
                .font(Font.custom("Rubik-Regular", size:15))
        }
        .foregroundColor(Color.black)
    }
}

struct MessageListItem:View{
    var message:Message
    var body: some View{
        HStack(alignment:.center){
            Image("profileImg")
                .resizable()
                .clipShape(Circle()).frame(width: 60.0, height: 60.0)
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
                Text(message.content)
                    .font(Font.custom("Rubik-Regular", size:14))
            }
        }
        .padding(.vertical, 8)
        .listRowBackground(Color("BackgroundColor"))
    }
}
