//
//  UserCell.swift
//  PersonList
//
//  Created by Polina on 2/24/19.
//  Copyright © 2019 Polina. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {

    @IBOutlet weak var UserPhotoImageView: UIImageView!
    @IBOutlet weak var NSPLabel: UILabel!
    @IBOutlet weak var SexLabel: UILabel!
    @IBOutlet weak var AgeLabel: UILabel!
 
    func setUser(user: Person){
        do {
            try UserPhotoImageView.image = UserPhotoHandler.getImageFromDocumentDirectory(imageName: user.photoName)
        } catch UserPhotoError.noImage(let message) {
            print(message)
        } catch {
            print("Unexpected error")
        }
        NSPLabel.text = user.name + " " + user.surname + " " + user.patronymic
        SexLabel.text = user.isMale ? "Male" : "Female"
        AgeLabel.text = String(getAge(birthDate: user.birthDate)) + "years old"
    }
    
    func getAge(birthDate: Date)->Int{
        let calendar = Calendar.current
        let now = Date()
        let ageComponents = calendar.dateComponents([.year], from: birthDate, to: now)
        return ageComponents.year!
    }
}
