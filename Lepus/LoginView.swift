//
//  LoginView.swift
//  Lepus
//
//  Created by Aw Joey on 15/1/22.
//

import SwiftUI
import Firebase

struct LoginView: View {
    @State private var email:String = ""
    @State private var password:String = ""
    @State private var selection: Int? = nil
    @State private var currUser:User?
    
    var body: some View {
        ZStack{
            VStack{
                Image("runImage")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.top).frame(height: 400)
                HStack(alignment:.center, spacing:15){
                    Image(systemName: "envelope")
                    TextField("Email", text: $email)
                    }
                    .padding(.vertical,12)
                    .padding(.horizontal)
                    .background(Color.white)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 5, y: 5)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: -5, y: -5)
                    .cornerRadius(10)
                    .padding()
                
                HStack(alignment:.center, spacing:15){
                    Image(systemName: "lock")
                    SecureField("Password", text: $password)
                    }
                    .padding(.vertical,12)
                    .padding(.horizontal)
                    .background(Color.white)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 5, y: 5)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: -5, y: -5)
                    .cornerRadius(10)
                    .padding()
                NavigationLink(destination: TabViewUI(), tag: 1, selection: $selection) {
                    Button(action:{
                        self.currUser = Login(email: email, password: password)
                        self.selection = 1
                    }, label:{
                        HStack{
                            Spacer(minLength: 0)
                            Text("Login")
                                .foregroundColor(Color.black)
                            Spacer(minLength: 0)
                            
                        }
                        .padding(.vertical,12)
                        .padding(.horizontal)
                        .background(Color("AccentColor"))
                        .cornerRadius(10)
                        .padding()
                    })
                        .disabled((email.isEmpty || password.isEmpty) ? false:true)
                        .disabled((currUser == nil) ? false:true)
                }
            }
        }
    }
}

func Login(email:String, password:String)->User?{
    var user:User?
    let auth = Auth.auth()
    auth.signIn(withEmail: email, password: password, completion: { result, error in
        guard result != nil, error == nil else{
            return
        }
    })
    if auth.currentUser != nil
    {
        let uid = Auth.auth().currentUser!.uid
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("users/\(uid)/username").getData(completion: {error, snapshot in
            guard error == nil else {
                print(error!.localizedDescription)
                return;
            }
            user = snapshot.value as? User ?? user
        })
    }
    return user
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
