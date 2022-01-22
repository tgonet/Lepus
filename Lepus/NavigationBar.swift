//
//  NavigationBar.swift
//  Lepus
//
//  Created by Tan Ming Zhe on 16/1/22.
//

import SwiftUI
import Firebase

struct NavigationBar: View {
    @State private var Redirect = false
    var url:URL? = Auth.auth().currentUser?.photoURL ?? URL(string: "")
    
    var body: some View {
        HStack{
            // Image placeholder to make the logo center
            Image("placeholder")
                .resizable()
                .clipShape(Circle()).frame(width: 35.0, height: 35.0)
            Spacer()
            Image("Logo")
                .frame(width: 50.0, height: 30.0)
            Spacer()
            NavigationLink(destination: ProfileView(), isActive: $Redirect) {
                EmptyView()
            }
            Button{print("HI")
                self.Redirect = true
            } label: {
                if(url == URL(string:"")){
                    Image("profileImg")
                        .resizable()
                        .clipShape(Circle()).frame(width: 35.0, height: 35.0)
                }
                else{
                    AsyncImage(url: url) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .clipShape(Circle()).frame(width: 35.0, height: 35.0)
                }
            }
        }.padding()
    }
}

struct NavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        NavigationBar().previewLayout(.sizeThatFits).padding()
    }
}
