//
//  UserDataValidator.swift
//  PersonList
//
//  Created by Polina on 2/23/19.
//  Copyright © 2019 Polina. All rights reserved.
//

import Foundation

enum ValidationError: Error {
    case invalidNSP(String)
    case emptyFields(String)
    case invalidAboutMe(String)
    case invalidBirthDate(String)
}

class PersonDataValidator{
    
    //>5 symbols, 1 uppercase, 1 lowercase, 1 number
    static let PASSWORD_REGEX = "(?=^.{6,}$)(?=.*\\d)(?=.*[A-Z])(?=.*[a-z])(?!.*\\s).*$"
    //2-20 symbols, latin letters, numbers, begins with uppercase
    //for name, surname, patronymic
    static let NSP_REGEX = "^[A-Z][a-zA-Z]{1,19}$"
    
    
    //class - to allow subclasses to override the superclass's implementation
    class func validateDate(isMale: Bool, birthDate: Date) throws {
        if (!isMale){
            let calendar = Calendar.current
            let now = Date()
            let ageComponents = calendar.dateComponents([.year], from: birthDate, to: now)
            if (ageComponents.year! > 56){
                throw ValidationError.invalidBirthDate("Women's age should be less than 56")
            }
        }
    }

    class func validateWithRegularExpresion(text: String, regex: String, alertMessage: String)throws {
        if !(text.isEmpty){
            let range = NSMakeRange(0, text.utf16.count)
            let regex = try! NSRegularExpression(pattern: regex, options: [])
            if (regex.firstMatch(in: text, options: [], range: range) == nil){
                throw ValidationError.invalidNSP(alertMessage)
            }
        }
    }
    
    class func checkMatchesWithUserList(person: Person) throws {
        for user in UserList.shared.list {
            if (person.name == user.name && person.surname == user.surname){
                throw ValidationError.invalidNSP("User with this name&surname already exists")
            }
        }
    }
    
    class func validateAboutMe(aboutMe: String) throws {
        if (aboutMe.count<10){
            throw ValidationError.invalidAboutMe("Field \"About me\" should contain at least 10 symbols")
        }
    }
    
    class func checkOnEmptyFields(person: Person) throws {
        if (person.name.isEmpty || person.surname.isEmpty || person.password.isEmpty || person.aboutMe.isEmpty){
            throw ValidationError.emptyFields("All field but patronymic one are required")
        }
    }
    
    class func validate(person: Person) throws {
        
        let passwordAlertMessage = "Password should consist of >5 letters and numbers with at least 1 uppercase, 1 lowercase, 1 number"
        let nspAlertMessage = " should consist of >2 letters and begin with uppercase"
    
        try checkOnEmptyFields(person: person)
        try validateDate(isMale: person.isMale, birthDate: person.birthDate)
        try validateAboutMe(aboutMe: person.aboutMe)
        try validateWithRegularExpresion(text: person.name, regex: NSP_REGEX, alertMessage: "Name\(nspAlertMessage)")
        try validateWithRegularExpresion(text: person.surname, regex: NSP_REGEX, alertMessage: "Surname\(nspAlertMessage)")
        try validateWithRegularExpresion(text: person.patronymic, regex: NSP_REGEX, alertMessage: "Patronymic\(nspAlertMessage)")
        try validateWithRegularExpresion(text: person.password, regex: PASSWORD_REGEX, alertMessage: passwordAlertMessage)
        try checkMatchesWithUserList(person: person)
    }
}
