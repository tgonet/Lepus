//
//  RegisterView.swift
//  Lepus
//
//  Created by mad2 on 12/1/22.
//

import SwiftUI

struct RegisterView: View {
    @State private var email:String = ""
    @State private var name:String = ""
    @State private var password:String = ""
    @State private var confirmPassword:String = ""
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
                TextField("Name",text:$name)

            }.padding(.vertical,12)
             .padding(.horizontal)
             .background(Color.white)
             .shadow(color: Color.black.opacity(0.05), radius: 5, x: 5, y: 5)
             .shadow(color: Color.black.opacity(0.05), radius: 5, x: -5, y: -5)
             .padding()
             .padding(.top,-15)


            
            HStack(spacing:15){
                Image(systemName: "lock")
                TextField("Password", text: $password)
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
            
            Button(action:{}, label:{
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
            
            }.padding(.horizontal)
        }
    }

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
