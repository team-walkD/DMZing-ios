//
//  SignInViewController.swift
//  DMZing
//
//  Created by 장한솔 on 2018. 11. 1..
//  Copyright © 2018년 장용범. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SignInViewController: UIViewController,APIService {
    

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
            
            print("여기까지")
            SignService.login(email: email, pwd: password) { message in
                if message == "success"{
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainTab")
                    self.present(vc, animated: true, completion: nil)
                    
                }else if message == "failure"{
                    self.simpleAlert(title: "로그인 실패", message: "회원 정보가 틀렸습니다.")
                }
            }
            
            
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
