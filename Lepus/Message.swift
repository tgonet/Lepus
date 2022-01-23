//
//  Message.swift
//  Lepus
//
//  Created by Aw Joey on 23/1/22.
//

import Foundation

class Message:Identifiable{
    let id = UUID()
    var user:String
    var datetime:String
    var content:String
    
    init(user:String, datetime:String, content:String){
        self.user = user
        self.datetime = datetime
        self.content = content
    }
}
