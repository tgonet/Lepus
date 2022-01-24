//
//  BuddyRecoUser.swift
//  Lepus
//
//  Created by Aw Joey on 23/1/22.
//

import Foundation
import FirebaseFirestoreSwift


class BuddyRecoUser:Identifiable{
    let id = UUID()
    var name:String
    var profilePic:String

    init(name:String, profilePic:String){
        self.name = name
        self.profilePic = profilePic
    }
}
/*
struct BuddyRecoUser:Codable{
    @DocumentID var userId: String?
    var name:String
    var profilePic:URL?

    init(name:String, profilePic:URL?){
        self.name = name
        self.profilePic = profilePic
    }
}
 */
