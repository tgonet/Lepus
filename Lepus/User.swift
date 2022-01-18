//
//  User.swift
//  Lepus
//
//  Created by Aw Joey on 17/1/22.
//

import Foundation

class User : Codable{
    var email: String
    var name: String
    
    init(email:String, name:String){
        self.email = email
        self.name = name
    }
}
