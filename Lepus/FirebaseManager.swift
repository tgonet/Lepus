//
//  FirebaseManager.swift
//  Lepus
//
//  Created by Tan Ming Zhe on 20/1/22.
//

import Foundation
import Firebase

class FirebaseManager : ObservableObject{
    var ref: DatabaseReference!
    @Published var runList:[Run] = []
    
    func readRuns(){
        ref = Database.database().reference()
//        ref.child("Runs").observe(.value, with: {(snapshot) in
//            for child in snapshot.children{
//
//            }
//        })
        ref.child("Runs").observe(.value){snapshot in
            for case let child as DataSnapshot in snapshot.children {
                    guard let dict = child.value as? [String:Any] else {
                        print("Error")
                        return
                    }
                var date = dict["Date"] as Any
                var pace = dict["Pace"] as Any
                var name = dict["name"] as Any
                var distance = dict["Distance"] as Any
                var duration = dict["Duration"] as Any
                var url = dict["Url"] as Any
                //let startLatitude:Double = value?["Startlatitude"] as? Double ?? ""
                //let startLongitude:String = value?["Startlongitude"] as? String ?? ""
                self.runList.append(Run(name: name as! String, date: date as! String, distance: distance as! Double, pace: pace as! Double, duration: duration as! String, url:url as! String))
                }
//            for child in snapshot.children{
//                print(child)
//                let value = child.value as [String:Any]
//                let name:String = child.value["name"]
//                let distance:Double = child?["Distance"] as? Double ?? 0.00
//                let pace:Double = child?["Pace"] as? Double ?? 0.00
//                let duration:String = child?["Duration"] as? String ?? ""
//                //let startLatitude:Double = value?["Startlatitude"] as? Double ?? ""
//                //let startLongitude:String = value?["Startlongitude"] as? String ?? ""
//                let url:String = child?["Url"] as? String ?? ""
//                let date:String = child?["Date"] as? String ?? ""
//                self.runList.append(Run(name: name, date: date, distance: distance, pace: pace, duration: duration, url:url))
//            }
        }
//        ref.child("Runs").getData(completion: {error, snapshot in
//            guard error == nil else {
//                print(error!.localizedDescription)
//                return;
//            }
//            print("managed to get ref")
//            let value = snapshot.value as? NSDictionary
//            let name:String = value?["name"] as? String ?? ""
//            let distance:Double = value?["Distance"] as? Double ?? 0.00
//            let pace:Double = value?["Pace"] as? Double ?? 0.00
//            let duration:String = value?["Duration"] as? String ?? ""
//            //let startLatitude:Double = value?["Startlatitude"] as? Double ?? ""
//            //let startLongitude:String = value?["Startlongitude"] as? String ?? ""
//            let url:String = value?["Url"] as? String ?? ""
//            let date:String = value?["Date"] as? String ?? ""
//            self.runList.append(Run(name: name, date: date, distance: distance, pace: pace, duration: duration, url:url))
//            print(self.runList.count)
//        })
    }
    
}
