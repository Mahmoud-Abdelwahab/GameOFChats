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
// for videos
import MobileCoreServices
import AVFoundation

class ChatLogVC: UICollectionViewController  {
    
    var messages = [Message]()
    var user : User?{
        didSet{   /// when i initialize this variable from the previous vc this set tthe title automatice
            title  = user?.name
            observeMessages()
        }
    }
    
    func observeMessages(){
        
        
        guard let uid = Auth.auth().currentUser?.uid ,let toId = user?.id  else{return}
        Database.database().reference().child("user-messages").child(uid).child(toId).observe(.childAdded, with: {  (snapshot) in
            
            let messageKey = snapshot.key
            
            Database.database().reference().child("messages").child(messageKey).observeSingleEvent(of: .value, with: { (snapshot) in
                
                guard let dictionary = snapshot.value as? [ String: AnyObject] else{return}
                
                //                if   let text = dictionary["text"] as? String , !text.isEmpty , let formId  = dictionary["fromID"] as? String , !formId.isEmpty , let toID  = dictionary["toID"] as? String , !toID.isEmpty   , let times  = dictionary["timeStamp"] as? NSNumber   else
                //                {
                //                    print("image")
                //                    return
                //                }
                
                let message = Message(dictionary: dictionary)
                //  message.setValuesForKeys(dictionary)
                //                message.text = text
                //                message.toID = toID
                //                message.timeStamp = times
                //                message.fromID = formId
                
                
                self.messages.append(message)
                DispatchQueue.main.async(execute: {
                    self.collectionView?.reloadData()
                    // scrol to the last index
                    let indexPath = IndexPath(row: self.messages.count - 1 , section: 0)
                    self.collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
                })
                
                
            }, withCancel: nil)
            
        }, withCancel: nil)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // to make the very top space before the first cell on the top
        collectionView.contentInset = UIEdgeInsets(top:15, left: 0, bottom: 8, right: 0)
        // is how to remove the right side scroll padding
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top:0, left: 0, bottom: 10, right: 0)
        
