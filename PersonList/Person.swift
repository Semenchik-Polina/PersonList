//
//  PersonClass.swift
//  PersonList
//
//  Created by Polina on 2/19/19.
//  Copyright © 2019 Polina. All rights reserved.
//

import Foundation

class Person: NSObject, NSCoding{
  
    var name : String!
    var surname : String!
    var patronymic : String!
    var password : String!
    var aboutMe : String!
    var isMale : Bool!
    var birthDate : Date!
    var photoName : String!
    var loggedIn: Bool!
    
    convenience init(name: String, surname: String, patronymic: String, password: String, aboutMe: String, isMale: Bool, birthDate: Date, photoName: String){
        self.init()
        self.name = name
        self.surname = surname
        self.patronymic = patronymic
        self.password = password
        self.aboutMe = aboutMe
        self.isMale = isMale
        self.birthDate = birthDate
        self.photoName = photoName
        self.loggedIn = false
    }
    
    required convenience init(coder aDecoder: NSCoder){
        self.init()
        self.name = aDecoder.decodeObject(forKey: "name") as? String
        self.surname = aDecoder.decodeObject(forKey: "surname") as? String
        self.patronymic = aDecoder.decodeObject(forKey: "patronymic") as? String
        self.password = aDecoder.decodeObject(forKey: "password") as? String
        self.aboutMe = aDecoder.decodeObject(forKey: "aboutMe") as? String
        self.isMale = aDecoder.decodeBool(forKey: "isMale")
        self.birthDate = aDecoder.decodeObject(forKey: "birthDate") as? Date
        self.photoName = aDecoder.decodeObject(forKey: "photoName") as? String
        self.loggedIn = aDecoder.decodeBool(forKey: "loggedIn")
    }
    
    func initWithCoder(aDecoder: NSCoder) ->Person{
        self.name = aDecoder.decodeObject(forKey: "name") as? String
        self.surname = aDecoder.decodeObject(forKey: "surname") as? String
        self.patronymic = aDecoder.decodeObject(forKey: "patronymic") as? String
        self.password = aDecoder.decodeObject(forKey: "password") as? String
        self.aboutMe = aDecoder.decodeObject(forKey: "aboutMe") as? String
        self.isMale = aDecoder.decodeBool(forKey: "isMale")
        self.birthDate = aDecoder.decodeObject(forKey: "birthDate") as? Date
        self.photoName = aDecoder.decodeObject(forKey: "photoName") as? String
        self.loggedIn = aDecoder.decodeBool(forKey: "loggedIn")
        return self
    }
    
    func encode(with aCoder: NSCoder){
        if let name = name { aCoder.encode(name, forKey: "name")}
        if let surname = surname { aCoder.encode(surname , forKey: "surname")}
        if let patronymic = patronymic { aCoder.encode(patronymic, forKey: "patronymic")}
        if let password = password { aCoder.encode(password, forKey: "password")}
        if let aboutMe = aboutMe { aCoder.encode(aboutMe, forKey: "aboutMe")}
        if let isMale = isMale {aCoder.encode(isMale, forKey: "isMale")}
        if let birthDate = birthDate { aCoder.encode(birthDate, forKey: "birthDate")}
        if let photoName = photoName { aCoder.encode(photoName, forKey: "photoName")}
        if let loggedIn = loggedIn {aCoder.encode(loggedIn, forKey: "loggedIn")}
    }
    
}
