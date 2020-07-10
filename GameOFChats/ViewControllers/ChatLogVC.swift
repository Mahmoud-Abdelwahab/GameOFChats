//
//  ChatLogVC.swift
//  GameOFChats
//
//  Created by kasper on 7/6/20.
//  Copyright © 2020 Mahmoud.Abdul-Wahab.GameOfChats. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
class ChatLogVC: UICollectionViewController  {
    
    var messages = [Message]()
    var user : User?{
        didSet{   /// when i initialize this variable from the previous vc this set tthe title automatice
            title  = user?.name
            observeMessages()
        }
    }
    
    func observeMessages(){
        
        guard let uid = Auth.auth().currentUser?.uid else{return}
        Database.database().reference().child("user-messages").child(uid).observe(.childAdded, with: { (snapshot) in
            
            let messageKey = snapshot.key
            
            Database.database().reference().child("messages").child(messageKey).observeSingleEvent(of: .value, with: { (snapshot) in
                
                guard let dictionary = snapshot.value as? [ String: AnyObject] else{return}
                
                guard   let text = dictionary["text"] as? String , !text.isEmpty , let formId  = dictionary["fromID"] as? String , !formId.isEmpty , let toID  = dictionary["toID"] as? String , !toID.isEmpty   , let times  = dictionary["timeStamp"] as? NSNumber   else
                {
                    return
                }
                
                let message = Message()
                //  message.setValuesForKeys(dictionary)
                message.text = text
                message.toID = toID
                message.timeStamp = times
                message.fromID = formId
                
                if message.chatPartner() == self.user?.id {
                    
                    self.messages.append(message)
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
            }, withCancel: nil)
            
        }, withCancel: nil)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // to make the very top space before the first cell on the top
        collectionView.contentInset = UIEdgeInsets(top:15, left: 0, bottom: 80, right: 0)
        // is how to remove the right side scroll padding
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top:0, left: 0, bottom: 70, right: 0)
        
        // registring th cell
        collectionView.register(ChatMessageCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.alwaysBounceVertical = true // this to make collection view dragable
        //        title = "Chat Log Controller"
        collectionView.backgroundColor = .white
        setUpInputComponents()
        
        setUpKeyBoardObserver()
        
        ///***************** if uou want the keyboard to scroll up & down with the  collection view &table view scrollling ************
        collectionView.keyboardDismissMode = .interactive
    }
    
    
    func setUpKeyBoardObserver() {
        // when key board appeare it firs a notification so i will liesten for this notification then add action  when it fire
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // this is very important to remove notification  observer
        //** if you didn't remove it it will casue memory leak
        NotificationCenter.default.removeObserver(self)
    }
    
    
    // this method will be called every time the keyboard will showed
    @objc func handleKeyboardWillShow(_ notification: Notification) {
        // this nitification veriable sent automatically to this method this hold information about how to get the height for the keyboard and ex ....
        print(notification.userInfo) // this hold this info
        let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        
         // **** keyboardFrame this var hold the key board fram we can access the height of it
        print(keyboardFrame?.height)
        // after i get the keyboard height i will move the imput view to top be the height
        
        
        let keyboardDuration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        
        
        // push up the inputContainer to the top with the keyboard height
        containerViewBottomAnchor?.constant = -keyboardFrame!.height
        
        UIView.animate(withDuration: keyboardDuration!, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    
     // dismiss the keyboard  command+k
    @objc func handleKeyboardWillHide(_ notification: Notification) {
        let keyboardDuration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
         
        containerViewBottomAnchor?.constant = -40   // 0
         
        
        //keyboardDuration  this is the keyboard duration to shown up
        UIView.animate(withDuration: keyboardDuration!, animations: {
            self.view.layoutIfNeeded() // this used every time you need to animate the constaints after modifing it  like this   containerViewBottomAnchor?.constant = 0
        })
        
    }
    
    
    var containerViewBottomAnchor : NSLayoutConstraint!
    
    private func setUpInputComponents(){
        
        let inputContainer : UIView = {
            let container   = UIView()
            container.backgroundColor = .white
            //            container.backgroundColor = .green
            container.translatesAutoresizingMaskIntoConstraints = false
            
            
            return container
        }()
        /// adding the input container to the parent container
        view.addSubview(inputContainer)
        
        
        let inputText : UITextField = {
            let input = UITextField()
            input.placeholder = "Write your message ..."
            input.translatesAutoresizingMaskIntoConstraints = false
            input.delegate = self               ///********** ** * **  ***  ** * *
            /// to enable Enter key from the keyboard you
            
            return input
        }()
        
        inputTextReferance = inputText
        
        
        
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
        
        /// the input container botton constraints  is vaiable with the keyboard height
        containerViewBottomAnchor = inputContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40)
        containerViewBottomAnchor.isActive = true
        
        /// * *** * * * * ** * * * * ** * * * * ** * * * * * * * * * * * * *
        /// right / left anchor constraints doesn't affrcted by localization so you can use it whenever you want to do this
        /// leading / trailling constraints affected by localization if arabic reading direction gos from right to left  and so on .
        //iOS 9 constatints
        NSLayoutConstraint.activate([
            inputContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            inputContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            inputContainer.heightAnchor.constraint(equalToConstant: 60),
            
           // inputContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
            
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
    
    var inputTextReferance : UITextField?
    
    @objc func sendMessagesButton(){
        
        guard let text = inputTextReferance?.text , !text.isEmpty else {
            print(" the text filed is empty ")
            return
        }
        
        //let ref = Firebase.Database.database().reference().child("messages")
        let fromID  = Auth.auth().currentUser!.uid
        let timeStamp = Int(Date().timeIntervalSince1970)
        
        let toID = user!.id!
        //**** here i added the message in the messages table and to support multible user i will add the message IDs in another table with  key ---> equal to the sender id to get all messages that belong to this user only from the big messages table
        let values = ["text" : text , "toID": user!.id! , "fromID" : fromID ,"timeStamp" : timeStamp] as [String : Any]
        let messageRef = Firebase.Database.database().reference().child("messages").childByAutoId()
        
        
        messageRef.updateChildValues(values) {  (error, dbRef) in
            guard error == nil
                else{
                    return
            }
            
            self.inputTextReferance?.text = nil
            
            /// here adding the userMessages table to  group the meesage for every user  --> to get his messages only هنا بخزن الرسايل ال ببعتها بتاعت اليوزر الحالى مع اليوزر ال بكلمه عشان اقدر ا اجيبها اما افتح الشات بينى وبينه تانى 
            // the message key
            guard let messageId = messageRef.key else { return }
            
            let userMessagesRef = Database.database().reference().child("user-messages").child(fromID).child(messageId)
            userMessagesRef.setValue(1)
            
            ///****** hee i will add in user-message table also the group of message for  erver recipient user to get the peer mesage also هنا بخزن الرسايل بتاعت الراجل ال بكلمه بالا اى دى بتاعه عشان اجبلو الرسايل بتوعو بس من طرفه
            
            let recipientUserMessagesRef = Database.database().reference().child("user-messages").child(toID).child(messageId)
            recipientUserMessagesRef.setValue(1)
            
            
            
        }
        
        
        
    }
}

extension ChatLogVC : UICollectionViewDelegateFlowLayout {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ChatMessageCell
        
        let message = messages[indexPath.row]
        //  cell.backgroundColor = UIColor.blue
        
        setUpCell(cell: cell, message: message , indexPath : indexPath)
        return cell
    }
    
    
    private func setUpCell(cell : ChatMessageCell , message : Message , indexPath : IndexPath) {
        
        
        // detect which cell to be displayed
        
        if message.fromID == Auth.auth().currentUser?.uid {
            // display the blue cell [sender cell ]
            cell.bubbleView.backgroundColor = ChatMessageCell.blueColor
            cell.textMessage.textColor  = .white
            cell.recieverImage.isHidden = true 
        }else{
            //display the the grey cell [ reciever cell ]
            
            cell.bubbleView.backgroundColor = UIColor(r: 240, g: 240, b: 240)
            cell.textMessage.textColor  = .black
            cell.bubbleViewLeftAnchor.isActive = true
            cell.bubbleViewRightAnchor.isActive = false
            
            
            // load  peer image
            
            guard let imageUrl = user?.profileImageUrl , !imageUrl.isEmpty  else {
                
                return
            }
            
            cell.recieverImage.sd_setImage( with: URL(string: imageUrl), completed: { (image, error, cash, url) in
                DispatchQueue.main.async {
                    cell.recieverImage.image = image
                    //                    tableView.reloadData()
                }
            })
        }
        
        cell.textMessage.text = messages[indexPath.row].text
        
        cell.bubbleWidthAnchore.constant = estimateFrameForText( message.text!).width + 25
        
        /// modify the bubbleView width
    }
    
    // set cell size to full width
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height : CGFloat = 80
        // here i nedd to get the estimated hight ---> the height is variable based on the number of lines in the message
        if let text = messages[indexPath.item].text{
            height = estimateFrameForText(text).height + 25
        }
        
        return CGSize(width: view.frame.width , height: height)
    }
    
    //** *** * ** tricky
    // get estimated height my custom function
    
    fileprivate func estimateFrameForText(_ text: String) -> CGRect {
        //300 as bubble width in messagecell  // 1000 this is the max heigh we supposed to makein messages
        let size = CGSize(width: 200, height: 1000)
        
        let attributes = [NSAttributedString.Key.font:
            UIFont(name: "Helvetica-Bold", size: 16.0)!,
                          NSAttributedString.Key.foregroundColor: UIColor.white] as [NSAttributedString.Key: Any]
        
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: attributes, context: nil)
        
        
    }
    
    ///  this message is called every time the device rotate
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) { // to make the layout validate and fit when rotate the screen
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    
}


extension ChatLogVC : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendMessagesButton()
        return true
    }
    
    
}

