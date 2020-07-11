//
//  ViewController.swift
//  GameOFChats
//
//  Created by kasper on 7/3/20.
//  Copyright © 2020 Mahmoud.Abdul-Wahab.GameOfChats. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class MessagesVC: UITableViewController {
    
    var messages = [Message]()
    
    
    /// ** ** * * * ** * *   to maeke a scections
    var messageDictionary  = [String : Message]()
    
    
    override func viewWillAppear(_ animated: Bool) {
        checkIfUserIsLoggedIn()
        observeUserMessages()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        view.backgroundColor = .green
        
        navigationItem.leftBarButtonItem  = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handelLogout))
        
        let image = UIImage(named: "new-message")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image:image , style: .plain, target: self, action: #selector(handelNewMessage))
        
        
        // registering the cell
        
        
        tableView.register(UserCell.self, forCellReuseIdentifier: "cell")
        //  messageObserver()
        
        
    }
    
    
    
//    func observeUserMessages() {
//           guard let uid = Auth.auth().currentUser?.uid else {
//               return
//           }
//
//           let ref = Database.database().reference().child("user-messages").child(uid)
//           ref.observe(.childAdded, with: { (snapshot) in
//
//               let userId = snapshot.key
//
//               print(uid, userId)
//               Database.database().reference().child("user-messages").child(uid).child(userId).observe(.childAdded, with: { (snapshot) in
//
//                   let messageId = snapshot.key
//                   self.fetchMessageWithMessageId(messageId)
//
//                   }, withCancel: nil)
//
//               }, withCancel: nil)
//       }
       
       fileprivate func fetchMessageWithMessageId(_ messageId: String) {
        
        

                    /// '  here i want to get the user chat with the specifice peerd user only
                    let messageRef = Database.database().reference().child("messages").child(messageId)
                    
                    messageRef.observeSingleEvent(of: .value, with: { (snap) in
                        
                       // print(snap)
                        
                        guard let dic = snap.value as? [String : Any] , !dic.isEmpty   else
                        {
                            return
                            
                        }
                        
                        
        //                guard   let text = dic["text"] as? String , !text.isEmpty , let formId  = dic["fromID"] as? String , !formId.isEmpty , let toID  = dic["toID"] as? String , !toID.isEmpty   , let times  = dic["timeStamp"] as? NSNumber   else
        //                {
        //                    return
        //                }
                        
                        let message = Message(dictionary: dic)
        //                message.text = text
        //                message.toID = toID
        //                message.timeStamp =  times
        //                message.fromID = formId
                        
                        if let partnerId = message.chatPartner(){ //here the message between me and any other person i want to group them together with the current user id only to remove duplicated cell in this table  if u removed this ans set it toId or fromId only this will cause bug cause it depends on the cureent user and we can't detect the current user id from the to way message except when we compare ther in this func   message.chatPartner()
                            ///  this is very important to  remove all message duplication  to the same user  and show the last message only so i put the messages in a dictionary with the [ same ] key  then put  it as array in messages array  which hold all users then the cureent user chated with them before
                            
                            #warning("Bug here")              ////  **************** Bug here *****************
                            self.messageDictionary[partnerId] = message
                            
                        }
                        self.attemptReloadOfTable()
                        
                    }, withCancel: nil)
                    
        
//           let messagesReference = Database.database().reference().child("messages").child(messageId)
//
//           messagesReference.observeSingleEvent(of: .value, with: { (snapshot) in
//
//               if let dictionary = snapshot.value as? [String: AnyObject] {
//                   let message = Message(dictionary: dictionary)
//
//                   if let chatPartnerId = message.chatPartnerId() {
//                       self.messagesDictionary[chatPartnerId] = message
//                   }
//
//                   self.attemptReloadOfTable()
//               }
//
//               }, withCancel: nil)
       }
       
       fileprivate func attemptReloadOfTable() {
        
            
                                       ///  i want to reduce the cost of reloding table view  in every message this  high load on the app think of the number of message so i will reload it after 0.1 sec i used this way  cause i don't know the number of message so when i finish  store them in the array and reload the collection view
                                       
                                       
                                       ///**** this timer invalidated in every time  a new message comes and invalidate until there is no message come  again so this timer will be excuted only one time
                                       //we just canceled our timer if there is still new messages comes if it doesn't break the time
                                       self.timer?.invalidate()
                                                          print("we just canceled our timer ")
                                       // لو الرساله مجنش قبل ال 0.5 ثانيه هيعمل ريست للتيمر لحد م اخر رساله تيجى والوقت 0.5  يخلص ومفيش حاجه تيجى ويعمل ريلود بقى
                                                          
                                                          self.timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
                                                          print("schedule a table reload in 0.1 sec")
               }
       
       var timer: Timer?
       
       @objc func handleReloadTable() {
        
         self.messages = Array( self.messageDictionary.values)
                                
                                    //// now i want to srot the message by timestamp
                                    self.messages.sort(by: { (message1, message2) -> Bool in
                                         return message1.timeStamp as! Int > message2.timeStamp as! Int
                                    })
                                    
                                   
                                
                                
                                
                                // self.messages.append(message)
        
          //this will crash because of background thread, so lets call this on dispatch_async main thread
              DispatchQueue.main.async(execute: {
                  self.tableView.reloadData()
              })
       }
    
    
    
    
    
    
    
    
    
    //******************************
    func  observeUserMessages(){
       // messages.removeAll()
       
        guard let uID = Auth.auth().currentUser?.uid else{return}
     

        let dbRef = Database.database().reference().child("user-messages").child(uID)
        dbRef.observe(.childAdded, with: { (snapshot) in
            //// here i will get all user messages (ids)  from user-message table then i will take this ids and get the messages from message table for this user
            
            //  print(snapshot.key)
            //i will get the user id  which the current user chating with him
             /// after this `i get all messags  relted with this user iwth all users `
            let userId = snapshot.key
            
             Database.database().reference().child("user-messages").child(uID).child(userId).observe(.childAdded, with: { (snapshot) in
             
             let messageId = snapshot.key
             self.fetchMessageWithMessageId(messageId)
             
             }, withCancel: nil)
            
        }, withCancel: nil)
    }
    
   
     
 
    
    //    func  messageObserver() {
    //        let dbRef = Database.database().reference().child("messages")
    //        dbRef.observe(.childAdded, with: { (snapshot) in
    //
    //             guard let dic = snapshot.value as? [String : Any] , !dic.isEmpty   else
    //            {
    //                return
    //
    //            }
    //
    //
    //            guard   let text = dic["text"] as? String , !text.isEmpty , let formId  = dic["fromID"] as? String , !formId.isEmpty , let toID  = dic["toID"] as? String , !toID.isEmpty   , let times  = dic["timeStamp"] as? NSNumber   else
    //            {
    //                return
    //            }
    //
    //            let message = Message()
    //            message.text = text
    //            message.toID = toID
    //            message.timeStamp =  Int64.init(truncating : times)
    //            message.fromID = formId
    //
    //            if let toID = message.toID{
    //                ///  this is very impoetant to  remove all message duplication and show the last message only
    //                self.messageDictionary[toID] = message
    //
    //                self.messages = Array( self.messageDictionary.values)
    //
    //
    //
    //                //// now i want to srot the message by timestamp
    //                 self.messages.sorted {
    //
    //                    let mtime1 = $0.timeStamp as! Int64
    //
    //                    let mtime2 = $1.timeStamp as! Int64
    //
    //                    return mtime1 > mtime2
    //                }
    //
    //
    //
    //                //let sortedArray = images.sorted {
    ////                    $0.fileID < $1.fileID
    ////                }
    //            }
    //
    //
    //
    //
    //           // self.messages.append(message)
    //            DispatchQueue.main.async {self.tableView.reloadData()}
    //
    //        }, withCancel: nil) // if xcdoe faaild to excute this closure with cancel will fix that
    //    }
    //
    
    @objc func handelNewMessage()  {
        let newMessageVC = NewMessageVC()
        newMessageVC.messageVCRef = self
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
                
                guard let dictionary = snapshot.value as? [String: AnyObject]  , let name =   dictionary["name"] as? String , !name.isEmpty , let email = dictionary["email"] as? String , !email.isEmpty , let profPic = dictionary["profileImageUrl"] as? String , !profPic.isEmpty else {return}
                
                
                var user = User()
                user.name            = name
                user.email           = email
                user.profileImageUrl = profPic
                
                self.setUPNavBarWithUser(user: user)
                
            }, withCancel: nil)
        }
    }
    
    
    
    func setUPNavBarWithUser(user : User){
        
        /// i must clear the arrey and dictinary if i logout then loged in  with another user so viewdid load will not called then the func observeUserMessages() will never also called   and the two arrays has onld values so i need to clear them
        messages.removeAll()
        messageDictionary.removeAll()
        tableView.reloadData()
        
        //self.navigationItem.title = user.name
        
        let containerView = UIView()
        //containerView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.frame = CGRect(x: 0, y: 0, width: 150, height: 40)
        
        // containerView.backgroundColor = .green
        //// *******************  Here we added my custom view in the navigationiewItem
        self.navigationItem.titleView = containerView
        
        let title = UIView()
        title.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(title)
        /// revise content mode and content hunging and Compression Resistance https://medium.com/@abhimuralidharan/ios-content-hugging-and-content-compression-resistance-priorities-476fb5828ef
        
        //********** on click on the titleContainer *******
        //        containerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showChatLogVC)))
        
        
        
        
        //// image view
        let headerImage : UIImageView = {
            let imageView = UIImageView()
            
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleToFill
            imageView.layer.cornerRadius = 20
            imageView.clipsToBounds = true
            if  let  url = URL(string: user.profileImageUrl!)  {
                imageView.sd_setImage(with: url, completed: nil)
            }
            
            return imageView
        }()
        
        title.addSubview(headerImage)
        // title lable
        
        let titleName : UILabel = {
            let lable = UILabel()
            lable.translatesAutoresizingMaskIntoConstraints = false
            lable.text = user.name
            return lable
        }()
        
        title.addSubview(titleName)
        
        NSLayoutConstraint.activate([
            title.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            title.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            // imageView
            
            headerImage.centerYAnchor.constraint(equalTo: title.centerYAnchor),
            headerImage.leadingAnchor.constraint(equalTo: title.leadingAnchor, constant: 2),
            headerImage.widthAnchor.constraint(equalToConstant: 40),
            headerImage.heightAnchor.constraint(equalToConstant: 40),
            
            // titlelable
            
            titleName.centerYAnchor.constraint(equalTo: title.centerYAnchor),
            titleName.trailingAnchor.constraint(equalTo: title.trailingAnchor, constant: -2),
            titleName.leadingAnchor.constraint(equalTo: headerImage.trailingAnchor, constant: 5)
        ])
        
        
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
    
    
    func showChatLogVC( user : User ){
        let chatLogVC = ChatLogVC(collectionViewLayout : UICollectionViewFlowLayout())
        // if you are navigating to the UICollectionViewController screen you must initialse the collectionview with non-nil layout params like this collectionViewLayout : UICollectionViewFlowLayout()
        chatLogVC.user = user
        navigationController?.pushViewController(chatLogVC, animated: true)
    }
    
    
    
    
}


extension MessagesVC {
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UserCell
        
        if  messages.count > 0
        {
              cell.message =  messages[indexPath.row]
        }
        
     //**   cell.message =  messages[indexPath.row]
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messages.count
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let messsge = messages[indexPath.row]
        
        guard let chatPartenerId =  messsge.chatPartner() else {return}
        
        Firebase.Database.database().reference().child("users").child(chatPartenerId).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let userData = snapshot.value as? [String : Any]
            {
                if  let name = userData["name"] as? String , let email = userData["email"] as? String , let photoURl = userData["profileImageUrl"] as? String
                {
                    self.showChatLogVC(user: User(id:chatPartenerId , name: name, email: email, profileImageUrl: photoURl) )
                }
            }
            
        }, withCancel: nil)
        
        
        
    }
    
}
