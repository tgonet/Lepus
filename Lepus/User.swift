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
    
    init(userId:String,email:String, name:String, profilePic:String){
        //self.userId = userId
        self.email = email
        self.name = name
        self.profilePic = profilePic
    }
    
}
*/

struct User:Codable{
    @DocumentID var userId: String?
    var email: String
    var name: String
    var profilePic: String
}
