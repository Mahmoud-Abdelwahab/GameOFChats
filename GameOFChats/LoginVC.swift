//
//  LoginVC.swift
//  GameOFChats
//
//  Created by kasper on 7/3/20.
//  Copyright © 2020 Mahmoud.Abdul-Wahab.GameOfChats. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: UIViewController {
    
    
    private lazy var stackView : UIStackView  = {
        let stackView       = UIStackView()
        stackView.axis                       = .vertical
        stackView.distribution               = .fillProportionally
        // stackView.spacing                  = 10
        stackView.addArrangedSubview(userName)
        stackView.addArrangedSubview(line)
        stackView.addArrangedSubview(email)
        stackView.addArrangedSubview(line)
        stackView.addArrangedSubview(password)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var textFeildsContainer : UIView = {
        let container =  UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor        = .white
        container.layer.cornerRadius     = 5
        container.layer.masksToBounds = true
        
        return container
    }()
    
    private lazy var loginRegisterBtn : UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(r: 80, g: 101, b: 161)
        button.setTitle("Register", for: .normal)
        button.layer.cornerRadius     = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        
        button.addTarget(self, action: #selector(handelLoginRegisterBtn), for: .touchUpInside)
        return button
    }()
    
    
    
    
    private lazy var userName : UITextField  = {
        let textname = UITextField()
        textname.translatesAutoresizingMaskIntoConstraints = false
        textname.placeholder = " Name "
        
        textname.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return textname
    }()
    
    
    private lazy var email : UITextField  = {
        let email = UITextField()
        email.translatesAutoresizingMaskIntoConstraints = false
        email.placeholder = " email "
        return email
    }()
    
    
    private lazy var password : UITextField  = {
        let password = UITextField()
        password.translatesAutoresizingMaskIntoConstraints = false
        password.placeholder = " password "
        return password
    }()
    
    private lazy var line : UIView = {
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)  //UIColor (r: 220, g: 220, b: 220)
        //
        NSLayoutConstraint.activate([
            line.heightAnchor.constraint(equalToConstant: 1)
        ])
        return line
    }()
    
    
    private lazy var emailLine : UIView = {
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)  //UIColor (r: 220, g: 220, b: 220)
        //
        NSLayoutConstraint.activate([
            line.heightAnchor.constraint(equalToConstant: 1)
        ])
        return line
    }()
    
    
    private lazy var profilePicture : UIImageView = {
        let imageView = UIImageView()
        imageView.image =  UIImage(named: "gameofthrones")
        imageView.layer.cornerRadius  = imageView.frame.width/2
        //        imageView.layer.maskedCorners = .layerMaxXMaxYCorner
        // imageView.layer.cornerRadius  = imageView.width/2
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    //**** segmented controler button
    
    private lazy var loginRegisterSegmentedControler : UISegmentedControl = {
        let segmentedBtn = UISegmentedControl(items: ["Login" , "Register"])
        segmentedBtn.translatesAutoresizingMaskIntoConstraints = false
        segmentedBtn.tintColor = UIColor.white
        segmentedBtn.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        segmentedBtn.selectedSegmentIndex = 1
        segmentedBtn.addTarget(self, action: #selector(handelRegisterChange), for: .valueChanged)
        return segmentedBtn
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(r: 61, g: 91, b: 151)
        
        
        //add subviews
        view.addSubview(textFeildsContainer)
        view.addSubview(loginRegisterBtn)
        view.addSubview(profilePicture)
        view.addSubview(loginRegisterSegmentedControler)
        
        setUpTextFieldsContainer()
        setUploginRegisterBtn()
        setUpProfilePicture()
        setUploginRegisterSegmentedControler()
        
    }
    
    
    func setUpProfilePicture(){
        
        NSLayoutConstraint.activate([
            profilePicture.centerXAnchor.constraint(equalTo:view.centerXAnchor),
            profilePicture.bottomAnchor.constraint(equalTo: loginRegisterSegmentedControler.topAnchor, constant: -12),
            profilePicture.widthAnchor.constraint(equalToConstant: 150),
            profilePicture.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    
    // this builf in func change status bar color
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    
    var inputsContainerViewHeightAnchor: NSLayoutConstraint?
    var nameTextFieldHeightAnchor: NSLayoutConstraint?
    var emailTextFieldHeightAnchor: NSLayoutConstraint?
    var passwordTextFieldHeightAnchor: NSLayoutConstraint?
    
    func setUpTextFieldsContainer() {
        //need x, y, width, height constraints
        textFeildsContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        textFeildsContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        textFeildsContainer.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputsContainerViewHeightAnchor = textFeildsContainer.heightAnchor.constraint(equalToConstant: 150)
        inputsContainerViewHeightAnchor?.isActive = true
        
        textFeildsContainer.addSubview(userName)
        textFeildsContainer.addSubview(line)
        textFeildsContainer.addSubview(email)
        textFeildsContainer.addSubview(emailLine)
        textFeildsContainer.addSubview(password)
        
        //need x, y, width, height constraints
        userName.leftAnchor.constraint(equalTo: textFeildsContainer.leftAnchor, constant: 12).isActive = true
        userName.topAnchor.constraint(equalTo: textFeildsContainer.topAnchor).isActive = true
        
        userName.widthAnchor.constraint(equalTo: textFeildsContainer.widthAnchor).isActive = true
        nameTextFieldHeightAnchor = userName.heightAnchor.constraint(equalTo: textFeildsContainer.heightAnchor, multiplier: 1/3)
        nameTextFieldHeightAnchor?.isActive = true
        
        //need x, y, width, height constraints
        line.leftAnchor.constraint(equalTo: textFeildsContainer.leftAnchor).isActive = true
        line.topAnchor.constraint(equalTo: userName.bottomAnchor).isActive = true
        line.widthAnchor.constraint(equalTo: textFeildsContainer.widthAnchor).isActive = true
        line.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        //need x, y, width, height constraints
        email.leftAnchor.constraint(equalTo: textFeildsContainer.leftAnchor, constant: 12).isActive = true
        email.topAnchor.constraint(equalTo: userName.bottomAnchor).isActive = true
        
        email.widthAnchor.constraint(equalTo: textFeildsContainer.widthAnchor).isActive = true
        
        emailTextFieldHeightAnchor = email.heightAnchor.constraint(equalTo: textFeildsContainer.heightAnchor, multiplier: 1/3)
        
        emailTextFieldHeightAnchor?.isActive = true
        
        //need x, y, width, height constraints
        emailLine.leftAnchor.constraint(equalTo: textFeildsContainer.leftAnchor).isActive = true
        emailLine.topAnchor.constraint(equalTo: email.bottomAnchor).isActive = true
        emailLine.widthAnchor.constraint(equalTo: textFeildsContainer.widthAnchor).isActive = true
        emailLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        //need x, y, width, height constraints
        password.leftAnchor.constraint(equalTo: textFeildsContainer.leftAnchor, constant: 12).isActive = true
        password.topAnchor.constraint(equalTo: email.bottomAnchor).isActive = true
        
        password.widthAnchor.constraint(equalTo: textFeildsContainer.widthAnchor).isActive = true
        passwordTextFieldHeightAnchor = password.heightAnchor.constraint(equalTo: textFeildsContainer.heightAnchor, multiplier: 1/3)
        passwordTextFieldHeightAnchor?.isActive = true
    }
    
    
    func setUploginRegisterBtn() {
        NSLayoutConstraint.activate([
            loginRegisterBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginRegisterBtn.topAnchor.constraint(equalTo: textFeildsContainer.bottomAnchor, constant: 10),
            loginRegisterBtn.widthAnchor.constraint(equalTo: textFeildsContainer.widthAnchor),
            loginRegisterBtn.heightAnchor.constraint(equalToConstant: 60)
            
        ])
    }
    
    
    
    @objc func handelLoginRegisterBtn() {
        if loginRegisterSegmentedControler.selectedSegmentIndex == 0 {
            handelLogin()
        }else {
            handelRegister()
        }
    }
    
    func handelLogin() {
        guard  let email = email.text , !email.isEmpty, let password = password.text , !password.isEmpty  else {
                  print("Invalid Form ....")
                  return
              }
        
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            
            if let error = error {
                print(error)
                return
            }
            
            //successfully logged in our user
            self.dismiss(animated: true, completion: nil)
            
        })
    }
    
    @objc func handelRegister()  {
        guard let name = userName.text , !name.isEmpty , let email = email.text , !email.isEmpty, let password = password.text , !password.isEmpty  else {
            print("Invalid Form ....")
            return
        }
        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password , completion:  { (result, error) in
            if error != nil {
                print(error!)
                return
            }
            //successfully authenticated user
            print("Successfully authenticated ...")
            // save user data to data base
            
            guard let uID = Auth.auth().currentUser?.uid else{return}
            let dbRef = Firebase.Database.database().reference()
            
            dbRef.child("users").child(uID).updateChildValues(["name":name,"email" : email]) { (error, DbRef) in
                
                if error != nil{
                    print(error?.localizedDescription ?? "")
                }
                
                print("User saved successfully")
                   self.dismiss(animated: true, completion: nil)
            }
        })
    }
    
    func setUploginRegisterSegmentedControler() {
        
        NSLayoutConstraint.activate([
            loginRegisterSegmentedControler.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginRegisterSegmentedControler.bottomAnchor.constraint(equalTo: textFeildsContainer.topAnchor, constant: -12),
            loginRegisterSegmentedControler.widthAnchor.constraint(equalTo: textFeildsContainer.widthAnchor),
            loginRegisterSegmentedControler.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc func handelRegisterChange (){
        let title = loginRegisterSegmentedControler.selectedSegmentIndex == 0 ? "Login" : "Register"
        loginRegisterBtn.setTitle(title, for: .normal)
        
        // change height of containerview, but how???
        inputsContainerViewHeightAnchor?.constant = loginRegisterSegmentedControler.selectedSegmentIndex == 0 ? 100 : 150
        
        // change height of nameTextField
        // the registration form i give all the three ttextfiled height multiplier = 1/3 of the container   but in the login form i givw th username height multiplier = 0 and the other two textfields i gave them 1/2 of the container
        nameTextFieldHeightAnchor?.isActive = false
        nameTextFieldHeightAnchor = userName.heightAnchor.constraint(equalTo: textFeildsContainer.heightAnchor, multiplier: loginRegisterSegmentedControler.selectedSegmentIndex == 0 ? 0 : 1/3)
        nameTextFieldHeightAnchor?.isActive = true
        userName.isHidden = loginRegisterSegmentedControler.selectedSegmentIndex == 0
        
        emailTextFieldHeightAnchor?.isActive = false
        emailTextFieldHeightAnchor = email.heightAnchor.constraint(equalTo: textFeildsContainer.heightAnchor, multiplier: loginRegisterSegmentedControler.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        emailTextFieldHeightAnchor?.isActive = true
        
        passwordTextFieldHeightAnchor?.isActive = false
        passwordTextFieldHeightAnchor = password.heightAnchor.constraint(equalTo: textFeildsContainer.heightAnchor, multiplier: loginRegisterSegmentedControler.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        passwordTextFieldHeightAnchor?.isActive = true
        
    }
}



