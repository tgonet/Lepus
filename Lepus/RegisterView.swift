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
    
    @State private var showAlert = false
      
    @State private var ref: DatabaseReference!
    @State private var auth = Auth.auth()
    
    @State var selection: Int? = nil
    
    var body: some View {
        VStack{
            Text("Register")
                .font(Font.custom("Rubik-Regular", size:30))
                .foregroundColor(.black)
                .fontWeight(.heavy)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top,300)
                
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
                SecureField("Name",text:$name)

            }.padding(.vertical,12)
             .padding(.horizontal)
             .background(Color.white)
             .shadow(color: Color.black.opacity(0.05), radius: 5, x: 5, y: 5)
             .shadow(color: Color.black.opacity(0.05), radius: 5, x: -5, y: -5)
             .padding()
             .padding(.top,-15)


            
            HStack(spacing:15){
                Image(systemName: "lock")
                SecureField("Password", text: $password)
                }
                .padding(.vertical,12)
                .padding(.horizontal)
                .background(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 5, y: 5)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: -5, y: -5)
                .padding()
                .padding(.top,-15)


                    
            
            HStack(spacing:15){
                Image(systemName: "lock")
                TextField("Confirm Password",text:$confirmPassword)
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
                    registerUser(email: email, name: name, password: password, confirmPass: confirmPassword)
                }, label:{
                    HStack{
                        Spacer(minLength: 0)
                        Text("Register")
                        Spacer(minLength: 0)
                        
                    }
                    .foregroundColor(.white)
                    .padding(.vertical,12)
                    .padding(.horizontal)
                    .background(.yellow)
                    .cornerRadius(10)
                    .padding()
                })
                //Disable if inputs not entered
                    .opacity((email != "" && name != "" && password != "" && confirmPassword != "") ? 1:0.6)
                    .disabled((email != "" && name != "" && password != "" && confirmPassword != "") ? false:true)
                    .alert(isPresented: $showAlert){
                                        Alert(title: Text("Password does not match"), message: Text("Password and Confirm Password do not match"), dismissButton: .default(Text("Ok")))
                }
            }
            }.padding(.horizontal)
        }
func registerUser(email:String,name:String, password:String,confirmPass:String){
    if(password == confirmPass){
        showAlert = false
        //ref = Database.database().reference()
        //let user:User = User(email: email, name: name, password: password)
       /*
        let jsonEncoder = JSONEncoder()
        let jsonData = try! jsonEncoder.encode(user)
                            
        let json = String (data:jsonData,encoding:String.Encoding.utf8)
                        
        self.ref.child("user1").setValue(json)
        
        */
        
        auth.createUser(withEmail: email, password: password){ result, error in guard result != nil, error == nil else {
            return
        }}
        self.selection = 1

        } else if (password != confirmPass){
            showAlert = true
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
