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
    var buddy:BuddyRecoUser
    
    @ObservedObject var CDManager = CoreDataUserManager()

    var body: some View {
        var user = CDManager.user!
        let uid = user.userId
        HStack(spacing:15){
            //Nickname view
            if chatData.user != uid {
                NickName(name:buddy.name)
            }
            
            if chatData.user == uid{Spacer(minLength: 0)}
            
            VStack(alignment: chatData.user == uid ? .trailing: .leading, spacing: 5, content:{
                if chatData.user == uid {
                    HStack(alignment: .center, spacing: 0) {
                        Text(chatData.message)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color("DarkYellow"))
                            //Custom Shape
                        .clipShape(chatBubble(myMsg: chatData.user == uid))
                    }
                    HStack(alignment: .center, spacing: 0) {
                        Text(chatData.datetime,style:.time)
                        .font(Font.custom("Rubik-Regular", size:10))
                        .foregroundColor(.gray)
                        .padding(chatData.user == uid ? .leading: .trailing , 10)
                    }
                    
                } else if chatData.user != uid {
                    HStack(alignment: .center, spacing: 0) {
                        Text(chatData.message)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color(hex: 0x797777))
                            //Custom Shape
                            .clipShape(chatBubble(myMsg: chatData.user == uid))
                    }
                    HStack(alignment: .center, spacing: 0) {

                        Text(chatData.datetime,style:.time)
                            .font(Font.custom("Rubik-Regular", size:10))
                            .foregroundColor(.gray)
                            .padding(chatData.user == uid ? .leading: .trailing , 10)
                    }
                    
                }
                    
            })
            
            if chatData.user == uid {
                NickName(name:user.name)
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
        let uid = user?.displayName
        Text(String(name.first!))
            .fontWeight(.heavy)
            .foregroundColor(.white)
            .frame(width: 50, height: 50)
            .background((name == uid ? Color("DarkYellow"):Color(hex:0xECECEC)).opacity(0.8))
            .clipShape(Circle())
    }
}



