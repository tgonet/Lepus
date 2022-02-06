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
    @Binding var latestMsgDate:Date?
    @Binding var firstMsg:Bool
    @Binding var msgNo:Int
    @ObservedObject var CDManager = CoreDataUserManager()
    
    var body: some View {
        let user = CDManager.user!
        let uid = user.userId
        
        VStack
        {
            HStack
            {
                Text("\(msgNo)")
            }
            if (compareDates())
            {
                HStack(alignment: .center, spacing: 0) {
                    Text(chatData.datetime , style:.date
                    )
                }.padding()
            }
            
            HStack(spacing:15){
                //Nickname view
                if chatData.user != uid {
                    NickName(name:buddy.name)
                }
                
                if chatData.user == uid{Spacer(minLength: 0)}
                
                
                VStack(alignment: chatData.user == uid ? .trailing: .leading, spacing: 5, content:{
                    //dateFormatter.dateFormat = "dd/MM/yyyy"

                    
                    //let date = dateFormatter.string(from:chatData.datetime)
                    
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
        }
        .padding(.horizontal)
        .id(chatData.id)
        .onAppear()
        {
            msgNo += 1
            print(compareDates())
            print(firstMsg)
            if compareDates() && firstMsg == false{
                print("changing date")
                latestMsgDate = chatData.datetime
            }
            if firstMsg
            {
                print("not first msg anymore")
                firstMsg = false
            }
            /*
            if (compareDates() && !firstMsg)
            {
                latestMsgDate = chatData.datetime
            }
            if firstMsg
            {
                firstMsg = false
            }
             */
        }
        .onDisappear()
        {
            print("disappear")
        }
    }
        
    
    func compareDates()->Bool
    {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        
        let chatDate = formatter.string(from:chatData.datetime)
        var latestDate = ""
        if (latestMsgDate != nil)
        {
            latestDate = formatter.string(from:latestMsgDate!)
        }
        
        if (latestDate == "" || latestDate != chatDate) {
            return true
            }
        return false
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



