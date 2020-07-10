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
        tv.isUserInteractionEnabled = false
        tv.backgroundColor  = .clear        /// text has adefault background color white so u need to get rid of it
        
        return tv
    }()
    
    lazy var recieverImage  : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "gameofthrones")
       imageView.layer.cornerRadius  = 16
       imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
  
    
    func  configureTextView() {
        addSubview(bubbleView)
        addSubview(textMessage)
        addSubview(recieverImage)
    
         //x,y,w,h
                recieverImage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
                recieverImage.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
                recieverImage.widthAnchor.constraint(equalToConstant: 32).isActive = true
                recieverImage.heightAnchor.constraint(equalToConstant: 32).isActive = true
                
                //x,y,w,h
                /// to make  show the reviever cell on the left side  *************
                    bubbleViewRightAnchor = bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8)
                    
                bubbleViewRightAnchor?.isActive = true /// i will  active the right cell only and in the message contrioler item for row i will active or dectivate the two cells
                
                
                bubbleViewLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: recieverImage.rightAnchor, constant: 8)   // here i left bubbleViewLeftAnchor with no active staus  to be set in the check
                     
                     ////******************/
        //        bubbleViewLeftAnchor?.active = false
                
                
                bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
                
                bubbleWidthAnchore = bubbleView.widthAnchor.constraint(equalToConstant: 200)
                bubbleWidthAnchore?.isActive = true
                
                bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
                
                //ios 9 constraints
                //x,y,w,h
        //        textView.rightAnchor.constraintEqualToAnchor(self.rightAnchor).active = true
                textMessage.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 8).isActive = true
                textMessage.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
                
                textMessage.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
        //        textView.widthAnchor.constraintEqualToConstant(200).active = true
                
                
                textMessage.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
    }
}
