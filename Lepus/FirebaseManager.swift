//
//  FirebaseManager.swift
//  Lepus
//
//  Created by Tan Ming Zhe on 20/1/22.
//

import Foundation
import Firebase
import MapKit

class FirebaseManager : ObservableObject{
    
    var ref: DocumentReference? = nil
    let db = Firestore.firestore()
    @Published var runList:[Run] = []
    
    func readRuns(){
        db.collection("Runs").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    let data = document.data()
                    let date = data["Date"] as Any
                    let pace = data["Pace"] as Any
                    let name = data["Name"] as Any
                    let distance = data["Distance"] as Any
                    let duration = data["Duration"] as Any
                    let url = data["Url"] as Any
                    self.runList.append(Run(name: name as! String, date: date as! String, distance: distance as! Double, pace: pace as! Double, duration: duration as! String, url:url as! String))
                    }
                }
            }
        }
    func saveRun(duration:String, pace:Double, distance:Double, url:String, coord:CLLocationCoordinate2D){
        let user = Auth.auth().currentUser
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_SG")
        dateFormatter.dateFormat = "dd MMM YYYY H:mm a"
        let date = dateFormatter.string(from: Date())
        ref = db.collection("Runs").addDocument(data: [
            "Duration":duration,
            "Pace":pace,
            "Distance":distance,
            "Startlatitude":"\(coord.latitude)",
            "Startlongitude":"\(coord.longitude)",
            "Url":url,
            "Date": date,
            "Name": user!.displayName!,
            "userId":user!.uid]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(self.ref!.documentID)")
            }
        }
    }
}
