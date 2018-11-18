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

extension UIView {
    
    func removeConstraints() {
        removeConstraints(constraints)
    }
    
    func deactivateAllConstraints() {
        NSLayoutConstraint.deactivate(getAllConstraints())
    }
    
    func getAllSubviews() -> [UIView] {
        return UIView.getAllSubviews(view: self)
    }
    
    func getAllConstraints() -> [NSLayoutConstraint] {
        
        var subviewsConstraints = getAllSubviews().flatMap { (view) -> [NSLayoutConstraint] in
            return view.constraints
        }
        
        if let superview = self.superview {
            subviewsConstraints += superview.constraints.flatMap{ (constraint) -> NSLayoutConstraint? in
                if let view = constraint.firstItem as? UIView {
                    if view == self {
                        return constraint
                    }
                }
                return nil
            }
        }
        
        return subviewsConstraints + constraints
    }
    
    class func getAllSubviews(view: UIView) -> [UIView] {
        return view.subviews.flatMap { subView -> [UIView] in
            return [subView] + getAllSubviews(view: subView)
        }
    }
}

class SignInViewController: UIViewController,APIService, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    @IBOutlet weak var signinButton: UIButton!
    @IBOutlet weak var mailLbl: UILabel!
    @IBOutlet weak var pwdLbl: UILabel!
    @IBOutlet weak var mailBottomView: UIView!
    @IBOutlet weak var pwdBottomView: UIView!
    var keyboardDismissGesture: UITapGestureRecognizer?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emailTextField.text = ""
        pwTextField.text = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signinButton.makeRounded(cornerRadius: signinButton.frame.height/2)
        setKeyboardSetting()
        
    }
    
    @IBAction func signinAction(_ sender: Any) {
        if(emailTextField.text != "" && pwTextField.text != ""){
            guard let email = emailTextField.text else {return}
            guard let password = pwTextField.text else {return}
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
}

//MARK: - 키보드 대응
extension SignInViewController {
    func setKeyboardSetting() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        adjustKeyboardDismissGesture(isKeyboardVisible: true)
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardEndframe = self.view.convert(keyboardSize, from: nil)
            let endFrameHeight = keyboardEndframe.height
            let endFrameY = keyboardEndframe.origin.y
            let isPwdViewHidden = endFrameY < pwdBottomView.frame.origin.y
            
            if isPwdViewHidden {
                //키보드가 패스워드 뷰를 가림
                updateLayout(endFrameHeight: endFrameHeight, isSetOrigin: false)
            }
        }
        
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        adjustKeyboardDismissGesture(isKeyboardVisible: false)
        updateLayout(isSetOrigin: true)
    }
 
    func updateLayout(endFrameHeight : CGFloat = 0, isSetOrigin : Bool){
        pwdBottomView.deactivateAllConstraints()
        pwTextField.deactivateAllConstraints()
        pwdLbl.deactivateAllConstraints()
        mailBottomView.deactivateAllConstraints()
        emailTextField.deactivateAllConstraints()
        mailLbl.deactivateAllConstraints()
        if isSetOrigin {
            pwdBottomView.snp.makeConstraints({ (make) in
                let propotinalHeight = 300/812*self.view.frame.height
                make.bottom.equalTo(self.view.snp.bottom).offset(-(propotinalHeight))
                make.leading.equalToSuperview().offset(38)
                make.trailing.equalToSuperview().offset(-38)
                make.height.equalTo(1)
            })
        } else {
            pwdBottomView.snp.makeConstraints({ (make) in
                make.bottom.equalTo(self.view.snp.bottom).offset(-(endFrameHeight+10))
                make.leading.equalToSuperview().offset(38)
                make.trailing.equalToSuperview().offset(-38)
                make.height.equalTo(1)
            })
            
        }
      
        pwTextField.snp.makeConstraints({ (make) in
            make.bottom.equalTo(pwdBottomView.snp.top)
            make.leading.trailing.equalTo(pwdBottomView)
            make.height.equalTo(20)
        })
        
        pwdLbl.snp.makeConstraints({ (make) in
            make.bottom.equalTo(pwTextField.snp.top).offset(-20)
            make.leading.trailing.equalTo(pwdBottomView)
            make.height.equalTo(20)
        })
        
        
        mailBottomView.snp.makeConstraints({ (make) in
            let propotinalHeight = 41/812*self.view.frame.height
            make.bottom.equalTo(pwdLbl.snp.top).offset(-(propotinalHeight))
            make.leading.equalToSuperview().offset(38)
            make.trailing.equalToSuperview().offset(-38)
            make.height.equalTo(1)
            
        })
        
        emailTextField.snp.makeConstraints({ (make) in
            make.bottom.equalTo(mailBottomView.snp.top)
            make.leading.trailing.equalTo(mailBottomView)
            make.height.equalTo(20)
        })
        
        mailLbl.snp.makeConstraints({ (make) in
            make.bottom.equalTo(emailTextField.snp.top).offset(-20)
            make.leading.trailing.equalTo(mailBottomView)
            make.height.equalTo(20)
        })
    }
    
    func adjustKeyboardDismissGesture(isKeyboardVisible: Bool) {
        if isKeyboardVisible {
            if keyboardDismissGesture == nil {
                keyboardDismissGesture = UITapGestureRecognizer(target: self, action: #selector(tapBackground))
                view.addGestureRecognizer(keyboardDismissGesture!)
            }
        } else {
            if keyboardDismissGesture != nil {
                view.removeGestureRecognizer(keyboardDismissGesture!)
                keyboardDismissGesture = nil
            }
        }
    }
    
    @objc func tapBackground() {
        self.view.endEditing(true)
    }
}

