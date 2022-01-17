//
//  User.swift
//  Lepus
//
//  Created by Aw Joey on 17/1/22.
//

import Foundation

class User{
    var email: String
    var name: String
    var password: String
    
    init(email:String, name:String, password:String){
        self.email = email
        self.name = name
        self.password = password
    }
}
