//
//  RegisterView.swift
//  Lepus
//
//  Created by mad2 on 12/1/22.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth

struct RegisterView: View {
    @State private var email:String = ""
    @State private var name:String = ""
    @State private var password:String = ""
    @State private var confirmPassword:String = ""
    
    @State private var showPassword = false
    @State private var showConfirm = false
    @State private var isLoading = false
    
    @State private var showAlert = false

    @State private var selectedGender = "Male"
    @State private var selectedDate = Date()
    @State private var selectedHeight:Double = 160
    @State private var selectedWeight:Double = 50
    
    var errorCode:Int = 0
    var gender = ["Male", "Female", "Prefer not to say"]
    
    var height = [Int](0...300)
    var weight = [Int](0...300)
    @State private var errorMessage:String = ""
    
    let db = Firestore.firestore()
    @ObservedObject var FBManager = FirebaseManager()
    @State var selection: Int? = nil
    
    init(){
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = UIColor(Color("DarkYellow"))
    }
    
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
                
                    Group {
                        HStack(alignment:.center, spacing:15){
                    Image(systemName: "envelope")
                    TextField("Email", text: $email)
                        .autocapitalization(.none)
                        .font(Font.custom("Rubik-Regular", size:18))
                        .disableAutocorrection(true)
                    }
                    .padding(.vertical,12)
                    .padding(.horizontal)
                    
                    .background(Color("TextFieldColor"))
                    .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color("TextFieldBorderColor"), lineWidth: 2))
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 5, y: 5)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: -5, y: -5)
                .padding()
                    
            
            HStack(spacing:15){
                Image(systemName: "person.fill")
                TextField("Name",text:$name)
                    .font(Font.custom("Rubik-Regular", size:18))
                    .disableAutocorrection(true)

            }
            .padding(.vertical,12)
            .padding(.horizontal)
            
            .background(Color("TextFieldColor"))
            .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color("TextFieldBorderColor"), lineWidth: 2))
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 5, y: 5)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: -5, y: -5)
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
                
                .background(Color("TextFieldColor"))
                .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color("TextFieldBorderColor"), lineWidth: 2))
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 5, y: 5)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: -5, y: -5)
                .padding()
                
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
                     
                }
                .padding(.vertical,12)
                .padding(.horizontal)
                
                .background(Color("TextFieldColor"))
                .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color("TextFieldBorderColor"), lineWidth: 2))
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 5, y: 5)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: -5, y: -5)
                .padding()
                    
                    
                        HStack(alignment:.center, spacing:10){
                            Text("Gender")
                                .padding(.leading,20)
                            Menu {
                                Picker("Please select your gender", selection: $selectedGender) {
                                                ForEach(gender, id: \.self) {
                                                    Text($0).font(Font.custom("Rubik-Regular", size:18))
                                                }
                                }
                            } label:{
                                Text(selectedGender)
                                    .font(Font.custom("Rubik-Regular", size:18))
                                    .foregroundColor(Color("DarkYellow"))
                            }.frame(minWidth: 200, maxWidth: UIScreen.main.bounds.width, alignment: .trailing).padding(.trailing, 20)
                        }
                        .padding(.vertical,12)
                        .padding(.horizontal)
                        
                        .background(Color("TextFieldColor"))
                        .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color("TextFieldBorderColor"), lineWidth: 2))
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 5, y: 5)
                        .shadow(color: Color.black.opacity(0.05), radius: 5, x: -5, y: -5)
                        .padding()
                        
                        HStack(alignment:.center, spacing:10){
                            Text("Height (cm)").padding(.leading,15)
                            TextField("Height", value: $selectedHeight, format: .number)
                                .keyboardType(.decimalPad)
                                .autocapitalization(.none)
                                .font(Font.custom("Rubik-Regular", size:18))
                                .foregroundColor(Color("DarkYellow"))
                                .disableAutocorrection(true) .multilineTextAlignment(.trailing).padding(.trailing, 20).keyboardType(.numberPad)
                            
                            Text("Weight (kg)").padding(.leading,15)
                            Spacer()
                            TextField("Weight", value: $selectedWeight, format: .number)
                                .keyboardType(.decimalPad)
                                .autocapitalization(.none)
                                .font(Font.custom("Rubik-Regular", size:18))
                                .foregroundColor(Color("DarkYellow"))
                                .disableAutocorrection(true).multilineTextAlignment(.trailing).padding(.trailing, 20).keyboardType(.numberPad
                                )
                            }
                        .padding(.vertical,12)
                        .padding(.horizontal)
                        
                        .background(Color("TextFieldColor"))
                        .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color("TextFieldBorderColor"), lineWidth: 2))
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 5, y: 5)
                        .shadow(color: Color.black.opacity(0.05), radius: 5, x: -5, y: -5)
                        .padding()
                      
                        HStack(alignment: .center, spacing: 0) {
                            DatePicker("Date of Birth:",selection:$selectedDate,displayedComponents: .date)
                            
                                .padding(.vertical,12)
                                .padding(.horizontal)
                                
                                .background(Color("TextFieldColor"))
                                .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color("TextFieldBorderColor"), lineWidth: 2))
                                .cornerRadius(10)
                                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 5, y: 5)
                                .shadow(color: Color.black.opacity(0.05), radius: 5, x: -5, y: -5)
                                .padding()
                        }
                        
                        if errorMessage != "" || errorMessage != nil {
                            HStack(alignment:.center,spacing: 0){
                                Text("\(errorMessage)")
                            }
                            .foregroundColor(Color.red)
                            .font(Font.custom("Rubik-Regular", size:16))
                            .padding(.bottom)
                        }

                    }
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
            .background(Color("BackgroundColor"))
        }
    }
 
    
    
    func registerUser(email:String,name:String, password:String,confirmPass:String){
    if(password == confirmPass){
        let url = "https://firebasestorage.googleapis.com/v0/b/lepus-d32ce.appspot.com/o/profileImg.png?alt=media&token=30a50d9b-aefc-4dd5-92cd-88f173b6eef8"
        showAlert = false
        let auth = Auth.auth()
        do {
          try auth.signOut()
        } catch let err{
            print(err)
        }
        //startLoading()
        auth.createUser(withEmail: email, password: password){ (result, error) in
            if error != nil {
                errorMessage = error!.localizedDescription
            }
            if error == nil {
                let currentUser = auth.currentUser
                let myDict:[String: Any] = ["email":email, "name":name, "profilePic":url, "id":currentUser!.uid,"dob":selectedDate, "weight":selectedWeight, "height":selectedHeight, "gender": selectedGender]
                CoreDataManager().StoreUser(user: User(userId: currentUser?.uid, email: email, name: name, profilePic: url, height: 165, weight: 50, gender: "Male"))
                let ref = db.collection("users").document((currentUser!.uid))
                ref.setData(myDict,merge: true){ err in
                    if let err = err {
                        print("Error writing document: \(err)")
                    } else {
                        print("Document successfully written!")
                        let ref1 = db.collection("Buddies").document((currentUser!.uid))
                        ref1.setData(["buddyList":[],
                                     "pendingBuddyList":[],
                                     "requestList":[]
                                    ])
                        self.selection = 1
                    }
                }
                let changeRequest = Auth.auth().currentUser!.createProfileChangeRequest()
                changeRequest.displayName = name
                changeRequest.photoURL = URL(string: url)
                changeRequest.commitChanges { error in
                    if error != nil{
                        print("Firebase: \(error)")
                    }
                    else{
                        print("Firebase: No error")
                    }
                }
            }
            else {
                return
            }
        }
        

        }
    else if (password != confirmPass){
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

