//
//  RegistrateViewController.swift
//  PersonList
//
//  Created by Polina on 2/16/19.
//  Copyright © 2019 Polina. All rights reserved.
//

import UIKit

class RegistrateViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {

    @IBOutlet weak var ScrollView: UIScrollView!
    @IBOutlet weak var NameTextField: UITextField!
    @IBOutlet weak var SurnameTextField: UITextField!
    @IBOutlet weak var PatronymicTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var AboutMeTextField: UITextView!
    @IBOutlet weak var SexSegmentedControl: UISegmentedControl!
    @IBOutlet weak var BirthDatePicker: UIDatePicker!
    @IBOutlet weak var PhotoView: UIImageView!
    
    private let keyboardObserver = KeyboardHeightObserver()
        
    var editingUser: Person! = nil
    var photoChanged: Bool = false
    
     override func viewDidLoad() {
        super.viewDidLoad()
        
        keyboardObserver.heightChangedClosure = { [weak self] newHeight in
            guard let self = self else { return }
            var contentInset = self.ScrollView.contentInset
            contentInset.bottom = newHeight
            UIView.animate(withDuration: 2.5, animations: {
                self.ScrollView.contentInset = contentInset
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (editingUser != nil){
            lockEditing()
            if !photoChanged{
                do {
                    try PhotoView.image = UserPhotoHandler.getImageFromDocumentDirectory(imageName: editingUser.photoName)
                } catch UserPhotoError.noImage(let message) {
                    displayAlertMessage(message: message)
                } catch {
                    displayAlertMessage(message: "Unexpected error")
                }
            }
        }
     }
    

    @IBAction func BackAction(_ sender: Any) {
        editingUser = nil
        self.dismiss(animated: true, completion: nil)
    }
    
    func lockEditing(){
        NameTextField.text! = editingUser.name
        SurnameTextField.text! = editingUser.surname
        PatronymicTextField.text! = editingUser.patronymic
        PasswordTextField.text! = editingUser.password
        SexSegmentedControl!.selectedSegmentIndex = editingUser.isMale ? 0 : 1
        BirthDatePicker!.date = editingUser.birthDate
        AboutMeTextField.text! = editingUser.aboutMe
        
        
        NameTextField.isUserInteractionEnabled = false
        SurnameTextField.isUserInteractionEnabled = false
        PatronymicTextField.isUserInteractionEnabled = false
        PasswordTextField.isUserInteractionEnabled = false
        SexSegmentedControl.isUserInteractionEnabled = false
        BirthDatePicker.isUserInteractionEnabled = false
    }
    
    @IBAction func ChangePhotoAction(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler:  { (action:UIAlertAction) in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            }else{
                self.displayAlertMessage(message: "Camera isn't available")
            }
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Photo library", style: .default, handler:  { (action:UIAlertAction) in imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        self.PhotoView.image = image
        picker.dismiss(animated: true, completion: nil)
        photoChanged = true
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
  
    @IBAction func SaveAction(_ sender: Any) {
        if (editingUser == nil){
            
            do {
                try saveNewUser()
            } catch ValidationError.emptyFields(let errorMessage){
                displayAlertMessage(message: errorMessage)
                return
            } catch ValidationError.invalidNSP(let errorMessage){
                displayAlertMessage(message: errorMessage)
                return
            } catch ValidationError.invalidBirthDate(let errorMessage){
                displayAlertMessage(message: errorMessage)
                return
            } catch ValidationError.invalidAboutMe(let errorMessage){
                displayAlertMessage(message: errorMessage)
                return
            } catch{
                displayAlertMessage(message: "Unexpected: \(error)")
                return
            }
            
            UserList.shared.save()
            performSegue(withIdentifier: "RegistrationToUserList", sender: self)
        }else{
            editExistingUser()
            UserList.shared.save()
            editingUser = nil
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        let usersListVC = segue.destination as? UserListViewController
        usersListVC?.isFromRegistration = true
    }
    
    func saveNewUser() throws{
        let userName = NameTextField.text!
        let userSurname = SurnameTextField.text!
        let userPatronymic = PatronymicTextField.text!
        let userPassword = PasswordTextField.text!
        let userAbout = AboutMeTextField.text!
        let userBirthDate: Date = BirthDatePicker!.date
        let userIsMale: Bool = (SexSegmentedControl!.selectedSegmentIndex == 0)
        let userPhotoName: String = userName + " " + userSurname
        
        let person = Person(name: userName, surname: userSurname, patronymic: userPatronymic, password: userPassword, aboutMe: userAbout, isMale: userIsMale, birthDate: userBirthDate, photoName: userPhotoName)
        
        try PersonDataValidator.validate(person: person)
        
        UserPhotoHandler.saveImageDocumentDirectory(image: PhotoView.image!, imageName: userPhotoName)
        
        if !UserList.shared.list[0].loggedIn {
            person.loggedIn = true
        }
        UserList.shared.list.append(person)
    
    }
    
    func editExistingUser(){
      //  let userPhotoName: String = NameTextField.text! + " " + SurnameTextField.text!
        let userAbout = AboutMeTextField.text!
        
        
        do {
            try PersonDataValidator.validateAboutMe(aboutMe: userAbout)
        } catch ValidationError.invalidAboutMe(let errorMessage) {
            displayAlertMessage(message: errorMessage)
            return
        }catch {
            displayAlertMessage(message: "Unexpected: \(error)")
            return
        }
        
        editingUser.aboutMe = userAbout
        UserPhotoHandler.deleteImageFromDocumentDirectory(imageName: editingUser.photoName)
        UserPhotoHandler.saveImageDocumentDirectory(image: PhotoView.image!, imageName: editingUser.photoName)
        UserList.shared.updateUser(updatedUser: editingUser)
    }
    
    func displayAlertMessage(message: String){
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okAction)
        self.present(alert,animated:true,completion: nil)
    }
    
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        if textView == AboutMeTextField {
//            view.frame.origin.y += 200
//        }
//    }
}

