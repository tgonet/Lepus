//  chatRow.swift
//  Lepus
//
//  Created by mad2 on 24/1/22.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct chatRow: View {
    var chatData: Message
    @ObservedObject var CDManager = CoreDataUserManager()
    


    var body: some View {
        let user = CDManager.user!
        let uid = user.userId
        HStack(spacing:15){
            //Nickname view
            if chatData.user != uid {
                NickName(name:chatData.user)
            }
            
            if chatData.user == uid{Spacer(minLength: 0)}
            
            VStack(alignment: chatData.user == uid ? .trailing: .leading, spacing: 5, content:{
                Text(chatData.content)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color("Color"))
                    //Custom Shape
                    .clipShape(chatBubble(myMsg: chatData.user == uid))
                let dateFormatter = DateFormatter()
                let datetime =  dateFormatter.string(from: chatData.datetime)
                Text(datetime)
                    .font(Font.custom("Sansita-BoldItalic", size:20))
                    .foregroundColor(.gray)
                    .padding(chatData.user == uid ? .leading: .trailing , 10)
         
            })
            
            if chatData.user == uid {
                NickName(name:chatData.user)
            }
            
            if chatData.user != uid{Spacer(minLength: 0)}
        }
        .padding(.horizontal)
        .id(chatData.id)
        
    }
}

struct NickName:View{
    var name: String
    @State var user:Firebase.User? = Auth.auth().currentUser


    var body: some View{
        let uid = user?.uid
        Text(String(name.first!))
            .fontWeight(.heavy)
            .foregroundColor(.white)
            .frame(width: 50, height: 50)
            .background((name == uid ? Color("#FFD100"):Color("ECECEC")).opacity(0.5))
            .clipShape(Circle())
    }
}


