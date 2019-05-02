//
//  SignInViewController.swift
//  PersonList
//
//  Created by Polina on 2/16/19.
//  Copyright © 2019 Polina. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {
    
    
    @IBOutlet weak var NameSurnameTextBox: UITextField!
    @IBOutlet weak var PasswordTextBox: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
   /* override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (UserList.shared.list[0].loggedIn == true){
            performSegue(withIdentifier: "SigningInToRegistration", sender: self)
        }
    }*/
    
    func displayAlertMessage(message: String){
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okAction)
        self.present(alert,animated:true,completion: nil)
    }
    
    @IBAction func SignInAction(_ sender: Any) {
        let nameSurname = NameSurnameTextBox.text!
        let password = PasswordTextBox.text!
        for user in UserList.shared.list {
            if (nameSurname.elementsEqual(user.name+" "+user.surname) && password.elementsEqual(user.password)){
                user.loggedIn = true
                UserList.shared.sort()
                performSegue(withIdentifier: "SignInToUserList", sender: self)
                return
            }
        }
        displayAlertMessage(message: "Wrong name and surname or password")
    }

}
