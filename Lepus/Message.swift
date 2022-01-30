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
    
    init(user:String, datetime:Date, message:String){
        self.user = user
        self.datetime = datetime
        self.message = message
    }
    enum CodingKeys: String,CodingKey {
        case id
        case user
        case datetime
        case message
    }
}
