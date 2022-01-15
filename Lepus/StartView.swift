//
//  StartView.swift
//  Lepus
//
//  Created by Aw Joey on 15/1/22.
//

import SwiftUI

struct StartView: View {
    var body: some View {
        ZStack{
            Image("startBackground")
            VStack{
                Text("Lepus")
                    .font(Font.custom("Sansita-BoldItalic", size:32))
                
            }
        }
    }
}


struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
