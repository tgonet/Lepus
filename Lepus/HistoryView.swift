//
//  HistoryView.swift
//  Lepus
//
//  Created by Tan Ming Zhe on 15/1/22.
//

import SwiftUI
import Firebase

struct HistoryView: View {
    var ref: DatabaseReference!
    @ObservedObject var firebaseManager:FirebaseManager = FirebaseManager()
    
    init() {
        UITableView.appearance().backgroundColor = UIColor.clear
        firebaseManager.readRuns()
        
    }
    
    var body: some View {
        ZStack {
            VStack{
                NavigationBar().padding(.horizontal, 15).padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
                List(firebaseManager.runList) {run in
                        RunRow(run: run)
                    }.listStyle(GroupedListStyle())
            }
        }.ignoresSafeArea(.all, edges: .top)
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HistoryView()
                .preferredColorScheme(.light)
        }
    }
}

// A view that shows the data for one Restaurant.
struct RunRow: View {
    var run : Run

    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Image("Logo")
                    .resizable()
                    .clipShape(Circle()).frame(width: 35.0, height: 35.0)
                Text("Ming Zhe")
                    .font(Font.custom("Rubik-Regular", size:16))
                Text("November 12, 2021 at 10.00PM")
                    .font(Font.custom("Rubik-Regular", size:12))
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            Image("RunMap").resizable()
            HStack{
                VStack(alignment: .leading){
                    Text("Distance")
                        .font(Font.custom("Rubik-Regular", size:12)).foregroundColor(Color("TextColor"))
                    Text("2.4KM")
                        .font(Font.custom("Rubik-Medium", size:15))
                }
                .padding(.trailing)
                VStack(alignment: .leading){
                    Text("Average Pace")
                        .font(Font.custom("Rubik-Regular", size:12)).foregroundColor(Color("TextColor"))
                    Text("6'55\"")
                        .font(Font.custom("Rubik-Medium", size:15))
                }
            }
            .padding(.bottom)
            HStack{
                VStack(alignment: .leading){
                    Text("Duration").font(Font.custom("Rubik-Regular", size:12)).foregroundColor(Color("TextColor"))
                    Text("12min 20sec").font(Font.custom("Rubik-Medium", size:15))
                }
            }
            Divider().background(Color("Divider"))
        }.listRowSeparator(.hidden)
    }
}

