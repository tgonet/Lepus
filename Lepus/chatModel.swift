//
//  chatModel.swift
//  Lepus
//
//  Created by mad2 on 24/1/22.
//

import SwiftUI
import FirebaseFirestore
import Firebase
import FirebaseAuth


class chatModel: ObservableObject {
    @Published var txt = ""
    @Published var msgs : [Message] = []

    let ref = Firestore.firestore()
    @ObservedObject var CDManager = CoreDataUserManager()
    

    func readAllMsgs(){
        let user = CDManager.user!
        let uid = user.userId
        
        //orderBy timestamp
        
        /*
         ref.collection("MessageGroup").document().collection("user").whereField("senderId", arrayContains: uid!).order(by:"datetime",descending:false).addSnapshotListener{ (snap,err) in
         */
        
        ref.collection("MessageGroup").document().collection("user").whereField("senderId", arrayContains: uid!).addSnapshotListener{ (snap,err) in
            if err != nil{
                print(err!.localizedDescription)
                return
            }
            
            guard let data = snap else {return}
            
            data.documentChanges.forEach{(doc) in
            //adding when data is added
            
                if doc.type == .added{
                    let msg = try! doc.document.data(as: Message.self)
                    
                    DispatchQueue.main.async {
                        self.msgs.append(msg!)
                    }
                }
            }
        }
    }
    
}

struct chatBubble: Shape {
    
    var myMsg : Bool
    
    func path(in rect: CGRect) ->Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft , .topRight, myMsg ? .bottomLeft : .bottomRight], cornerRadii: CGSize(width: 15, height: 15))
        
        return Path(path.cgPath)
    }
}
