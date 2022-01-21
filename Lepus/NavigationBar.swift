//
//  NavigationBar.swift
//  Lepus
//
//  Created by Tan Ming Zhe on 16/1/22.
//

import SwiftUI

struct NavigationBar: View {
    var body: some View {
        HStack{
            Image("")
                .resizable()
                .clipShape(Circle()).frame(width: 35.0, height: 35.0)
            Spacer()
            Image("Logo")
                .frame(width: 50.0, height: 30.0)
            Spacer()
            Image("profileImg")
                .resizable()
                .clipShape(Circle()).frame(width: 35.0, height: 35.0)
        }.padding()
    }
}

struct NavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        NavigationBar().previewLayout(.sizeThatFits).padding()
    }
}
