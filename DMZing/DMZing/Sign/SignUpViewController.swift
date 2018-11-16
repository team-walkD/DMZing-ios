//
//  SignUpViewController.swift
//  DMZing
//
//  Created by 장한솔 on 2018. 11. 15..
//  Copyright © 2018년 장용범. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var alertEmailLabel: UILabel!
    @IBOutlet weak var alertPwLabel: UILabel!
    @IBOutlet weak var alertPhoneLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var nicknameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    @IBAction func submitAction(_ sender: Any) {
        if(emailTextField.text != "" && pwTextField.text != "" && phoneTextField.text != "" && nicknameTextField.text != ""){
            guard let email = emailTextField.text else {return}
            guard let password = pwTextField.text else {return}
            guard let phone = phoneTextField.text else {return}
            guard let nickname = nicknameTextField.text else {return}
            
            let validEmail = isValidEmailAddress(email: email)
            let validPassword = isValidPassword(password: password)
            let validPhone = isValidPhoneNumber(phone: phone)
            
            if(!validEmail){
                emailTextField.shake()
                alertEmailLabel.isHidden = false
            }
            if(!validPassword){
                pwTextField.shake()
                alertPwLabel.isHidden = false
            }
            if(!validPhone){
                phoneTextField.shake()
                alertPhoneLabel.isHidden = false
            }
            
            if(validEmail && validPassword && validPhone){
                self.simpleAlert(title: "회원가입 gogo", message: "gogo")
            }
        }else{
            self.simpleAlert(title: "회원가입 오류", message: "모두 입력해주세요")
        }
        
    }
    
    func isValidEmailAddress(email: String) -> Bool {
        
        let emailRegEx = "^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$"// ~~@~~.com
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
        
    }
    
    func isValidPhoneNumber(phone: String) -> Bool {
        
        let phoneRegEx = "^01([0|1|6|7|8|9]?)?([0-9]{3,4})?([0-9]{4})$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", phoneRegEx)
        return emailTest.evaluate(with: phone)
        
    }
    
    func isValidPassword(password: String) -> Bool {
        
        let pwRegEx = "^(?=.*[a-zA-Z])(?=.*[^a-zA-Z0-9])(?=.*[0-9]).{6,20}$" // 영어,숫자,특수문자 조합 6-20자리
        let emailTest = NSPredicate(format:"SELF MATCHES %@", pwRegEx)
        return emailTest.evaluate(with: password)
        
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

