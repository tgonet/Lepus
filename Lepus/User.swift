//
//  User.swift
//  Lepus
//
//  Created by Aw Joey on 17/1/22.
//

import Foundation
import FirebaseFirestoreSwift

/*
class User : Codable{

    var userId: String
    var email:String
    var name: String
    var profilePic: String
    var height:Double
    var weight:Double
    var gender:String
    
    init(userId:String,email:String, name:String, profilePic:String, height:Double, weight:Double, gender:String){
        self.userId = userId
        self.email = email
        self.name = name
        self.profilePic = profilePic
        self.height = height
        self.weight = weight
        self.gender = gender
    }
}
*/

struct User:Codable{
    @DocumentID var userId: String?
    var email: String
    var name: String
    var profilePic: String
    var height:Double
    var weight:Double
    var gender:String
}

