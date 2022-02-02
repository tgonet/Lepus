//
//  Message.swift
//  Lepus
//
//  Created by Aw Joey on 23/1/22.
//

import Foundation
import FirebaseFirestoreSwift

struct Message:Identifiable,Codable,Hashable{
    @DocumentID var id: String?
    var user:String
    var datetime:Date
    var message:String
    var friendID:String?
    
    init(id:String,user:String, datetime:Date, message:String){
        self.id = id
        self.user = user
        self.datetime = datetime
        self.message = message
    }
    
    init(id:String,user:String, datetime:Date, message:String, friendID:String?){
        self.id = id
        self.user = user
        self.datetime = datetime
        self.message = message
        self.friendID = friendID
    }
    
    enum CodingKeys: String,CodingKey {
        case id
        case user
        case datetime
        case message
    }
}
