//
//  LoginView.swift
//  Lepus
//
//  Created by Aw Joey on 15/1/22.
//

import SwiftUI
import Firebase

struct LoginView: View {
    let container = CoreDataManager.shared
    @State private var email:String = ""
    @State private var password:String = ""
    @State private var showPassword = false
    @State private var Redirect = false
    @State private var authFail = false

    var body: some View {
            ZStack{
                VStack{
                    ScrollView{
                    Image("runImage")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                    HStack(alignment:.center, spacing:10){
                        Image(systemName: "envelope")
                        TextField("Email", text: $email)
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
                    
                    HStack(alignment:.center, spacing:15){
                        Image(systemName: "lock")
                        if (showPassword)
                        {
                            TextField("Password", text: $password)
                                .autocapitalization(.none)
                                .font(Font.custom("Rubik-Regular", size:18))
                                .disableAutocorrection(true)
                        }
                        else{
                            SecureField("Password", text: $password)
                                .autocapitalization(.none)
                                .font(Font.custom("Rubik-Regular", size:18))
                                .disableAutocorrection(true)
                        }
                        
                        Button(action:{
                            self.showPassword.toggle()
                        })
                        {
                            Image(systemName: self.showPassword == true ? "eye":"eye.slash")
                                .foregroundColor(Color("AccentColor"))
                            
                        }
                         
                    }
                        .padding(.vertical,12)
                        .padding(.horizontal)
                        .background(Color.white)
                        .foregroundColor(Color.black)
                        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 5, y: 5)
                        .shadow(color: Color.black.opacity(0.05), radius: 5, x: -5, y: -5)
                        .cornerRadius(10)
                        .padding()
                    
                    Button(action:{
                        hideKeyboard()
                        Login(email: email, password: password)
                    }, label:{
                        HStack{
                            Spacer(minLength: 0)
                            Text("Login")
                                .foregroundColor(Color.black)
                                .font(Font.custom("Sansita-BoldItalic", size:20))
                            Spacer(minLength: 0)
                            
                        }
                        .padding(.vertical,12)
                        .padding(.horizontal,20)
                        .background(Color("AccentColor"))
                        .cornerRadius(10)
                        .padding()
                    })
                        .opacity((email.isEmpty || password.isEmpty) ? 0.8:1)
                        .disabled((email.isEmpty || password.isEmpty))
                
                    NavigationLink(destination: TabViewUI(), isActive: $Redirect) {
                        EmptyView()
                    }
                    
                    if authFail{
                        Text("Authentication failed. Please try again")
                            .foregroundColor(Color.red)
                            .font(Font.custom("Rubik-Regular", size:16))
                            .padding(.bottom)
                    }
                }
                    .edgesIgnoringSafeArea(.top)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                }
                .background(Color("BackgroundColor"))
        }
            
    }
    func Login(email:String, password:String){
        var user:User?
        let auth = Auth.auth()
        auth.signIn(withEmail: email, password: password, completion: { result, error in
            guard result != nil, error == nil else{
                authFail = true
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
                let userId:String = value?["email"] as? String ?? ""
                let name:String = value?["name"] as? String ?? ""
                let profilePic:String? = value?["profilePic"] as! String?
                user = User(userId: userId, name: name, profilePic:profilePic)
                print("\(user!.name), \(user!.name)")
                container.StoreUser(user: user!)
                self.Redirect = true
            })
        })
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
