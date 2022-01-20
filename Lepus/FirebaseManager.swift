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
        ref.child("Runs").getData(completion: {error, snapshot in
            guard error == nil else {
                print(error!.localizedDescription)
                return;
            }
            print("managed to get ref")
            let value = snapshot.value as? NSDictionary
            let name:String = value?["name"] as? String ?? ""
            let distance:Double = value?["Distance"] as? Double ?? 0.00
            let pace:Double = value?["Pace"] as? Double ?? 0.00
            let duration:String = value?["Duration"] as? String ?? ""
            //let startLatitude:Double = value?["Startlatitude"] as? Double ?? ""
            //let startLongitude:String = value?["Startlongitude"] as? String ?? ""
            let url:String = value?["Url"] as? String ?? ""
            let date:String = value?["Date"] as? String ?? ""
            self.runList.append(Run(name: name, date: date, distance: distance, pace: pace, duration: duration, url:url))
            print(self.runList.count)
        })
    }
    
}
