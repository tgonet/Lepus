//
//  Message.swift
//  Lepus
//
//  Created by Aw Joey on 23/1/22.
//

import Foundation
import FirebaseFirestoreSwift

struct Message:Identifiable,Codable,Hashable{
    let id = UUID()
    var user:String
    var datetime:Date
    var content:String
    
    init(user:String, datetime:Date, content:String){
        self.user = user
        self.datetime = datetime
        self.content = content
    }
    enum CodingKeys: String,CodingKey {
        case id
        case user
        case datetime
        case content
    }
}
