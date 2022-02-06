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

}
