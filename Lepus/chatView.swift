//
//  chatVIew.swift
//  Lepus
//
//  Created by mad2 on 24/1/22.
//

import SwiftUI
import Firebase

struct chatView: View {
    @ObservedObject var CDManager = CoreDataUserManager()

    @StateObject var chatData = chatModel()
    @State var scrolled = false
    
    var body: some View {

        VStack(spacing:0){
            
            ScrollViewReader{ reader in
                ScrollView{
                    VStack(spacing: 0){
                        ForEach(chatData.msgs){msg in
                            chatRow(chatData: msg)
                                .onAppear(){
                                    if msg.id == self.chatData.msgs.last!.id && !scrolled {
                                        reader.scrollTo(chatData.msgs.last!.content, anchor: .bottom)
                                        scrolled = true
                                    }
                                }
                        }
                        .onChange(of: chatData.msgs, perform: { value in
                            reader.scrollTo(chatData.msgs.last!.content, anchor: .bottom)
                        })
                    }
                    .padding(.vertical)
                }
            }
            
            HStack(spacing:15){
                TextField("Enter Message",text: $chatData.txt)
                    .padding(.horizontal)
                    .frame(height: 45)
                    .background(Color.primary.opacity(0.06))
                    .clipShape(Capsule())
                
                if chatData.txt != "" {
                    Button(action: {sendMsg()}, label: {
                        Image(systemName: "paperplane.fill")
                            .font(.system(size: 32))
                            .foregroundColor(.white)
                            .frame(width: 45, height: 45)
                            .background(Color(hex:0xFFD100))
                            .clipShape(Circle())
                    })
                }
            }
        }
        
    }
    
    func sendMsg(){
        let user = CDManager.user!

        chatData.writeMsg(userId: user.name )
        chatData.txt = ""
    }
}

extension Color {
init(hex: Int, opacity: Double = 1.0) {
    let red = Double((hex & 0xff0000) >> 16) / 255.0
    let green = Double((hex & 0xff00) >> 8) / 255.0
    let blue = Double((hex & 0xff) >> 0) / 255.0
    self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
}
}
