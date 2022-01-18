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
    @State private var Redirect = false
    
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
                NavigationLink(destination: TabViewUI(), isActive: $Redirect) {
                    Button(action:{
                        print("HI")
                        Login(email: email, password: password)
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
                        .opacity((email.isEmpty || password.isEmpty) ? 0.8:1)
                        .disabled((email.isEmpty || password.isEmpty) ? true:false)
                }
            }
        }
    }
    func Login(email:String, password:String){
        var user:User?
        let auth = Auth.auth()
        auth.signIn(withEmail: email, password: password, completion: { result, error in
            guard result != nil, error == nil else{
                return
            }
            let uid = result!.user.uid
            var ref: DatabaseReference!
            ref = Database.database().reference()
            ref.child("users/\(uid)").getData(completion: {error, snapshot in
                guard error == nil else {
                    print(error!.localizedDescription)
                    return;
                }
                print("managed to get ref")
                let value = snapshot.value as? NSDictionary
                var name:String = value?["name"] as? String ?? ""
                var email:String = value?["email"] as? String ?? ""
                user = User(email: email, name: name)
                self.Redirect = true
            })
        })
        
        
//        if auth.currentUser != nil
//        {
//            let uid = auth.currentUser!.uid
//            var ref: DatabaseReference!
//            ref = Database.database().reference()
//            ref.child("users/\(uid)").getData(completion: {error, snapshot in
//                guard error == nil else {
//                    print(error!.localizedDescription)
//                    return;
//                }
//                print("managed to get ref")
//                user = snapshot.value as? User ?? user
//            })
//            
//            if user != nil{
//                print("user not nil")
//                self.Redirect = false
//            }
//        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
