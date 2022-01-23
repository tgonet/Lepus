//
//  HistoryView.swift
//  Lepus
//
//  Created by Tan Ming Zhe on 15/1/22.
//

import SwiftUI
import Firebase

struct HistoryView: View {
    @ObservedObject var firebaseManager:FirebaseManager = FirebaseManager()
    @State var user:Firebase.User?
    @State private var Redirect = true
    @State var url:URL? = Auth.auth().currentUser?.photoURL
    
    init() {
        UITableView.appearance().backgroundColor = UIColor.clear
        user = Auth.auth().currentUser
        firebaseManager.readRuns()
        print("HIHIVIew\(self.url)")
    }
    
    var body: some View {
        ZStack {
            VStack{
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
                    Button{
                        print("HI")
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
                    .padding(.horizontal, 15)
                    .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
                List(firebaseManager.runList) {run in
                    RunRow(run: run, url: url!)
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

// A view that shows the data for one Run.
struct RunRow: View {
    var run : Run
    let url:URL
    
    init(run:Run, url:URL){
        self.run = run
        self.url = url
        print("HIHII\(url)")
    }

    var body: some View {
        VStack(alignment: .leading){
            HStack{
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
                
                Text(run.name)
                    .font(Font.custom("Rubik-Regular", size:16))
                Text(run.date)
                    .font(Font.custom("Rubik-Regular", size:12))
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            AsyncImage(url: URL(string: run.url)) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(height: 270)
            HStack{
                VStack(alignment: .leading){
                    Text("Distance")
                        .font(Font.custom("Rubik-Regular", size:12)).foregroundColor(Color("TextColor"))
                    Text("\(String(format: "%.2f", run.distance))KM")
                        .font(Font.custom("Rubik-Medium", size:15))
                }
                .padding(.trailing)
                VStack(alignment: .leading){
                    Text("Average Pace")
                        .font(Font.custom("Rubik-Regular", size:12)).foregroundColor(Color("TextColor"))
                    Text("\(String(format: "%.2f", run.pace))")
                        .font(Font.custom("Rubik-Medium", size:15))
                }
            }
            .padding(.bottom)
            HStack{
                VStack(alignment: .leading){
                    Text("Duration").font(Font.custom("Rubik-Regular", size:12)).foregroundColor(Color("TextColor"))
                    Text(run.duration).font(Font.custom("Rubik-Medium", size:15))
                }
            }
            Divider().background(Color("Divider"))
        }.listRowSeparator(.hidden)
    }
}

