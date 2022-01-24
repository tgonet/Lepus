//
//  HistoryView.swift
//  Lepus
//
//  Created by Tan Ming Zhe on 15/1/22.
//

import SwiftUI
import Firebase
import Kingfisher

struct ProfileTabView: View {
    @ObservedObject var firebaseManager:FirebaseManager = FirebaseManager()
    @State var user:Firebase.User? = Auth.auth().currentUser
    @State private var Redirect = false
    
    init() {
        UITableView.appearance().backgroundColor = UIColor.clear
        //user = Auth.auth().currentUser
        //firebaseManager.readRuns() MZ u need change this
    }
    
    var body: some View {
        ZStack {
            VStack{
                HStack{
                    KFImage.url(user?.photoURL)
                        .placeholder{Image("profileImg").clipShape(Circle()).frame(width: 65.0, height: 65.0).padding(.trailing,20)}
                        .resizable()
                        .loadDiskFileSynchronously()
                        .cacheOriginalImage()
                        .onProgress { receivedSize, totalSize in  }
                        .onSuccess { result in  }
                        .onFailure { error in }
                        .clipShape(Circle()).frame(width: 65.0, height: 65.0).padding(.trailing,20)
                    Text(user!.displayName!)
                    Spacer()
                }
                    .padding(.horizontal, 15)
                    .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
                HStack{
                    Button(action: {}, label: {Text("10 Buddies").font(Font.custom("Rubik-Medium", size:15))}).frame(minWidth: 10, maxWidth: 500, alignment: .center)
                    //Spacer()
                    Divider()
                    NavigationLink(destination: EditProfileView(), isActive: $Redirect) {
                        Button(action: {self.Redirect = true}, label: {Text("Edit Profile").font(Font.custom("Rubik-Medium", size:15))}).frame(minWidth: 10, maxWidth: 500, alignment: .center)
                    }

                }.padding(7).overlay(
                    RoundedRectangle(cornerRadius: 13)
                        .stroke(Color("AccentColor"), lineWidth: 1)).padding(.horizontal).padding(.vertical,10).fixedSize(horizontal: false, vertical: true)
                /*
                List(firebaseManager.runList) {run in
                    RunRow(run: run, url: user!.photoURL!)
                    }.listStyle(GroupedListStyle()).onAppear(perform: {
                        UITableView.appearance().contentInset.top = -35
                    })
                 */
            }
        }.ignoresSafeArea(.all, edges: .top)
    }
}

struct ProfileTabView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ProfileTabView()
                .preferredColorScheme(.light)
        }
    }
}

// A view that shows the data for one Run.
struct RunRow: View {
    var run : Run
    let url:URL?
    
    init(run:Run, url:URL){
        self.run = run
        self.url = url
        print("HIHII\(url)")
    }

    var body: some View {
        VStack(alignment: .leading){
            HStack{
                KFImage.url(url)
                    .placeholder{Image("profileImg").clipShape(Circle()).frame(width: 35.0, height: 35.0).padding(.trailing,20)}
                    .resizable()
                    .loadDiskFileSynchronously()
                    .cacheOriginalImage()
                    .onProgress { receivedSize, totalSize in  }
                    .onSuccess { result in  }
                    .onFailure { error in }
                    .clipShape(Circle()).frame(width: 35.0, height: 35.0)
                
                Text(run.name)
                    .font(Font.custom("Rubik-Regular", size:16))
                Text(run.date)
                    .font(Font.custom("Rubik-Regular", size:12))
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            KFImage.url(URL(string: run.url))
                .placeholder{Image("profileImg")}
                .resizable()
                .loadDiskFileSynchronously()
                .cacheOriginalImage()
                .onProgress { receivedSize, totalSize in  }
                .onSuccess { result in  }
                .onFailure { error in }
            .frame(height: 300)
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

