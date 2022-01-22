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
    var url:URL? = Auth.auth().currentUser?.photoURL ?? URL(string: "")
    
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
            Text("Change profile image").padding().font(Font.custom("Rubik-Medium", size:16))
            
            HStack(alignment:.center, spacing:10){
                Text("Height").padding(.leading,20)
                Spacer()
                TextField("", text: $height)
                    .autocapitalization(.none)
                    .font(Font.custom("Rubik-Regular", size:18))
                    .disableAutocorrection(true).frame(width:100)
                }
                .padding(.vertical,7)
                .background(Color.white)
            HStack(alignment:.center, spacing:10){
                Text("Weight").padding(.leading,20)
                Spacer()
                TextField("", text: $weight)
                    .autocapitalization(.none)
                    .font(Font.custom("Rubik-Regular", size:18))
                    .disableAutocorrection(true).frame(width:100)
                }
                .padding(.vertical,7)
                .background(Color.white)
           
            
            Text("We will use these information to provide you with more accurate results").frame(maxWidth: UIScreen.main.bounds.width * 0.8, alignment: .center).multilineTextAlignment(.center).foregroundColor(Color("TextColor"))
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
