//
//  chatVIew.swift
//  Lepus
//
//  Created by mad2 on 24/1/22.
//

import SwiftUI
import Firebase

struct chatView: View {
    var message:Message
    @StateObject var chatData = chatModel()
    @State var scrolled = false
    
    var body: some View {
        VStack(spacing:0){
            HStack{
                Text("Chat")
                    .font(.title)
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                Spacer(minLength: 0)
            }
            .padding()
            .padding(.top,UIApplication.shared.windows.first?.safeAreaInsets.top)
            background(Color("Color"))
            
            ScrollViewReader{ reader in
                ScrollView{
                    VStack(spacing: 15){
                        ForEach(chatData.msgs){msg in
                            chatRow(chatData: msg)
                                .onAppear(){
                                    if msg.id == self.chatData.msgs.last!.id && !scrolled {
                                        reader.scrollTo(chatData.msgs.last!.id, anchor: .bottom)
                                        scrolled = true

                                    }
                                }
                        }
                        .onChange(of: chatData.msgs, perform: { value in
                            reader.scrollTo(chatData.msgs.last!.id, anchor: .bottom)
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
                
                if chatData.txt == "" {
                    Button(action: {}, label: {
                        Image(systemName: "paperplane.fill")
                            .font(.system(size: 32))
                            .foregroundColor(.white)
                            .frame(width: 45, height: 45)
                            .background(Color("Color"))
                            .clipShape(Circle())
                    })
                }
            }
        }.ignoresSafeArea(.all,edges: .top)
        
    }
}

