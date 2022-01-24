//
//  CoreDataManager.swift
//  Lepus
//
//  Created by Aw Joey on 22/1/22.
//

import Foundation
import CoreData

class CoreDataManager{
    static let shared = CoreDataManager()
    let container:NSPersistentContainer
    
    init(){
        container = NSPersistentContainer(name: "Lepus")
        container.loadPersistentStores {(storeDescription, error) in
            if let error = error as NSError?{
                fatalError("Unresolved error: \(error)")
            }
            }
    }
    
    // Login and Register -> Store the user for persistent session
    func StoreUser(user:User)
    {
        let cdUser = CDUser(context: container.viewContext)
        cdUser.userId = user.userId
        cdUser.email = user.email
        cdUser.name = user.name
        cdUser.profilePic = user.profilePic
        
        do {
            try container.viewContext.save()
            print("Saved user")
        }
        catch let error as NSError {
            print("Could not store user. \(error), \(error.userInfo)")
        }
    }
    
    // Check if user has already been logged in
    func isLoggedIn()->User{
        let fetchRequest:NSFetchRequest<CDUser> =  CDUser.fetchRequest()
        
        var user:User = User(userId: "", email:"", name: "", profilePic: "")
        do {
            
            let cdUser = try container.viewContext.fetch(fetchRequest)
            if (cdUser.count > 0)
            {
                user.userId = cdUser[0].userId!
                user.email = cdUser[0].email!
                user.name = cdUser[0].name!
                user.profilePic = cdUser[0].profilePic
            }
            
        }catch let error as NSError {
            print("Could not get a user. \(error), \(error.userInfo)")
        }
        
        return user
    }
    
    //Log Out -> Remove logged-in user details
    func LogOutUser(user:User)
    {
        var cdUser:CDUser?
        cdUser!.userId = user.userId
        cdUser!.name = user.name
        cdUser?.profilePic = user.profilePic
        container.viewContext.delete(cdUser!)
        
        do {
            try container.viewContext.save()
        }
        catch let error as NSError {
            container.viewContext.rollback()
            print("Could not log out user. \(error), \(error.userInfo)")
        }
    }
    
    // For development testing
    func getUsers()->[User]{
        let fetchRequest:NSFetchRequest<CDUser> =  CDUser.fetchRequest()
        
        var userList:[User] = []
        do {
            let cdUsers = try container.viewContext.fetch(fetchRequest)
            if (cdUsers.count != 0)
            {
                for cdUser in cdUsers {
                    let u: User = User(userId: "", email:"", name: "", profilePic: "")
                    u.userId = cdUser.userId!
                    u.name = cdUser.name!
                    u.profilePic = cdUser.profilePic
                    userList.append(u)
                    print("\(u.userId) is stored in CoreData")
                }
            }
            
        }catch let error as NSError {
            print("Could not get a user. \(error), \(error.userInfo)")
        }
        
        return userList
    }
}

class CoreDataUserManager: ObservableObject{
    @Published var user:User = CoreDataManager().isLoggedIn()
}

