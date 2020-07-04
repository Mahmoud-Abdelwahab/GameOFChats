//
//  NewMessageVC.swift
//  GameOFChats
//
//  Created by kasper on 7/4/20.
//  Copyright © 2020 Mahmoud.Abdul-Wahab.GameOfChats. All rights reserved.
//

import UIKit
import Firebase
class NewMessageVC: UITableViewController {

        var users  = [User]()
        override func viewDidLoad() {
            super.viewDidLoad()
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action:#selector(handelCancel))
            
            // registering cell
            tableView.register(UserCell.self, forCellReuseIdentifier: "Cell")
            
            fetchUser()
            
        }
       
      @objc  func handelCancel() {
        
            dismiss(animated: true, completion: nil)
        }
        
        func fetchUser()  {
            
            Firebase.Database.database().reference().child("users").observe(.childAdded) { (snapshot) in
                print(snapshot)
                guard let dictionary = snapshot.value as? [String : Any] else{
                    print("no users ")
                    return
                }
                /// *** **** * * * * *** ** new way to decode snapshot value
                guard let name = dictionary["name"] as? String , let email = dictionary["email"] as? String , !name.isEmpty , !email.isEmpty else {
                     
                     return
                }
                let user = User(name: name, email: email)
                self.users.append(user)
               
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
              
            }
        }

        
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        users.count
    }
        
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            
            cell.textLabel?.text       = users[indexPath.row].name
            cell.detailTextLabel?.text = users[indexPath.row].email
            
            return cell
        }
        
    }

class UserCell : UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}


    extension NewMessageVC {
        
        
    }
