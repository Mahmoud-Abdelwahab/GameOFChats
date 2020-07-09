//
//  ChatMessageCell.swift
//  GameOFChats
//
//  Created by kasper on 7/8/20.
//  Copyright © 2020 Mahmoud.Abdul-Wahab.GameOfChats. All rights reserved.
//

import UIKit

class ChatMessageCell : UICollectionViewCell{
    
   static let  blueColor = UIColor(r: 0, g: 137, b: 249)
      var bubbleViewRightAnchor : NSLayoutConstraint!
    var bubbleViewLeftAnchor : NSLayoutConstraint!

     var bubbleWidthAnchore : NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame : frame)
        configureTextView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    let bubbleView : UIView = {
        let view = UIView()
        view.backgroundColor = blueColor
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    lazy var textMessage : UITextView = {
        let tv = UITextView()
        tv.text = "  DUMMY TEXT FOR NOW ...."
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.font  = UIFont.systemFont(ofSize: 16)
        tv.textColor = .white
        
        tv.backgroundColor  = .clear        /// text has adefault background color white so u need to get rid of it
        
        return tv
    }()
    
    lazy var recieverImage  : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "gameofthrones")
       imageView.layer.cornerRadius  = 25
       imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
  
    
    func  configureTextView() {
        addSubview(bubbleView)
        addSubview(textMessage)
        addSubview(recieverImage)
       bubbleWidthAnchore  = bubbleView.widthAnchor.constraint(equalToConstant: 300)
            bubbleWidthAnchore.isActive = true
        
        
        
       /// to make  show the reviever cell on the left side  *************
        bubbleViewRightAnchor =  bubbleView.trailingAnchor.constraint(equalTo: self.trailingAnchor ,constant: -8)
        
        bubbleViewRightAnchor.isActive = true  /// i will  active the right cell only and in the message contrioler item for row i will active or dectivate the two cells
        
        bubbleViewLeftAnchor = bubbleView.leadingAnchor.constraint(equalTo: self.leadingAnchor ,constant: 8)
        // here i left bubbleViewLeftAnchor with no active staus  to be set in the check 
        
        ////******************/
        
        
        
        bubbleViewRightAnchor.isActive = true
        NSLayoutConstraint.activate([
           
            bubbleView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor),
             bubbleView.trailingAnchor.constraint(equalTo: self.trailingAnchor , constant: -10),
            
            
            
            textMessage.leadingAnchor.constraint(equalTo: recieverImage.leadingAnchor , constant: 8),
            textMessage.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            textMessage.heightAnchor.constraint(equalTo: self.heightAnchor, constant:  -10),
            textMessage.widthAnchor.constraint(equalToConstant: 300),
           textMessage.trailingAnchor.constraint(equalTo: self.trailingAnchor , constant: -10),
           
           
           recieverImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
           recieverImage.bottomAnchor.constraint(equalTo: self.bottomAnchor),
           recieverImage.widthAnchor.constraint(equalToConstant: 32),
            recieverImage.heightAnchor.constraint(equalToConstant: 32),
        ])
        
    }
}
