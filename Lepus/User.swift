//
//  User.swift
//  Lepus
//
//  Created by Aw Joey on 17/1/22.
//

import Foundation
import FirebaseFirestoreSwift


struct User:Codable{
    @DocumentID var userId: String?
    var email: String
    var name: String
    var profilePic: String
    var height:Double
    var weight:Double
    var gender:String
}