        // registring th cell
        collectionView.register(ChatMessageCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.alwaysBounceVertical = true // this to make collection view dragable
        //        title = "Chat Log Controller"
        collectionView.backgroundColor = .white
        //  setUpInputComponents()
        
        
        // this is the first way to handel keyboard drage up and down
        // the edite which i made here is when the keyboard draged up i will scroll the collection view  to the recent message
        
          setUpKeyBoardObserver()
        ///***************** if uou want the keyboard to scroll up & down with the  collection view &table view scrollling ************
        collectionView.keyboardDismissMode = .interactive
        
        
        ///********  the seconde way apple way to handel keyboard drage up & down *********
        
        
        
    }
    
    
    lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter message..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        ///********** ** * **  ***  ** * *
        /// to enable Enter key from the keyboard you
        inputTextReferance = textField
        return textField
    }()
    
    
    lazy var inputContainerView: UIView = {
        let containerView = UIView()
        containerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
        containerView.backgroundColor = UIColor.white
        
        //upload image
        
        let uploadImageView = UIImageView()
        uploadImageView.image = UIImage(named:"uploadImage")
        uploadImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handelUploadImageTap)))
        uploadImageView.isUserInteractionEnabled = true
        uploadImageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(uploadImageView)
        
        
        
        
        
        
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: UIControl.State())
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(sendMessagesButton), for: .touchUpInside)
        containerView.addSubview(sendButton)
        //x,y,w,h
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        containerView.addSubview(self.inputTextField)
        //x,y,w,h
        self.inputTextField.leadingAnchor.constraint(equalTo: uploadImageView.trailingAnchor, constant: 8).isActive = true
        self.inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        self.inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        self.inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        let separatorLineView = UIView()
        separatorLineView.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        separatorLineView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(separatorLineView)
        //x,y,w,h
        separatorLineView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        separatorLineView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        separatorLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        separatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        
        
        ///
        uploadImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        uploadImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        uploadImageView.widthAnchor.constraint(equalToConstant: 44).isActive = true // apple recommend
        uploadImageView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        return containerView
    }()
    
    
    
    
    
    
    ///
    
    override var inputAccessoryView: UIView? {
        get {    ///انت هنا بتعمل كونانر وتحط فيه كل الفيوز الالمنتس بتاعتك واما بس لازم تعرف الريفرنس بتاعه  برا  مش جوا البروبراترى دى عشان مش هيشوفها  تعمل ريتارن بس هنا
            return inputContainerView
        }
    }
    
    override var canBecomeFirstResponder : Bool {
        return true
    }
    
    
    
    
    /// old way unused
    ///  *********************
    
    func setUpKeyBoardObserver() {
        // when key board appeare it firs a notification so i will liesten for this notification then add action  when it fire
        
//        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
//
//        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        
    }
    
    @objc private func handleKeyboardDidShow(){
        let indexPath = IndexPath(row: messages.count - 1 , section: 0)
        collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
    }
    /// old way unused
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // this is very important to remove notification  observer
        //** if you didn't remove it it will casue memory leak
        NotificationCenter.default.removeObserver(self)
    }
    
    /// old way unused
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
    
    /// old way unused
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
    
    /// old way unuse
    /*
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
     input.delegate = self               ///
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
     
     
     // Line separator
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
     
     ///
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
     
     }*/
    
    var inputTextReferance : UITextField?
    
    @objc func sendMessagesButton(){
        
        
        guard let text = inputTextReferance?.text , !text.isEmpty else {
            print(" the text filed is empty ")
            return
        }
        
        let properties: [String : Any] = [ "text" : text ]
        
        sendImageWithPropertise(properties : properties)
    }
    
    
    
    /// handel zoon in logic from delegate
       
       var startingOriginalFram : CGRect?
    
       var blackBackgroundView : UIView?
     
    var startingOriginalImageView : UIImageView?
       func performZoonInForImage(originalImageView : UIImageView?){
        self.startingOriginalImageView = originalImageView
        // no need to sill show this image while zoomingIN  i will return it visable back when i zoomOut
        self.startingOriginalImageView?.isHidden = true
            print("performing zoon in  logic for image ....")
           // get the origianl image fram
          startingOriginalFram = originalImageView?.superview?.convert(originalImageView!.frame, to: nil)
           print(startingOriginalFram)
           let zoomingImageView = UIImageView(frame: startingOriginalFram!)
           zoomingImageView.backgroundColor = .cyan
           zoomingImageView.isUserInteractionEnabled = true
           zoomingImageView.image = originalImageView?.image
           //this gesture to handle zoom out
           zoomingImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomOut)))
           // adding this new fram cover with the same image fram in the Screen itself
           if let keyWindow = UIApplication.shared.keyWindow {
               // i will create a black container which will be on th e back of the zooming image
                blackBackgroundView = UIView(frame: keyWindow.frame) // initialized it with the full screen
            blackBackgroundView?.backgroundColor = .black
               // start from alph = 0 to 1
               blackBackgroundView?.alpha = 0
               // i will add it to the window screen before the zoomingImageView
            keyWindow.addSubview(blackBackgroundView!)
               
               //////////////
               keyWindow.addSubview(zoomingImageView)
               
               /// now i want to zoon in the image with animation
               UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                self.blackBackgroundView?.alpha = 1
                   //hidding the inputcontaner
                   self.inputContainerView.isHidden = true
                   
                   /// this zoomingImageView is th eimage container like bubble i know the image width and height and i know the container width how to get the height  ?
                   // h2 = h1/w1 * w2
                let height = self.startingOriginalFram!.height / self.startingOriginalFram!.width * keyWindow.frame.width

                   zoomingImageView.frame = CGRect(x:0, y: 0, width: keyWindow.frame.width, height: height)
                   
                   //to center imageview in the screen
                   zoomingImageView.center = keyWindow.center
               }, completion: nil)
               // nothing to do here
           }
          
       }
       
       
       // handling ZoomOut
       @objc func handleZoomOut(tapGesture : UITapGestureRecognizer){
           
        // i want to retrun the view back to the originalimagefram size
        if let zoomOutImageView = tapGesture.view {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                zoomOutImageView.layer.cornerRadius = 16
                zoomOutImageView.clipsToBounds = true
                // return the image container to it's origin state
                zoomOutImageView.frame = self.startingOriginalFram!
                //  hidding the alph = 0 of the big black container
                self.blackBackgroundView?.alpha = 0
                //return the input view to be visable
                self.inputContainerView.isHidden = false

            }, completion: { (completed) in
                zoomOutImageView.removeFromSuperview()
                self.blackBackgroundView?.removeFromSuperview()
                self.startingOriginalImageView?.isHidden = true

                       })
            
        }
       }
    
}


