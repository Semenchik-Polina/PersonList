//
//  UserList.swift
//  PersonList
//
//  Created by Polina on 2/27/19.
//  Copyright © 2019 Polina. All rights reserved.
//

import Foundation

class UserList{
    
    static let shared = UserList()
    
    var list = [Person]()
    private let userDefaults = UserDefaults.standard

    private init(){
        load()
    }
    
    func load(){
        if let loadedData = UserDefaults().data(forKey: "personData"){
            if let loadedPersonList = NSKeyedUnarchiver.unarchiveObject(with: loadedData) as? [Person]{
                for person in loadedPersonList {
                    list.append(person )
                    person.loggedIn = false
                }
            }
        }
    }
    
    func save(){
        let personData = NSKeyedArchiver.archivedData(withRootObject: list)
        userDefaults.set(personData, forKey: "personData")
        userDefaults.synchronize()
    }
    
    func sort(){
        for index in stride(from: list.count-1, to: 1, by: -1){
            if (list[index].loggedIn){
                list.swapAt(index, 0)
            }
        }
        save()
    }
    
    func updateUser(updatedUser: Person){
        for user in list{
            if (user.name == updatedUser.name && user.surname == updatedUser.surname){
                list[list.firstIndex(of: user)!] = updatedUser
            }
        }
    }
}
