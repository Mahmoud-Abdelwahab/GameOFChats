//
//  NewMessageVC.swift
//  GameOFChats
//
//  Created by kasper on 7/4/20.
//  Copyright © 2020 Mahmoud.Abdul-Wahab.GameOfChats. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class NewMessageVC: UITableViewController {
    
    var users  = [User]()
    var messageVCRef : MessagesVC!
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
            guard let name = dictionary["name"] as? String , let email = dictionary["email"] as? String , !name.isEmpty , !email.isEmpty , let profileImage =  dictionary["profileImageUrl"] as? String , !profileImage.isEmpty  else {
                
                return
            }
            
            let toID = snapshot.key
            let user = User(id: toID, name: name, email: email, profileImageUrl: profileImage )
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! UserCell
        
        cell.textLabel?.text       = users[indexPath.row].name
        cell.detailTextLabel?.text = users[indexPath.row].email
      //  cell.imageView?.image      = UIImage(named: "gameofthrones")
        
        if  let imageUrl = users[indexPath.row].profileImageUrl
        {
            cell.profileImage.sd_setImage( with: URL(string: imageUrl), completed: { (image, error, cash, url) in
                DispatchQueue.main.async {
                    cell.profileImage.image = image
//                    tableView.reloadData()
                }
            })
        }
    
    
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }

    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true) {
            // clouser
            print("dismiss th conteoleer ")
            self.messageVCRef.showChatLogVC(user : self.users[indexPath.row])
        }
    }
}
