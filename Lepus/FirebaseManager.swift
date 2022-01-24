//
//  FirebaseManager.swift
//  Lepus
//
//  Created by Tan Ming Zhe on 20/1/22.
//

import Foundation
import Firebase

class FirebaseManager : ObservableObject{
    /*
    var ref: DatabaseReference!
    @Published var runList:[Run] = []
    
    func readRuns(){
        ref = Database.database().reference()
        ref.child("Runs").observe(.value){snapshot in
            self.runList.removeAll()
            for case let child as DataSnapshot in snapshot.children {
                    guard let dict = child.value as? [String:Any] else {
                        print("Error")
                        return
                    }
                let date = dict["Date"] as Any
                let pace = dict["Pace"] as Any
                let name = dict["Name"] as Any
                let distance = dict["Distance"] as Any
                let duration = dict["Duration"] as Any
                let url = dict["Url"] as Any
                self.runList.append(Run(name: name as! String, date: date as! String, distance: distance as! Double, pace: pace as! Double, duration: duration as! String, url:url as! String))
                }
        }
    }
     */
    
}
