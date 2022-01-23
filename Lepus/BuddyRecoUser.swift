//
//  BuddyRecoUser.swift
//  Lepus
//
//  Created by Aw Joey on 23/1/22.
//

import Foundation

class BuddyRecoUser:Identifiable{
    let id = UUID()
    var name:String
    var profilePic:URL?

    init(name:String, profilePic:URL?){
        self.name = name
        self.profilePic = profilePic
    }
}
