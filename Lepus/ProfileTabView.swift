//
//  HistoryView.swift
//  Lepus
//
//  Created by Tan Ming Zhe on 15/1/22.
//

import SwiftUI
import Firebase
import Kingfisher
import Accelerate

struct ProfileTabView: View {
    @ObservedObject var firebaseManager:FirebaseManager = FirebaseManager()
    @ObservedObject var CDManager = CoreDataUserManager()
    let user = Auth.auth().currentUser!
    @State private var Redirect = false
    @State private var RedirectBuddy = false
    @State private var RedirectLogout = false
    @State private var logOut = false
    @State private var name = ""
    @State private var url = URL(string: "")
    @State private var buddyList:[BuddyRecoUser] = []
    
    init() {
        /*
        UITableView.appearance().separatorStyle = .none
        UITableViewCell.appearance().backgroundColor = UIColor(Color("BackgroundColor"))
         */
        UITableView.appearance().backgroundColor = UIColor(Color("BackgroundColor"))
        firebaseManager.readRuns(id: user.uid)
        UINavigationBar.appearance().tintColor = UIColor(Color("DarkYellow"))
    }
    
    var body: some View {
                VStack{
                    HStack{
                        KFImage.url(url)
                            .placeholder{Image("profileImg").clipShape(Circle()).frame(width: 65.0, height: 65.0).padding(.trailing,20)}
                            .resizable()
                            .loadDiskFileSynchronously()
                            .cacheOriginalImage()
                            .onProgress { receivedSize, totalSize in  }
                            .onSuccess { result in  }
                            .onFailure { error in }
                            .clipShape(Circle())
                            .scaledToFill()
                            .frame(width: 65.0, height: 65.0).padding(.trailing,20) .onChange(of: url) { newImage in
                                //updateUserImage()
                            }
                        Text(name)
                        Spacer()
                        NavigationLink(destination: StartView(), isActive: $RedirectLogout) {
                            EmptyView()
                        }
                        Text("Logout").foregroundColor(Color("DarkYellow"))
                        .onTapGesture {
                                    RedirectLogout = true
                                    LogOut()
                                }
                    }
                    .padding(.horizontal, 15)
                    HStack{
                        NavigationLink(destination: BuddyListView(), isActive: $RedirectBuddy) {
                            EmptyView()
                        }
                        Button(action: {self.RedirectBuddy = true}, label:
                                {Text("\(firebaseManager.buddyList.count) Buddies")
                            .font(Font.custom("Rubik-Medium", size:15))}).onAppear(perform: {
                                firebaseManager.getBuddyList(completion: { budList in
                                    buddyList = budList
                                })
                            })
                            .frame(minWidth: 10, maxWidth: 500, alignment: .center)
                        //Spacer() 
                        Divider()
                        NavigationLink(destination: EditProfileView(), isActive: $Redirect) {
                            EmptyView()
                        }
                        Button(action: {self.Redirect = true}, label: {Text("Edit Profile")
                            .font(Font.custom("Rubik-Medium", size:15))})
                            .frame(minWidth: 10, maxWidth: 500, alignment: .center)

                    }
                    .padding(7).overlay(
                        RoundedRectangle(cornerRadius: 13)
                            .stroke(Color("DarkYellow"), lineWidth: 1.5))
                        .padding(.horizontal)
                        .padding(.vertical,10)
                        .fixedSize(horizontal: false, vertical: true)
                        .foregroundColor(Color("DarkYellow"))
                    
                    List(firebaseManager.runList.sorted(by: {$0.date > $1.date})) {run in
                        RunRow(run: run, url: user.photoURL!)
                        }
                    .listStyle(GroupedListStyle()).onAppear(perform: {
                            UITableView.appearance().contentInset.top = -35
                    }).listRowBackground(Color("BackgroundColor"))
        }.onAppear(perform: {
            self.name = user.displayName!
            self.url = user.photoURL!
            firebaseManager.readRuns(id: user.uid)
        }).navigationBarHidden(true)//.navigationTitle("Profile").toolbar{Button("Logout"){LogOut()}}.navigationBarTitleDisplayMode(.inline)
    }
        
    
    func LogOut(){
        do{
            try Auth.auth().signOut()
            CoreDataManager().LogOutUser(id:CDManager.user!.userId!)
            self.logOut = true
        }
        catch let error as NSError{
            print("can't sign out")
        }
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
    let dateFormatter = DateFormatter()
    
    init(run:Run, url:URL){
        self.run = run
        self.url = url
        dateFormatter.locale = Locale(identifier: "en_SG")
        dateFormatter.dateFormat = "dd MMM YYYY HH:mm a"
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
                    .clipShape(Circle())
                    .scaledToFill()
                    .frame(width: 35.0, height: 35.0)
                
                Text(run.name)
                    .font(Font.custom("Rubik-Regular", size:16))
                Text(dateFormatter.string(from: run.date))
                    .font(Font.custom("Rubik-Regular", size:12))
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            KFImage.url(URL(string: run.url))
                .placeholder{Image("Mapplaceholder")}
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


