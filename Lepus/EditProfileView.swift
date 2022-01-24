//
//  ProfileView.swift
//  Lepus
//
//  Created by Tan Ming Zhe on 22/1/22.
//

import SwiftUI
import Firebase
import Kingfisher

struct EditProfileView: View {
    @State private var height:String = ""
    @State private var weight:String = ""
    var gender = ["Male", "Female"]
    @State private var selectedGender = "Male"
    @State var url:URL? = Auth.auth().currentUser?.photoURL ?? URL(string: "")
    @ObservedObject var firebaseManager = FirebaseManager()
    
    init(){
        firebaseManager.getprofileDetails(id: Auth.auth().currentUser!.uid)
    }
    
    var body: some View {
        VStack(spacing:0){
            KFImage.url(url)
                .placeholder{Image("profileImg").clipShape(Circle()).frame(width: 100.0, height: 100.0)}
                .resizable()
                .loadDiskFileSynchronously()
                .cacheOriginalImage()
                .onProgress { receivedSize, totalSize in  }
                .onSuccess { result in  }
                .onFailure { error in }
                .clipShape(Circle()).frame(width: 100.0, height: 100.0)
            Text("Change profile image").padding().font(Font.custom("Rubik-Medium", size:16)).padding(.bottom, 20)
            
            HStack(alignment:.center, spacing:10){
                Text("Gender").padding(.leading,20)
                Menu {
                    Picker("Please select your gender", selection: $firebaseManager.gender) {
                                    ForEach(gender, id: \.self) {
                                        Text($0).font(Font.custom("Rubik-Regular", size:18))
                                    }
                    }
                } label:{
                    Text(firebaseManager.gender)
                        .font(Font.custom("Rubik-Regular", size:18))
                }.frame(minWidth: 200, maxWidth: UIScreen.main.bounds.width, alignment: .trailing).padding(.trailing, 20)
            }
                .padding(.vertical,10)
                .background(Color.white).padding(.bottom,40)
            
            HStack(alignment:.center, spacing:10){
                Text("Height").padding(.leading,20)
                TextField("Height", text: $firebaseManager.height)
                    .autocapitalization(.none)
                    .font(Font.custom("Rubik-Regular", size:18))
                    .foregroundColor(Color("AccentColor"))
                    .disableAutocorrection(true) .multilineTextAlignment(.trailing).padding(.trailing, 20).keyboardType(.numberPad)
                }
                .padding(.vertical,10)
                .background(Color.white)
            Divider()
            HStack(alignment:.center, spacing:10){
                Text("Weight").padding(.leading,20)
                Spacer()
                TextField("Weight", text: $firebaseManager.weight)
                    .autocapitalization(.none)
                    .font(Font.custom("Rubik-Regular", size:18))
                    .foregroundColor(Color("AccentColor"))
                    .disableAutocorrection(true).multilineTextAlignment(.trailing).padding(.trailing, 20).keyboardType(.numberPad
                    )
                }
                .padding(.vertical,10)
                .background(Color.white)
            Text("We will use these information to provide you with more accurate results").frame(maxWidth: UIScreen.main.bounds.width * 0.8, alignment: .center).multilineTextAlignment(.center).foregroundColor(Color("TextColor")).padding(.top, 30)
            Spacer()
        }.navigationTitle("Profile").toolbar {
            Button("Save") {
                print("Help tapped!")
                firebaseManager.updateProfile(id: Auth.auth().currentUser!.uid, weight: firebaseManager.weight, height: firebaseManager.height, name: Auth.auth().currentUser!.displayName!, gender: firebaseManager.gender)
            }
        }.background(Color("BackgroundColor"))
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView()
    }
}
