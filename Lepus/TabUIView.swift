//
//  SwiftUIView.swift
//  Lepus
//
//  Created by Tan Ming Zhe on 13/1/22.
//

import SwiftUI

struct TabUIView: View {
    var body: some View {
            TabView {
                ContentView()
                    .tabItem {
                        Label("Menu", systemImage: "list.dash")
                    }

                RegisterView()
                    .tabItem {
                        Label("Order", systemImage: "square.and.pencil")
                    }
            }
        }
}

struct TabUIView_Previews: PreviewProvider {
    static var previews: some View {
        TabUIView()
    }
}
