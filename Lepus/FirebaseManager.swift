//
//  FirebaseManager.swift
//  Lepus
//
//  Created by Tan Ming Zhe on 20/1/22.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import MapKit
import SwiftUI
import CoreLocation

class FirebaseManager : ObservableObject{
    
    var ref: DocumentReference? = nil
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    @Published var runList:[Run] = []
    @Published var height = 0.00
    @Published var weight = 0.00
    @Published var gender = "Male"
    @Published var name = ""
    
    @Published var recoList:[BuddyRecoUser] = []
    @Published var noStatistics = false
    
    func readRuns(){
        db.collection("runs").whereField("userId", isEqualTo: user!.uid).addSnapshotListener{ (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.runList.removeAll()
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    let data = document.data()
                    let id = document.documentID
                    let date = data["Date"] as? Timestamp
                    let pace = data["Pace"] as? Double
                    let name = data["Name"] as? String
                    let distance = data["Distance"] as? Double
                    let duration = data["Duration"] as? String
                    let url = data["Url"] as? String
                    self.runList.append(Run(id:id, name: name!, date: date!.dateValue(), distance: distance!, pace: pace!, duration: duration!, url:url!))
                    }
                }
        }
        
        }
    func saveRun(duration:String, pace:Double, distance:Double, url:String, coord:CLLocationCoordinate2D){
        ref = db.collection("runs").addDocument(data: [
            "Duration":duration,
            "Pace":pace,
            "Distance":distance,
            "Startlatitude":"\(coord.latitude)",
            "Startlongitude":"\(coord.longitude)",
            "Url":url,
            "Date": Date(),
            "Name": user!.displayName!,
            "userId":user!.uid]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(self.ref!.documentID)")
            }
        }
    }
    
    func getprofileDetails(id:String){
        let docRef = db.collection("users").document(id)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()!
                self.weight = data["weight"] as! Double
                self.height = data["height"] as! Double
                self.name = data["name"] as! String
                self.gender = data["gender"] as! String
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func updateProfile(weight:Double, height:Double, name:String, gender:String){
        let docRef = db.collection("users").document(user!.uid)
        docRef.updateData([
            "weight": weight,
            "height": height,
            "gender": gender,
            "name": name
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
    func updateProfilePic(url:URL){
        let docRef = db.collection("users").document(user!.uid)
        docRef.updateData([
            "url": url.absoluteString,
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                let changeRequest = self.user!.createProfileChangeRequest()
                changeRequest.photoURL = url
                changeRequest.commitChanges { error in
                  // ...
                }
                
                print("Document successfully updated")
            }
        }
    }
    
    func addUser(uid:String, dict:[String: Any]){
        
    }
/*
    func getUser(from uid:String, completion: @escaping User? -> ()){
        var user:User?
        let ref = db.collection("users").document(uid)
        ref.getDocument{ (document, error) in
            let result = Result {
                try document?.data(as: User.self)
                }
                switch result {
                case .success(let u):
                    if let u = u {
                        print("\(u.userId!), \(u.email), \(u.name), \(u.profilePic)")
                        user = u
                    } else {
                        print("Document does not exist")
                    }
                case .failure(let error):
                    print("Error decoding user: \(error)")
                }
        }
        print(user ?? "nil")
        completion(user)
    }
 */
    /*
    func getBuddies(){
        var recouidList:[String] = []
        var buddyReco:BuddyRecoUser?
        let uid = user!.uid
        var buddyList:[String] = []
        let buddyRef = db.collection("Buddies").document(uid)
        buddyRef.getDocument{(document,error) in
            if let document = document, document.exists {
                buddyList = document.data()!["buddyList"]! as! [String]
                print(buddyList[0])
                print("hi my buddy")
              }
            else {
                print("Document does not exist")
            }
            let userStatRef = self.db.collection("BuddyRecommendation").document(uid)
            userStatRef.getDocument{(document,error) in
                if let document = document, document.exists {
                    let data = document.data()!
                    let userLat = data["latitude"] as Any
                    let userLong = data["longitude"] as Any
                    buddyList.append(uid)
                    // TO DO: compare stats
                    self.db.collection("BuddyRecommendation")
                        .whereField("userId", notIn: buddyList)
                        .getDocuments(){ (querySnapshot, err) in
                            if let err = err {
                                print("Error getting documents: \(err)")
                            }
                            else {
                                for document in querySnapshot!.documents {
                                    recouidList.append(document.documentID)
                                    print("\(document.documentID) => \(document.data())")
                                }
                            }
                            
                            self.db.collection("users")
                                .getDocuments(){(querySnapshot, err) in
                                    if let err = err {
                                        print("Error getting documents: \(err)")
                                    }
                                    else {
                                        for document in querySnapshot!.documents {
                                            //print("\(document.documentID) => \(document.data())")
                                            for uid in recouidList
                                            {
                                                print(uid)
                                                print(document.documentID)
                                                if (document.documentID == uid)
                                                {
                                                    let data = document.data()
                                                    let name = data["name"] as Any
                                                    let profilePic = data["profilePic"] as Any
                                                    let buddyReco:BuddyRecoUser = BuddyRecoUser(name: name as! String, profilePic: profilePic as! String)
                                                    self.recoList.append(buddyReco)
                                                    print(buddyReco.name)
                                                    //recouidList.removeFirst()
                                                }
                                            }
                                        }
                                    }
                                }
                        }
                    }
                else
                {
                    print("Document does not exist")
                }
            }
        }
    }
    */
    func getBuddies(){
        var recouidList:[String] = []
        var buddyReco:BuddyRecoUser?
        let uid = user!.uid
        var buddyList:[String] = []
        let buddyRef = db.collection("Buddies").document(uid)
        
        var userLat:Double = 0
        var userLong:Double = 0
        var userCoord: CLLocation = CLLocation(latitude: 0, longitude: 0)
        
        var recoLat:Double = 0
        var recoLong:Double = 0
        var recoCoord: CLLocation = CLLocation(latitude: 0, longitude: 0)
        
        buddyRef.getDocument{(document,error) in
            if let document = document, document.exists {
                buddyList = document.data()!["buddyList"]! as! [String]
                print(buddyList[0])
                print("hi my buddy")
              }
            else {
                print("Document does not exist")
            }
            let userStatRef = self.db.collection("users").document(uid)
            userStatRef.getDocument{(document,error) in
                if let document = document, document.exists {
                    let data = document.data()!
                    if let statistics = data["statistics"] as? [String: Any] {
                        userLat = Double(statistics["latitude"] as! String)!
                        userLong = Double(statistics["longitude"] as! String)!
                        userCoord = CLLocation(latitude: userLat, longitude: userLong)
                        print("user Coord \(userCoord)")
                        buddyList.append(uid)
                        
                        self.db.collection("users")
                            .whereField("id", notIn: buddyList)
                            .getDocuments(){(querySnapshot, err) in
                                if let err = err {
                                    print("Error getting documents: \(err)")
                                }
                                else {
                                    for document in querySnapshot!.documents {
                                        print("\(document.documentID) => \(document.data())")
                                            if let statistics = document.data()["statistics"] as? [String: Any] {
                                                recoLat = Double(statistics["latitude"] as! String)!
                                                recoLong = Double(statistics["longitude"] as! String)!

                                                recoCoord = CLLocation(latitude: recoLat, longitude: recoLong)

                                                let distanceInMeters = userCoord.distance(from: recoCoord)
                                                print(distanceInMeters)
                                                if(distanceInMeters <= 500)
                                                {
                                                    let name = document.data()["name"] as Any
                                                    let profilePic = document.data()["profilePic"] as Any
                                                    let buddyReco:BuddyRecoUser = BuddyRecoUser(name: name as! String, profilePic: profilePic as! String)
                                                    self.recoList.append(buddyReco)
                                                    print(buddyReco.name)
                                                }
                                            }
                                        }
                                    }
                                }
                    }
                    else{
                        self.noStatistics = true
                    }
                    buddyList.append(uid)
                    // TO DO: compare stats
                            
                    
                        }
                else
                {
                    print("Document does not exist")
                }
            }
        }
    }
    
    func getMessageList()->[Message]{
        var messageList:[Message] = []
        var message:Message?
        let uid = user!.uid
        let ref = db.collection("MessageGroup")
            .whereField("users", arrayContains: uid)
            .getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    /*
                    let data = document.data()
                    let date = data as Any
                    let pace = data["Pace"] as Any
                    let name = data["Name"] as Any
                    let distance = data["Distance"] as Any
                    let duration = data["Duration"] as Any
                    let url = data["Url"] as Any
                    self.runList.append(Run(name: name as! String, date: date as! Date, distance: distance as! Double, pace: pace as! Double, duration: duration as! String, url:url as! String))
                     */
                }
            }
        }
        return messageList
    }
}


