//
//  StartView.swift
//  Lepus
//
//  Created by Aw Joey on 15/1/22.
//

import SwiftUI
import Firebase

struct StartView: View {
    @State var selection: Int? = nil
    
    var body: some View {
        NavigationView {
            ZStack{
                Image("startBackground")
                VStack{
                    Spacer()
                    Text("Lepus")
                        .font(Font.custom("Sansita-BoldItalic", size:32))
                        .foregroundColor(Color.white)
                        .frame(maxWidth: .infinity, alignment:.leading)
                    Text("The grind never ends")
                        .font(Font.custom("Rubik-Regular", size:18))
                        .foregroundColor(Color.white)
                        .padding(.bottom)
                        .frame(maxWidth: .infinity, alignment:.leading)
                    

                    NavigationLink(destination: LoginView(), tag: 1, selection: $selection) {
                        Button(action: {
                            self.selection = 1
                        }, label: {
                            Text("Login")
                                .font(Font.custom("Rubik-Regular", size:22))
                                .foregroundColor(Color.black)
                        })
                            .padding(20)
                            .frame(width: 350, height: 60)
                            .background(Color("AccentColor"))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.bottom)
                    }
                    NavigationLink(destination: RegisterView(), tag: 2, selection: $selection) {
                        Button(action:{
                            self.selection = 2
                        }, label: {
                            Text("Register")
                                .font(Font.custom("Rubik-Regular", size:22))
                                .foregroundColor(Color.white)
                        })
                            .padding(20)
                            .frame(width: 350, height: 60)
                            .background(Color.black)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
                .padding(120)
            }
            
            .edgesIgnoringSafeArea(.top)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        }.navigationBarHidden(true).navigationBarBackButtonHidden(true)
    }
}


struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
