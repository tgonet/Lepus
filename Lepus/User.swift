//
//  User.swift
//  Lepus
//
//  Created by Aw Joey on 17/1/22.
//

import Foundation

class User : Codable{
    var userId: String
    var name: String
    var profilePic: String?
    
    init(userId:String, name:String, profilePic:String?){
        self.userId = userId
        self.name = name
        self.profilePic = profilePic
    }
    
    func setProfilePic(profilePic:String){
        self.profilePic = profilePic
    }
    
    func getProfilePic()->String{
        return profilePic!
    }
}
