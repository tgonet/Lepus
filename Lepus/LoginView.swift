//
//  LoginView.swift
//  Lepus
//
//  Created by Aw Joey on 15/1/22.
//

import SwiftUI

struct LoginView: View {
    @State private var email:String = ""
    @State private var password:String = ""
    @State var selection: Int? = nil
    
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
                    TextField("Password", text: $password)
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
                }
            }
        }
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
