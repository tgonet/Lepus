//
//  RegisterView.swift
//  Lepus
//
//  Created by mad2 on 12/1/22.
//

import SwiftUI
import FirebaseDatabase
import FirebaseAuth

struct RegisterView: View {
    @State private var email:String = ""
    @State private var name:String = ""
    @State private var password:String = ""
    @State private var confirmPassword:String = ""
    
    @State private var showPassword = false
    @State private var showConfirm = false
    @State private var showAlert = false
    @State private var isLoading = false
      
    
    @State var selection: Int? = nil
    
    var body: some View {
        ZStack{
            
        
            VStack{
                ScrollView{
                Image("runImage")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .scaleEffect(3)
                                
                    }
                
            HStack(alignment:.center, spacing:15){
                Image(systemName: "envelope")
                TextField("Email", text: $email)
                }
                .padding(.vertical,12)
                .padding(.horizontal)
                .background(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 5, y: 5)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: -5, y: -5)
                .padding()
            
            HStack(spacing:15){
                Image(systemName: "person.fill")
                TextField("Name",text:$name)

            }.padding(.vertical,12)
             .padding(.horizontal)
             .background(Color.white)
             .shadow(color: Color.black.opacity(0.05), radius: 5, x: 5, y: 5)
             .shadow(color: Color.black.opacity(0.05), radius: 5, x: -5, y: -5)
             .padding()
             .padding(.top,-15)
             
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
                     
                }.padding(.vertical,12)
                 .padding(.horizontal)
                 .background(Color.white)
                 .shadow(color: Color.black.opacity(0.05), radius: 5, x: 5, y: 5)
                 .shadow(color: Color.black.opacity(0.05), radius: 5, x: -5, y: -5)
                 .padding()
                 .padding(.top,-15)
                
                HStack(alignment:.center, spacing:15){
                    Image(systemName: "lock")
                    if (showConfirm)
                    {
                        TextField("Confirm Password", text: $confirmPassword)
                            .autocapitalization(.none)
                            .font(Font.custom("Rubik-Regular", size:18))
                            .disableAutocorrection(true)
                    }
                    else{
                        SecureField("Confirm Password", text: $confirmPassword)
                            .autocapitalization(.none)
                            .font(Font.custom("Rubik-Regular", size:18))
                            .disableAutocorrection(true)
                    }
                    
                    Button(action:{
                        self.showConfirm.toggle()
                    })
                    {
                        Image(systemName: self.showConfirm == true ? "eye":"eye.slash")
                            .foregroundColor(Color("AccentColor"))
                        
                    }
                     
                }.padding(.vertical,12)
                 .padding(.horizontal)
                 .background(Color.white)
                 .shadow(color: Color.black.opacity(0.05), radius: 5, x: 5, y: 5)
                 .shadow(color: Color.black.opacity(0.05), radius: 5, x: -5, y: -5)
                 .padding()
                 .padding(.top,-15)
                
            
            Spacer()
            //Redirect to home page? upon creation
            
            NavigationLink(destination: TabViewUI(), tag: 1, selection: $selection) {
                Button(action:{
                    hideKeyboard()
                    registerUser(email: email, name: name, password: password, confirmPass: confirmPassword)
                }, label:{
                    HStack{
                        Spacer(minLength: 0)
                        Text("Register")
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
                
                        }
                    //Disable if inputs not entered
                        .opacity((email != "" && name != "" && password != "" && confirmPassword != "") ? 1:0.6)
                        .disabled((email != "" && name != "" && password != "" && confirmPassword != "") ? false:true)
                        .alert(isPresented: $showAlert){
                                            Alert(title: Text("Password does not match"), message: Text("Password and Confirm Password do not match"), dismissButton: .default(Text("Ok")))
                    }
                }
                .edgesIgnoringSafeArea(.top)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            }
        }
    }
func registerUser(email:String,name:String, password:String,confirmPass:String){
    if(password == confirmPass){
        showAlert = false
        var ref: DatabaseReference!
        let auth = Auth.auth()
        do {
          try auth.signOut()
        } catch let err{
            print(err)
        }
        
        ref = Database.database().reference()
        auth.createUser(withEmail: email, password: password){ (result, error) in
            if error == nil {

        } else {
            return
        }}
        //startLoading()
        sleep(5)
        let currentUser = auth.currentUser
        let myDict:[String: String] = ["Email":email, "Name":name, "ProfilePic":""]
        ref.child("users").child(currentUser!.uid).setValue(myDict)

        self.selection = 1

        } else if (password != confirmPass){
            showAlert = true
        }
                        
    }

    
    func startLoading(){
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now()+5){
            isLoading = false
        }
    }
}


struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}

struct Register :Codable{
    var email: String?
    var name: String?
    var password: String?
                    
    init(email: String?, name:String? , password:String?){
        self.email = email
        self.name = name
        self.password = password
    }
}
