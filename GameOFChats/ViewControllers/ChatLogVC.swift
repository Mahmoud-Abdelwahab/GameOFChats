//
//  ChatLogVC.swift
//  GameOFChats
//
//  Created by kasper on 7/6/20.
//  Copyright © 2020 Mahmoud.Abdul-Wahab.GameOfChats. All rights reserved.
//

import UIKit
import Firebase
class ChatLogVC: UICollectionViewController  {

    var user : User?{
           didSet{   /// when i initialize this variable from the previous vc this set tthe title automatice
          title  = user?.name
           }
       }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        title = "Chat Log Controller"
        collectionView.backgroundColor = .white
        setUpInputComponents()
    }

    private func setUpInputComponents(){
        
        let inputContainer : UIView = {
            let container   = UIView()
            
//            container.backgroundColor = .green
            container.translatesAutoresizingMaskIntoConstraints = false
            
            
            return container
        }()
        /// adding the input container to the parent container
        view.addSubview(inputContainer)
        
     
        
        let sendButton : UIButton = {
            let button = UIButton(type: .system)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitle("Send", for: .normal)
            button.addTarget(self, action: #selector(sendMessagesButton), for: .touchUpInside)
                  return button
              }()
              
        
        //******* Line separator
        let separatorLine : UIView = {
            let line = UIView()
            line.translatesAutoresizingMaskIntoConstraints = false
            line .backgroundColor  = UIColor(r: 220, g: 220, b: 220)
            return line
        }()
        
        inputContainer.addSubview(inputText)
        inputContainer.addSubview(sendButton)
        inputContainer.addSubview(separatorLine)

        /// * *** * * * * ** * * * * ** * * * * ** * * * * * * * * * * * * *
        /// right / left anchor constraints doesn't affrcted by localization so you can use it whenever you want to do this
        /// leading / trailling constraints affected by localization if arabic reading direction gos from right to left  and so on .
        //iOS 9 constatints
        NSLayoutConstraint.activate([
            inputContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            inputContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            inputContainer.heightAnchor.constraint(equalToConstant: 60),
            inputContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
            
            // input text constraints
            
            inputText.leadingAnchor.constraint(equalTo: inputContainer.leadingAnchor, constant: 8),
            inputText.centerYAnchor.constraint(equalTo: inputContainer.centerYAnchor),
            inputText.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor),
            inputText.heightAnchor.constraint(equalTo: inputContainer.heightAnchor),
            
            /// button constraints
            sendButton.widthAnchor.constraint(equalToConstant: 60),
            sendButton.trailingAnchor.constraint(equalTo: inputContainer.trailingAnchor),
            sendButton.bottomAnchor.constraint(equalTo: inputContainer.bottomAnchor),
            sendButton.heightAnchor.constraint(equalTo: inputContainer.heightAnchor),
            
            // separator line
            separatorLine.centerXAnchor.constraint(equalTo: inputContainer.centerXAnchor),
            separatorLine.widthAnchor.constraint(equalTo: inputContainer.widthAnchor),
            separatorLine.heightAnchor.constraint(equalToConstant: 1)
        ])
        
    }
    
    
    let inputText : UITextField = {
             let input = UITextField()
             input.placeholder = "Write your message ..."
             input.translatesAutoresizingMaskIntoConstraints = false
        
        ///********** ** * **  ***  ** * *
       /// to enable Enter key from the keyboard you
      
             return input
         }()
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendMessagesButton()
        return true
    }
    
    @objc func sendMessagesButton(){
        
        guard let text = inputText.text , !text.isEmpty else {
            print(" the text filed is empty ")
            return
        }
        inputText.delegate = self
        let ref = Firebase.Database.database().reference().child("messages")
        let fromID  = Auth.auth().currentUser!.uid
        let timeStamp  = Int64(NSDate().timeIntervalSince1970)
        ref.childByAutoId().updateChildValues(["text" : text , "toID": user!.id! , "formID" : fromID ,"timeStamp" : timeStamp])
        
    }
}



extension ChatLogVC : UITextFieldDelegate {
    
    
}
