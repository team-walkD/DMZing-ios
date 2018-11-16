//
//  SignInViewController.swift
//  DMZing
//
//  Created by 장한솔 on 2018. 11. 1..
//  Copyright © 2018년 장용범. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {
    

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var pwTextField: UITextField!
    
    @IBOutlet weak var signinButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signinButton.makeRounded(cornerRadius: signinButton.frame.height/2)

    }

    @IBAction func signinAction(_ sender: Any) {
        if(emailTextField.text != "" && pwTextField.text != ""){
            guard let email = emailTextField.text else {return}
            guard let password = pwTextField.text else {return}
        }else{
            self.simpleAlert(title: "로그인 오류", message: "모두 입력해주세요")
        }
    }
    
    @IBAction func signupAction(_ sender: Any) {
        print("signup")
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
