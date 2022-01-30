//
//  CoreDataManager.swift
//  Lepus
//
//  Created by Aw Joey on 22/1/22.
//

import SwiftUI
import Foundation
import CoreData

class CoreDataManager{
    //static let shared = CoreDataManager()
    var runList:[CDRun] = []
    //let container:NSPersistentContainer
    
    private static var container: NSPersistentContainer = {
                let container = NSPersistentContainer(name: "Lepus")
                container.loadPersistentStores { description, error in
                    if let error = error {
                         fatalError("Unable to load persistent stores: \(error)")
                    }
                }
                return container
            }()
    var context: NSManagedObjectContext {
           return Self.container.viewContext
       }
        /*
    init(){
        
        container = NSPersistentContainer(name: "Lepus")
        container.loadPersistentStores {(storeDescription, error) in
            if let error = error as NSError?{
                fatalError("Unresolved error: \(error)")
            }
            }
    }
         */
    
    // Login and Register -> Store the user for persistent session
    func StoreUser(user:User)
    {
        let cdUser = CDUser(context: CoreDataManager.container.viewContext)
        cdUser.userId = user.userId
        cdUser.email = user.email
        cdUser.name = user.name
        cdUser.profilePic = user.profilePic
        
        do {
            try CoreDataManager.container.viewContext.save()
            print("Saved user")
        }
        catch let error as NSError {
            print("Could not store user. \(error), \(error.userInfo)")
        }
    }
    
    // Check if user has already been logged in
    func isLoggedIn()->User{
        let fetchRequest:NSFetchRequest<CDUser> =  CDUser.fetchRequest()
        var user:User = User(userId: "", email: "", name: "", profilePic: "", height: 0, weight: 0, gender: "")
        do {
            
            let cdUser = try CoreDataManager.container.viewContext.fetch(fetchRequest)
            if (cdUser.count > 0)
            {
                user.userId = cdUser[0].userId!
                user.email = cdUser[0].email!
                user.name = cdUser[0].name!
                user.profilePic = cdUser[0].profilePic!     
            }
            
        }catch let error as NSError {
            print("Could not get a user. \(error), \(error.userInfo)")
        }
        
        return user
    }
    
    //Log Out -> Remove logged-in user details
    func LogOutUser(id:String)
    {
        let fetchRequest:NSFetchRequest<CDUser> = CDUser.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "userId= %@", id)
        
        do {
            let cdUser = try CoreDataManager.container.viewContext.fetch(fetchRequest)
            CoreDataManager.container.viewContext.delete(cdUser[0])
            try CoreDataManager.container.viewContext.save()
        }
        catch let error as NSError {
            CoreDataManager.container.viewContext.rollback()
            print("Could not log out user. \(error), \(error.userInfo)")
        }
    }
    
    
    func saveRun(duration:String, pace:Double, distance:Double, startLatitude:Double, startLongitude:Double){
        let cdRun = CDRun(context: CoreDataManager.container.viewContext)
        cdRun.pace = pace
        cdRun.duration = duration
        cdRun.date = Date()
        cdRun.distance = distance
        cdRun.startLatitude = startLatitude
        cdRun.startLongitude = startLongitude
        do {
            try CoreDataManager.container.viewContext.save()
            print("Saved Run")
        }
        catch let error as NSError {
            print("Could not store run. \(error), \(error.userInfo)")
        }
    }
    
    func getRuns()->[CDRun]{
        let fetchRequest:NSFetchRequest<CDRun> =  CDRun.fetchRequest()
        do {
            
            let cdRun = try CoreDataManager.container.viewContext.fetch(fetchRequest)
            if (cdRun.count > 0)
            {
                runList = cdRun
            }
            
        }
        catch let error as NSError {
            print("Could not get the runs. \(error), \(error.userInfo)")
        }
        
        return runList
    }
    
    func updateUsername(name:String, id:String){
        let fetchRequest:NSFetchRequest<CDUser> = CDUser.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "userId= %@", id)
        
        do{
            let cdUser = try CoreDataManager.container.viewContext.fetch(fetchRequest)
            cdUser[0].name = name
            try CoreDataManager.container.viewContext.save()
            
        }catch let error as NSError {
            print("Could not get a user. \(error), \(error.userInfo)")
        }
    }
    
    func updateUserPhoto(id:String, photoUrl:String){
        let fetchRequest:NSFetchRequest<CDUser> = CDUser.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "userId= %@", id)
        
        do{
            let cdUser = try CoreDataManager.container.viewContext.fetch(fetchRequest)
            cdUser[0].profilePic = photoUrl
            try CoreDataManager.container.viewContext.save()
            
        }catch let error as NSError {
            print("Could not get a user. \(error), \(error.userInfo)")
        }
    }
    
    
}

class CoreDataUserManager: ObservableObject{
    @Published var user:User? = CoreDataManager().isLoggedIn()
}

