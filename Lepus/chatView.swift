//
//  chatVIew.swift
//  Lepus
//
//  Created by mad2 on 24/1/22.
//

import SwiftUI
import Firebase

struct chatView: View {
    var documentId:String
    @ObservedObject var CDManager = CoreDataUserManager()
    @ObservedObject var FBManager:FirebaseManager = FirebaseManager()
    @State var buddy:BuddyRecoUser
    @StateObject var chatData = chatModel()
    @State var scrolled = false
    @State var chat_name:String = ""

    init(documentId:String,buddy:BuddyRecoUser){
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = UIColor(Color("DarkYellow"))
        
        self.documentId = documentId
        self.buddy = buddy

        
    }
    
    var body: some View {

        VStack(spacing:0){
            
            ScrollViewReader{ reader in
                ScrollView{
                    VStack(spacing: 0){
                        
                        ForEach(FBManager.getMessages(documentId: documentId).reversed(), id: \.self){msg in
                            chatRow(chatData: msg,buddy:buddy)
                                .padding(.top,10)
                                .onAppear(){
                                    if buddy.id != CDManager.user?.userId! {
                                        chat_name = buddy.name
                                    }
                                    if msg.id == self.FBManager.msgs.first!.id && !scrolled {
                                        reader.scrollTo(FBManager.msgs.last!.message, anchor: .bottom)
                                        scrolled = true

                                    }
                                }
                        }
                        .onChange(of: FBManager.msgs, perform: { value in
                            reader.scrollTo(FBManager.msgs.last!.message, anchor: .bottom)
                        })
                    }
                    .padding(.vertical)
                }
            }
            
            HStack(spacing:15){
                TextField("Enter Message",text: $FBManager.txt)
                    .padding(.horizontal)
                    .frame(height: 45)
                    .background(Color.primary.opacity(0.06))
                    .clipShape(Capsule())
                
                if FBManager.txt != "" {
                    Button(action: {sendMsg()}, label: {
                        Image(systemName: "paperplane.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                            .frame(width: 40, height: 40)
                            .background(Color("DarkYellow"))
                            .clipShape(Circle())
                    })
                }
            }
            .navigationBarTitleDisplayMode(.inline).navigationTitle(chat_name)
        }
        
    }
    
    func sendMsg(){
        //let user = CDManager.user!

        FBManager.sendMsg(documentId: documentId)
        
        FBManager.txt = ""
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
