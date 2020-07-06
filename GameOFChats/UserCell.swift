//
//  UserCell.swift
//  GameOFChats
//
//  Created by kasper on 7/6/20.
//  Copyright © 2020 Mahmoud.Abdul-Wahab.GameOfChats. All rights reserved.
//

import UIKit
import Firebase

class UserCell : UITableViewCell {
    
    
    var message : Message? {
        didSet{
            setUpCell(with : message!)
        }
    }
    
    
    func setUpCell(with message : Message) {
        
        
        if let toID = message.toID {
                 
                 Database.database().reference().child("users").child(toID).observeSingleEvent(of: .value, with: { (snapshot) in
                      
                     if let dictionary = snapshot.value as? [String : Any]
                     {
                        self.textLabel?.text = dictionary["name"] as? String
                         
                         if  let imageUrl = dictionary["profileImageUrl"] as? String
                                    {
                                        self.profileImage.sd_setImage( with: URL(string: imageUrl), completed: { (image, error, cash, url) in
                                            DispatchQueue.main.async {
                                                self.profileImage.image = image
                            //                    tableView.reloadData()
                                            }
                                        })
                                    }
                         
                         
                     }
                     
                 }, withCancel: nil)
                 
             }
        
            
             detailTextLabel?.text = message.text
        
        if let seconds = message.timeStamp
       {
        let timeData = Date(timeIntervalSince1970: TimeInterval(seconds))
     //   timelable.text = "\(timeData.description)"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm:ss"
        
        timelable.text = dateFormatter.string(from: timeData)
        }
            
       
             
        
        
    }
    
    ////  i want to get rid of the  default image view and  crete my custome one
    
    lazy var profileImage  : UIImageView = {
        
        let imageView                 = UIImageView()
        imageView.image               = UIImage(named: "gameofthrones")
        imageView.layer.cornerRadius  = 25
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    ///****** ** ** * * * ** * *adding custom lable for timestamp
    
    
    let timelable : UILabel = {
        let lable = UILabel()
        lable.text = "HH:MM:SS"
        lable.textColor  = UIColor.darkGray
        lable.font       = UIFont.systemFont(ofSize: 13)
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    
    
    
    // the custom
    // after adding the custome image view  u will notice that the image is shown over the text lables
    // so u need to overrid the default texts constraints
    override func layoutSubviews() {
        super .layoutSubviews()
        
        textLabel?.frame = CGRect(x: 65, y: textLabel!.frame.origin.y - 2, width: textLabel!.frame.width, height: textLabel!.frame.height)
        
        detailTextLabel?.frame = CGRect(x: 65, y: detailTextLabel!.frame.origin.y + 2, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
        detailTextLabel!.font = UIFont.systemFont(ofSize: 14, weight: .light)
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        addSubview(profileImage)
            addSubview(timelable)
        
        NSLayoutConstraint.activate([
            profileImage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8),
            profileImage.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            profileImage.widthAnchor.constraint(equalToConstant: 50),
            profileImage.heightAnchor.constraint(equalToConstant:50),
            
            
            // timelaple constaints
            
            timelable.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            timelable.topAnchor.constraint(equalTo: self.topAnchor, constant: 25),
            timelable.widthAnchor.constraint(equalToConstant: 100),
            timelable.heightAnchor.constraint(equalTo: textLabel!.heightAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}


extension NewMessageVC {
    
    
}

