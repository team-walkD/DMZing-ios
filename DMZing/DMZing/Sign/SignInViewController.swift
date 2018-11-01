//
//  SignInViewController.swift
//  DMZing
//
//  Created by 장한솔 on 2018. 11. 1..
//  Copyright © 2018년 장용범. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nicknameTextField: UITextField!
    
    @IBOutlet weak var signinButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signinButton.makeRounded(cornerRadius: signinButton.frame.height/2)

    }

    @IBAction func signinAction(_ sender: Any) {
        print("signin")
    }
    
    @IBAction func signupAction(_ sender: Any) {
        print("signup")
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
