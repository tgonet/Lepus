//
//  ProfileView.swift
//  Lepus
//
//  Created by Tan Ming Zhe on 22/1/22.
//

import SwiftUI
import Firebase

struct ProfileView: View {
    @State private var height:String = ""
    @State private var weight:String = ""
    //@State private var gender:String = ""
    var gender = ["Male", "Female"]
    @State private var selectedGender = "Male"
    @State var url:URL? = Auth.auth().currentUser?.photoURL ?? URL(string: "")
    
    var body: some View {
        VStack(spacing:0){
            if(url == URL(string:"")){
                Image("profileImg")
                    .resizable()
                    .clipShape(Circle()).frame(width: 100.0, height: 100.0)
            }
            else{
                AsyncImage(url: url) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .clipShape(Circle()).frame(width: 100.0, height: 100.0)
            }
            Text("Change profile image").padding().font(Font.custom("Rubik-Medium", size:16)).padding(.bottom, 20)
            
            HStack(alignment:.center, spacing:10){
                Text("Gender").padding(.leading,20)
                Menu {
                    Picker("Please select your gender", selection: $selectedGender) {
                                    ForEach(gender, id: \.self) {
                                        Text($0).font(Font.custom("Rubik-Regular", size:18))
                                    }
                    }
                } label:{
                    Text(selectedGender)
                        .font(Font.custom("Rubik-Regular", size:18))
                }.frame(minWidth: 200, maxWidth: UIScreen.main.bounds.width, alignment: .trailing).padding(.trailing, 20)
            }
                .padding(.vertical,10)
                .background(Color.white).padding(.bottom,40)
            
            HStack(alignment:.center, spacing:10){
                Text("Height").padding(.leading,20)
                TextField("Height", text: $height)
                    .autocapitalization(.none)
                    .font(Font.custom("Rubik-Regular", size:18))
                    .disableAutocorrection(true) .multilineTextAlignment(.trailing).padding(.trailing, 20).keyboardType(.numberPad)
                }
                .padding(.vertical,10)
                .background(Color.white)
            Divider()
            HStack(alignment:.center, spacing:10){
                Text("Weight").padding(.leading,20)
                Spacer()
                TextField("Weight", text: $weight)
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
            }
        }.background(Color("BackgroundColor"))
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
