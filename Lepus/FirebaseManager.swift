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
    var locRef: DocumentReference? = nil
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    @Published var runList:[Run] = []
    @Published var height = 0.00
    @Published var weight = 0.00
    @Published var gender = "Male"
    @Published var name = ""
    
    @Published var recoList:[BuddyRecoUser] = []
    @Published var noStatistics = false
    @Published var noMatches = false
    
    func readRuns(){
        db.collection("runs").whereField("userId", isEqualTo: user!.uid).addSnapshotListener{ (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.runList.removeAll()
                for document in querySnapshot!.documents {
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
                
                
                let userRef = self.db.collection("users").document(self.user!.uid)
                userRef.getDocument{(document,error) in
                    if let document = document, document.exists {   //1. userRef start
                        let userLocationRef = userRef.collection("Locations")
                        userLocationRef.getDocuments(){(querySnapshot, err) in //2. userLocationRef start
                            if querySnapshot?.documents.count == 0 { //3. if userLocationRef docs not found
                                //print("Error getting documents: \(err)")
                                self.locRef = userLocationRef.addDocument(data: [
                                    "latitude":"\(coord.latitude)",
                                    "longitude":"\(coord.longitude)",
                                    "runCount":1]) { err in //4. error
                                    if let err = err { //5. if
                                        print("Error adding document: \(err)")
                                    } //5. if
                                    else { //6. else
                                        print("Document added with ID: \(self.locRef!.documentID)")
                                        userRef.updateData([
                                            "statistics.avgPace":pace,
                                            "statistics.avgDistance":distance,
                                            "statistics.frequentLocationId":self.locRef!.documentID,
                                            "statistics.frequentLocationCount":1,
                                            "statistics.latitude":"\(coord.latitude)",
                                            "statistics.longitude":"\(coord.longitude)",
                                            "statistics.numRuns":1
                                        ])
                                        { err in    //7. err in
                                            if let err = err {  //8. if
                                                print("Error adding user's statistics: \(err)")
                                            } //8. if
                                            else {  //9. else
                                                print("User's statistics successfully added")
                                            }   //9. else
                                        } //7. err in
                                    } //6. else
                                } //4. error
                            } //3. if userLocationRef docs not found
                            else { //10. else userLocationRef found
                                print(querySnapshot?.documents)
                                if let statistics = document.data()!["statistics"] as? [String: Any] {  //11. user statistics found
                                    var latitude = Double(statistics["latitude"] as! String)!
                                    var longitude = Double(statistics["longitude"] as! String)!
                                    var avgPace = statistics["avgPace"] as! Double
                                    var avgDistance = statistics["avgDistance"] as! Double
                                    var numRuns = statistics["numRuns"] as! Double
                                    var frequentLocationId = statistics["frequentLocationId"] as! String
                                    var frequentLocationCount = statistics["frequentLocationCount"] as! Double
                                    
                                    avgPace = (avgPace * numRuns + pace)/(numRuns+1)
                                    avgDistance = (avgDistance * numRuns + distance)/(numRuns+1)
                                    
                                    if self.isLocationDistance500OrLesser(lat1: coord.latitude, long1: coord.longitude, lat2: latitude, long2: longitude)
                                    {   //12. if freq Location close to run location
                                        latitude = (latitude * frequentLocationCount + coord.latitude)/(frequentLocationCount+1)
                                        longitude = (longitude * frequentLocationCount + coord.longitude)/(frequentLocationCount+1)
                                        frequentLocationCount += 1
                                        userLocationRef.document(frequentLocationId).updateData([
                                            "runCount": FieldValue.increment(Int64(1))
                                        ])
                                    } //12. if freq Location close to run location
                                    else //13. else freq Location close to run location
                                    {
                                        var exist = false
                                        for document in querySnapshot!.documents { //14. for document
                                            print("\(document.documentID) => \(document.data())")
                                            if (document.documentID != frequentLocationId)
                                            {   //15. remove frequentLocation from check
                                                let data = document.data()
                                                let locLat = Double(data["latitude"] as! String)!
                                                let locLong = Double(data["longitude"] as! String)!
                                                let runCount = data["runCount"] as! Double
                                                if self.isLocationDistance500OrLesser(lat1: coord.latitude, long1: coord.longitude, lat2: locLat, long2: locLong)
                                                { // 16. if freq Location close to run location
                                                    if runCount+1 > frequentLocationCount
                                                    {
                                                        // error here
                                                        frequentLocationId = document.documentID
                                                        frequentLocationCount = runCount+1
                                                        longitude = locLong
                                                        latitude = locLat
                                                    }
                                                    userLocationRef.document(document.documentID).updateData([
                                                        "runCount": FieldValue.increment(Int64(1))
                                                    ])
                                                    exist = true
                                                    break;
                                                } // 16. if freq Location close to run location
                                            } //15. remove frequentLocation from check
                                        } //14. for document
                                        
                                        if !exist
                                        { // 17. if exist false
                                        userLocationRef.addDocument(data: [
                                            "latitude":"\(coord.latitude)",
                                            "longitude":"\(coord.longitude)",
                                            "runCount":1]){ err in // 18. error
                                            if let err = err {//19. if error
                                                print("Error adding document: \(err)")
                                            } //19. if error
                                            } //18. error
                                        } // 17. if exist false
                                    } //13. else freq Location close to run location
                                    numRuns += 1
                                    userRef.updateData([
                                        "statistics.avgPace":avgPace,
                                        "statistics.avgDistance":avgDistance,
                                        "statistics.frequentLocationId":frequentLocationId,
                                        "statistics.frequentLocationCount":frequentLocationCount,
                                        "statistics.latitude":"\(latitude)",
                                        "statistics.longitude":"\(longitude)",
                                        "statistics.numRuns":numRuns
                                    ])
                                } //11. user statistics found
                            } //10. else userLocationRef found
                        } //2. userLocationRef end
                    } //1. userRef end
                    else{
                        print("User does not exist")
                    }
                }
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
                let changeRequest = self.user!.createProfileChangeRequest()
                changeRequest.displayName = name
                changeRequest.commitChanges { error in
                  // ...
                }
            }
        }
    }
    
    func updateProfilePic(url:URL){
        let docRef = db.collection("users").document(user!.uid)
        docRef.updateData([
            "profilePic": url.absoluteString,
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

    func getBuddies(){
        recoList = []
        let uid = user!.uid
        var buddyList:[String] = []
        let buddyRef = db.collection("Buddies").document(uid)
        
        var userLat:Double = 0
        var userLong:Double = 0
        var userPace:Double = 0
        var userDistance:Double = 0
        
        var recoLat:Double = 0
        var recoLong:Double = 0
        var recoPace:Double = 0
        var recoDistance:Double = 0
        
        var LocationNear = true
        var DistanceSimilar = true
        var PaceSimilar = true
        
        buddyRef.getDocument{(document,error) in
            if let document = document, document.exists {
                buddyList = document.data()!["buddyList"]! as! [String]
                print("Buddy 1: \(buddyList[0])")
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
                        userPace = statistics["avgPace"] as! Double
                        userDistance = statistics["avgDistance"] as! Double
                        buddyList.append(uid)
                        
                        self.db.collection("users")
                            .whereField("id", notIn: buddyList)
                            .limit(to: 10)
                            .getDocuments(){ [self](querySnapshot, err) in
                                if let err = err {
                                    print("Error getting documents: \(err)")
                                }
                                else {
                                    for document in querySnapshot!.documents {
                                        print("\(document.documentID) => \(document.data())")
                                            if let statistics = document.data()["statistics"] as? [String: Any] {
                                                recoLat = Double(statistics["latitude"] as! String)!
                                                recoLong = Double(statistics["longitude"] as! String)!
                                                recoPace = statistics["avgPace"] as! Double
                                                recoDistance = statistics["avgDistance"] as! Double
                                                
                                                LocationNear = self.isLocationDistance500OrLesser(lat1: userLat, long1: userLong, lat2: recoLat, long2: recoLong)
                                                PaceSimilar = self.isPaceSimilar(pace1: userPace, pace2: recoPace)
                                                DistanceSimilar = self.isDistanceSimilar(distance1: userDistance, distance2: recoDistance)
                                                
                                                if(LocationNear||PaceSimilar||DistanceSimilar)
                                                {
                                                    let name = document.data()["name"] as Any
                                                    let profilePic = document.data()["profilePic"] as Any
                                                    let buddyReco:BuddyRecoUser = BuddyRecoUser(name: name as! String, profilePic: profilePic as! String)
                                                    self.recoList.append(buddyReco)
                                                    print(buddyReco.name)
                                                    print("Location near:\(LocationNear)")
                                                    print("Pace similar:\(PaceSimilar)")
                                                    print("Distance similar:\(DistanceSimilar)")
                                                }
                                            }
                                        }
                                    if (self.recoList.isEmpty)
                                    {
                                        self.noMatches = true
                                    }
                                    }
                                }
                    }
                    else{
                        self.noStatistics = true
                    }
                }
                else
                {
                    print("Document does not exist")
                }
            }
        }
    }
    
    func isLocationDistance500OrLesser(lat1:Double, long1:Double, lat2:Double, long2:Double)->Bool
    {
        let coord1 = CLLocation(latitude: lat1, longitude: long1)
        let coord2 = CLLocation(latitude: lat2, longitude: long2)
        let distanceInMeters = coord1.distance(from: coord2)
        print("\(distanceInMeters) in function")
        return distanceInMeters <= 500
    }
    
    func isPaceSimilar(pace1:Double,pace2:Double)->Bool{
        let paceDiff = pace1-pace2
        if (paceDiff >= -0.5 && paceDiff <= 0.5)
        {
            return true
        }
        return false
    }
    
    func isDistanceSimilar(distance1:Double, distance2:Double)->Bool{
        let distanceDiff = distance1-distance2
        if (distanceDiff >= -0.5 && distanceDiff <= 0.5)
        {
            return true
        }
        return false
    }
    
    func getBuddyList(){
        var buddyList:[String] = []
        let ref = db.collection("Buddies").document(user!.uid)
        ref.getDocument{(document,error) in
            if let document = document, document.exists {
                buddyList = document.data()!["buddyList"]! as! [String]
                for i in buddyList{
                    let buddyRef = self.db.collection("users").whereField("id", in: buddyList)
                    buddyRef.addSnapshotListener{ (querySnapshot, err) in
                        self.recoList.removeAll()
                        for recUser in querySnapshot!.documents{
                            var data = recUser.data()
                            self.recoList.append(BuddyRecoUser(name: data["name"] as! String, profilePic: data["profilePic"] as! String))
                        }
                    }
                }
              }
            else {
                print("Document does not exist")
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


