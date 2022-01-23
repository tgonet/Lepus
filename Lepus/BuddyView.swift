//
//  BuddyView.swift
//  Lepus
//
//  Created by Aw Joey on 22/1/22.
//

import SwiftUI
import Firebase

struct BuddyView: View {
    @State var searchText = ""
    @ObservedObject var CDManager = CoreDataUserManager()
    @ObservedObject var firebaseManager:FirebaseManager = FirebaseManager()
    //let user:Firebase.User = Auth.auth().currentUser!
    
    var body: some View {
        ZStack{
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

                HStack{
                    Text("Buddy Recommendations")
                        .font(Font.custom("Rubik-Medium", size:16))
                    Spacer()
                    Text("View more...")
                        .font(Font.custom("Rubik-Regular", size:16))
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
                /*
                List(CDManager.buddies) {buddy in
                    BuddyRecommendation(url: Auth.auth().currentUser!.photoURL ?? URL(string: ""), name: Auth.auth().currentUser!.displayName)
                    }.listStyle(GroupedListStyle())

                ScrollView (.horizontal, showsIndicators: false) {
                    HStack{
                        ForEach(var buddy in CoreDataManager().getBuddies())
                            {
                                BuddyRecommendation(url:buddy.getProfilePic(), name:buddy.name)
                            }
                        }
                     }
                 }
                 */
                .frame(height: 50)
                .padding(.horizontal)
            }
            .padding(.vertical, 12)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color("DarkYellow"), Color("LightYellow")]),
                    startPoint: .bottomLeading, endPoint: .topLeading))
                .cornerRadius(radius:20, corner: .bottomLeft)
                .cornerRadius(radius:20, corner: .bottomRight)
            Spacer()
        }
        .ignoresSafeArea(.all, edges: .top)
        .background(Color("BackgroundColor"))
    }
}

struct BuddyView_Previews: PreviewProvider {
    static var previews: some View {
        BuddyView()
    }
}

struct BuddyRecommmendation:View{
    var url:URL?
    var name:String?
    
    var body:some View{
        VStack{
            if(url == URL(string:"")){
                Image("profileImg")
                    .resizable()
                    .clipShape(Circle()).frame(width: 35.0, height: 35.0)
            }
            else{
                AsyncImage(url: url) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .clipShape(Circle()).frame(width: 35.0, height: 35.0)
            }
        }
    }
}
/*
struct BuddyRecommendation: PreviewProvider {
    static var previews: some View {
        BuddyRecommendation()
    }
}
*/
