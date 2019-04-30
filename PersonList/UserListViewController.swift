//
//  UserListViewController.swift
//  PersonList
//
//  Created by Polina on 2/24/19.
//  Copyright © 2019 Polina. All rights reserved.
//

import UIKit

class UserListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var selectedIndex = -1
    var isFromRegistration = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UserList.shared.sort()
        tableView.reloadData()
        selectedIndex = -1
    }
    
    @IBAction func logOutAction(_ sender: Any) {
        UserList.shared.list[0].loggedIn = false
        if isFromRegistration {
            self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    @IBAction func addUserAction(_ sender: Any) {
        performSegue(withIdentifier: "UserListToRegistration", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        let registrationVC = segue.destination as? RegistrateViewController
        if (selectedIndex > -1){
            registrationVC?.editingUser = UserList.shared.list[selectedIndex+1]
        }
    }
    
    func displayAlertMessage(message: String){
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okAction)
        self.present(alert,animated:true,completion: nil)
    }
    
}

extension UserListViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserList.shared.list.count-1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = UserList.shared.list[indexPath.row+1]
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as! UserCell
        cell.setUser(user: user)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "UserListToRegistration", sender: self)
        tableView.reloadData()
    }
    

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            UserList.shared.list.remove(at: indexPath.row+1)
            self.tableView.reloadData()
            UserList.shared.save()
        }
      }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let user = UserList.shared.list[0]
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as! UserCell
        cell.setUser(user: user)
        cell.backgroundColor  = UIColor.lightGray
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 90
    }
    
}

