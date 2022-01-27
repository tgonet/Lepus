//
//  MessageListView.swift
//  Lepus
//
//  Created by Aw Joey on 24/1/22.
//

import Foundation
import FirebaseFirestoreSwift

struct MessageGroupView{
    @DocumentID var messageGroupId: String?
    var message: String
    var senderId: String
    var datetime: Date
    var userList:Array<String>
    /*
    init(latestMessageData: [String:Any]){
        let message = latestMessageData["message"] as? String ?? ""
        self.message = message
        let datetime = (latestMessageData["datetime"] as? Date)!
        self.datetime = datetime
        let senderId = latestMessageData["senderId"] as? String ?? ""
        self.senderId = senderId
    }
     */
}
