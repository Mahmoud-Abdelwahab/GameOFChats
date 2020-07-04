//
//  ViewController.swift
//  GameOFChats
//
//  Created by kasper on 7/3/20.
//  Copyright © 2020 Mahmoud.Abdul-Wahab.GameOfChats. All rights reserved.
//

import UIKit
import Firebase

class MessagesVC: UITableViewController {
    
    
    override func viewWillAppear(_ animated: Bool) {
        checkIfUserIsLoggedIn()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //        view.backgroundColor = .green
        
        navigationItem.leftBarButtonItem  = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handelLogout))
        
         let image = UIImage(named: "new-message")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image:image , style: .plain, target: self, action: #selector(handelNewMessage))
        
    }
    
    
    
   @objc func handelNewMessage()  {
        let newMessageVC = NewMessageVC()
    let nav = UINavigationController(rootViewController: newMessageVC)
    nav.modalPresentationStyle = .fullScreen
    present( nav , animated: true, completion: nil)
    }
    
    
    
    func checkIfUserIsLoggedIn() {
         if Auth.auth().currentUser?.uid == nil {
             perform(#selector(handelLogout), with: nil, afterDelay: 0)
         } else {
             let uid = Auth.auth().currentUser?.uid
             Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                 
                 if let dictionary = snapshot.value as? [String: AnyObject] {
                     self.navigationItem.title = dictionary["name"] as? String
                 }
                 
                 }, withCancel: nil)
         }
     }
    
    
    @objc func handelLogout(){
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        let loginVC = LoginVC()
        loginVC.modalPresentationStyle = .fullScreen
        present(loginVC , animated : true , completion: nil)
    }
    
    
    
}

