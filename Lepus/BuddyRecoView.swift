//
//  BuddyRecoView.swift
//  Lepus
//
//  Created by Aw Joey on 1/2/22.
//

import SwiftUI
import Kingfisher

struct BuddyRecoView: View {
    @ObservedObject var FBManager:FirebaseManager = FirebaseManager()
    
    private var selectionList = ["All", "Location Ran","Distance Ran", "Average Pace"]
    @State private var disclosureExpanded = false
    @State private var filter = "Filter by..."
    
    let columns = [
            GridItem(.adaptive(minimum: 80))
        ]
    
    init(){
        FBManager.getBuddyRecos(records: 40, filter: filter)
    }
    
    var body: some View {
        VStack{
                DisclosureGroup("\(filter)", isExpanded: $disclosureExpanded){
                    ForEach(selectionList, id:\.self)
                    {
                        selection in Text("\(selection)")
                            .frame(minWidth: 0, maxWidth:.infinity, alignment: .leading)
                            .background()
                            .padding(.vertical)
                            .onTapGesture {
                                self.filter = selection
                                self.disclosureExpanded.toggle()
                                FBManager.getBuddyRecos(records: 40, filter: filter)
                            }
                    }
                }
                .font(Font.custom("Rubik-Regular", size:18))
                .padding(.horizontal)
                .padding(.vertical, 8)
                .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color("AccentColor"), lineWidth: 2))
                .padding(.horizontal)
                .padding(.vertical)
                
                if (FBManager.noStatistics)
                {
                    Text("Start recording your runs to see buddy recommendations!")
                        .font(Font.custom("Rubik-Regular", size:16))
                        .frame(maxWidth:.infinity, alignment:.center)

                }
                
                else if (FBManager.noMatches)
                {
                    Text("No matches found yet!")
                        .font(Font.custom("Rubik-Regular", size:16))
                        .frame(maxWidth:.infinity, alignment:.center)
                }
                
                else{
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(FBManager.recoList){ user in BuddyRecoItem(id: user.id, url: URL(string:user.profilePic), name: user.name)}
                        }
                        .padding(.horizontal)
                    }
                }
            Spacer()
        }
        .navigationBarTitle("Buddy Recommendations", displayMode: .inline)
    }
}

struct BuddyRecoView_Previews: PreviewProvider {
    static var previews: some View {
        BuddyRecoView()
    }
}

struct BuddyRecoItem:View{
    var id:String
    var url:URL?
    var name:String
    @State private var Redirect = false
    
    
    var body:some View{
        VStack{
            NavigationLink(destination: BuddyProfileView(id: id, name: name, url: url!).navigationBarTitleDisplayMode(.inline) , isActive: $Redirect) {EmptyView()}
            if(url != nil)
            {
                KFImage.url(url)
                    .resizable()
                    .clipShape(Circle())
                    .scaledToFill()
                    .frame(width: 80.0, height: 80.0)
            }
            else{
                Image("profileImg")
                    .resizable()
                    .clipShape(Circle()).frame(width: 80.0, height: 80.0)
            }
            Text(name)
                .font(Font.custom("Rubik-Regular", size:15))
        }
        .onTapGesture {
            Redirect = true
        }
    }
}
