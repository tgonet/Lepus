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
    
    func readRuns(){
        db.collection("runs").whereField("userId", isEqualTo: user!.uid).addSnapshotListener{ (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.runList.removeAll()
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    let data = document.data()
                    let date = data["Date"] as? Timestamp
                    let pace = data["Pace"] as? Double
                    let name = data["Name"] as? String
                    let distance = data["Distance"] as? Double
                    let duration = data["Duration"] as? String
                    let url = data["Url"] as? String
                    self.runList.append(Run(name: name as! String, date: date!.dateValue(), distance: distance as! Double, pace: pace as! Double, duration: duration as! String, url:url as! String))
                    }
                }
        }
        
        }
    func saveRun(duration:String, pace:Double, distance:Double, url:String, coord:CLLocationCoordinate2D){
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_SG")
        dateFormatter.dateFormat = "dd MMM YYYY H:mm a"
        let date = dateFormatter.string(from: Date())
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
        var recouidList:[String] = []
        var buddyReco:BuddyRecoUser?
        let uid = user!.uid
        var buddyList:[String] = []
        let buddyRef = db.collection("Buddies").document(uid)
        buddyRef.getDocument{(document,error) in
            if let document = document, document.exists {
                buddyList = document.data()!["buddyList"]! as! [String]
                print(buddyList[0])
              }
            else {
                print("Document does not exist")
            }
            let userStatRef = self.db.collection("BuddyRecommendation").document(uid)
            userStatRef.getDocument{(document,error) in
                if let document = document, document.exists {
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
                            
                            self.db.collection("Users")
                                .getDocuments(){(querySnapshot, err) in
                                    if let err = err {
                                        print("Error getting documents: \(err)")
                                    }
                                    else {
                                        for document in querySnapshot!.documents {
                                            print("\(document.documentID) => \(document.data())")
                                            for uid in recouidList
                                            {
                                                if (document.documentID == uid)
                                                {
                                                    let data = document.data()
                                                    let name = data["name"] as Any
                                                    let profilePic = data["profilePic"] as Any
                                                    let buddyReco:BuddyRecoUser = BuddyRecoUser(name: name as! String, profilePic: profilePic as! String)
                                                    self.recoList.append(buddyReco)
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


