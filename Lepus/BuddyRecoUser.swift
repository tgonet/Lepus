//
//  BuddyRecoUser.swift
//  Lepus
//
//  Created by Aw Joey on 23/1/22.
//

import Foundation
import FirebaseFirestoreSwift


class BuddyRecoUser:Identifiable{
    var id:String
    var name:String
    var profilePic:String

    init(id: String, name:String, profilePic:String){
        self.id = id
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