extension ChatLogVC : UICollectionViewDelegateFlowLayout {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ChatMessageCell
        
        cell.chatLogVC = self
        
        let message = messages[indexPath.row]
        //  cell.backgroundColor = UIColor.blue
        
        setUpCell(cell: cell, message: message , indexPath : indexPath)
        if let text = message.text {
            cell.textMessage.text = text
        }
        
        if  let text = message.text {
            cell.bubbleWidthAnchore.constant = estimateFrameForText(text).width + 25
        }else{
            // come here if it's an image
            /// انا هنا بحط عرض البابل  دائما ب ٢٠٠ لما اجى اتعامل مع الصور الصوره ممكن تكون كبيره جدااا اكبر من حجم الشاشه ف انا لازم اعمل نسبه تصغير للصوره عشان اعرضها كلها ف الموبيل aspect ratio   انا  عارف طبعا  طول وعرض الصوره وعارف طبعا عرض البابل ال بيشيل الصوره كدا ناقص نسبة ارتفاع البابل احسبها من المعادله
            
            cell.bubbleWidthAnchore.constant = 200
        }
        
        
        return cell
    }
    
    
    private func setUpCell(cell : ChatMessageCell , message : Message , indexPath : IndexPath) {
        
        guard let imageUrl = user?.profileImageUrl , !imageUrl.isEmpty  else {
            
            return
        }
        
        cell.recieverImage.sd_setImage( with: URL(string: imageUrl), completed: { (image, error, cash, url) in
            DispatchQueue.main.async {
                cell.recieverImage.image = image
                
            }
        })
        
        
        
        // detect which cell to be displayed
        if message.fromID == Auth.auth().currentUser?.uid {
            // display the blue cell [sender cell ]
            
            cell.bubbleView.backgroundColor = ChatMessageCell.blueColor
            cell.textMessage.textColor  = .white
            cell.recieverImage.isHidden = true
            cell.bubbleViewRightAnchor.isActive = true
            cell.bubbleViewLeftAnchor.isActive = false
            //  cell.showImageBubble.isHidden  = true
        }else{
            //display the the grey cell [ reciever cell ]
            cell.bubbleView.backgroundColor = UIColor(r: 240, g: 240, b: 240)
            cell.textMessage.textColor  = .black
            cell.bubbleViewLeftAnchor.isActive = true
            cell.bubbleViewRightAnchor.isActive = false
            cell.recieverImage.isHidden = false
            //  cell.showImageBubble.isHidden  = false
            // load  peer image
            
        }
        
        displayImageInBubble(cell : cell , message :  message)
        
        
        
        /// modify the bubbleView width
    }
    
    func displayImageInBubble(cell : ChatMessageCell , message :  Message){
        // if the image url is not nill then this message is image message
        if let imageUrl = message.imageUrl
        {
            // image message type  /// you can and type in the message and  check on it it's better
            cell.showImageBubble.sd_setImage( with: URL(string: imageUrl), completed: { (image, error, cash, url) in
                DispatchQueue.main.async {
                    cell.showImageBubble.image = image
                    
                }
            })
            cell.showImageBubble.isHidden = false
            cell.bubbleView.backgroundColor = .clear
            
        }else {
            cell.showImageBubble.isHidden = true
            //  cell.bubbleView.isHidden      = false
            
        }
    }
    
    ///*******************************
    // set cell size to full width
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height : CGFloat = 100
        
        
        // here i nedd to get the estimated hight ---> the height is variable based on the number of lines in the message
        let message =  messages[indexPath.item]
        if let text = message.text{
            height = estimateFrameForText(text).height + 25
        }else if  let imageWidth = message.imageWidth?.floatValue , let imageHeight = message.imageHeight?.floatValue {
            // create height & width for every image
            // here i make the bubble --->[ image container] constant = 200 now i need to get the height for the bubble which will containe the image  but How???
            
            /// انا هنا بحط عرض البابل  دائما ب ٢٠٠ لما اجى اتعامل مع الصور الصوره ممكن تكون كبيره جدااا اكبر من حجم الشاشه ف انا لازم اعمل نسبه تصغير للصوره عشان اعرضها كلها ف الموبيل aspect ratio   انا  عارف طبعا  طول وعرض الصوره وعارف طبعا عرض البابل ال بيشيل الصوره كدا ناقص نسبة ارتفاع البابل احسبها من المعادله
            
            /// ** i know the bubble width  it;s constant = 200 and i know the image height and width i stored them in the database so to get the bubble height this is the equation h1 / w1 = h2 / w2
            // so h1 = (h2/w2) * w1
            
            height =  CGFloat(imageHeight / imageWidth * 200)
            
        }
        /// this  because when u rotate the screen u need to make the width wiith the  main screen width
        /// the constant width = 200 for the bubble  but her i must return cell width = full screen
        var width : CGFloat = UIScreen.main.bounds.width
        return CGSize(width: width , height: height)
    }
    
    //** *** * ** tricky
    // get estimated height my custom function
    
    fileprivate func estimateFrameForText(_ text: String) -> CGRect {
        //200 as bubble width in messagecell  // 1000 this is the max heigh we supposed to makein messages
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


extension ChatLogVC : UITextFieldDelegate  , UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendMessagesButton()
        return true
    }
    
    
    
    @objc func handelUploadImageTap(){
        // get image picker
        
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        /// to show videos also  with images
      //  imagePickerController.mediaTypes = [KUTTypeImage]
        present(imagePickerController, animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // selecting image form the picker
        var selectedImageFromPicker: UIImage?
        
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else{return}
        
        uploatImageToFirebaseStorage(selectedImage)
        
        picker.dismiss(animated: true, completion: nil)
        
        
    }
    
    
    private func  uploatImageToFirebaseStorage(_ image : UIImage){
        print("selected")
        let imageName = UUID().uuidString ///generate reandom string numbber  for image name
        
        // compressing image to jpeg data
        guard let uploadData = image.jpegData(compressionQuality: 0.2) else {return}
        
        let ref = Storage.storage().reference().child("message_images").child( "\(imageName).jpeg")
        // i will store image first in firsbase then i will download it's url  to send it again in the realtime database
        ref.putData(uploadData, metadata: nil, completion: { (metadata, error) in
            
            if error != nil {
                print("Failed to upload image:", error!)
                return
            }
            
            ref.downloadURL(completion: { (url, err) in
                if let err = err {
                    print(err)
                    return
                }
                print(url?.absoluteString)
                guard let imageURl = url?.absoluteString else {return}
                self.sendMessageWithImageUrl(with: imageURl , image : image)
            })
            
        })
        
    }
    
    
    
    
    private func sendMessageWithImageUrl( with Url : String , image : UIImage){
        
        
        let properties: [String : Any] = [ "imageUrl" : Url , "imageHeight" :image.size.height , "imageWidth" : image.size.width]
        
        sendImageWithPropertise(properties : properties)
    }
    
    /// this is a genaric fucntion  for sending the image and text message  according to the properties which i send to it and append this properties to the values dictionary
    private func sendImageWithPropertise(properties : [String : Any]){
        
        let ref = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        let toID = user!.id!
        let fromID = Auth.auth().currentUser!.uid
        let timestamp = Int(Date().timeIntervalSince1970)
        
        var values : [String : Any] = ["toID": toID, "fromID": fromID, "timeStamp": timestamp ]
        // i will append the properties to the values dictionary
        // $0 is the key , $1 is the value
        properties.forEach ({values[$0] = $1})
        
        childRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error!)
                return
            }
            
            self.inputTextField.text = nil
            
            guard let messageId = childRef.key else { return }
            
            let userMessagesRef = Database.database().reference().child("user-messages").child(fromID).child(toID).child(messageId)
            userMessagesRef.setValue(1)
            
            let recipientUserMessagesRef = Database.database().reference().child("user-messages").child(toID).child(fromID).child(messageId)
            recipientUserMessagesRef.setValue(1)
        }
    }
}

