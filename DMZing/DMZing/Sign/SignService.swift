//
//  SignService.swift
//  DMZing
//
//  Created by 장한솔 on 2018. 11. 15..
//  Copyright © 2018년 장용범. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct SignService : APIService{
    
    //MARK: 로그인 서비스
    static func login(email: String, pwd: String, completion: @escaping (_ message: String)->Void){
        
        let userdefault = UserDefaults.standard
        
        let URL = "http://52.79.50.98:8080/api/users/login"
        
        let body: [String: Any] = [
            "email" : email,
            "password" : pwd
        ]
        
        Alamofire.request(URL, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil).responseData(){ res in
            switch res.result{
            case .success:
                if let value = res.result.value{
                    if let statuscode = res.response?.statusCode{
                        if statuscode == 200{
                            if let jwt = res.response?.allHeaderFields["jwt"] as? String{
                                print("jwt:"+jwt)
                                userdefault.set(jwt, forKey: "userToken")
                                completion("success")
                            }
                        }
                        if statuscode == 403{
                            completion("failure")
                        }
                    }
                    
                }
                
                break
            case .failure(let err):
                print(err.localizedDescription)
                break
            }
        }
    }
    
    
    //MARK: 회원가입 서비스
    static func signup(email: String, pwd: String, nickname: String, phone: String, completion: @escaping (_ message: String)->Void){
        
        let userdefault = UserDefaults.standard
        
        let URL = "http://52.79.50.98:8080/api/users"
        
        let body: [String: Any] = [
            "email" : email,
            "password" : pwd,
            "nickname" : nickname,
            "phonenumber" : phone
        ]
        
        Alamofire.request(URL, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil).responseData(){ res in
            switch res.result{
            case .success:
                if let value = res.result.value{
                    if let statuscode = res.response?.statusCode{
                        if statuscode == 200{
                            
                        }else if statuscode == 400{
                            completion("already exist")
                        }else if statuscode == 201{
                            completion("success")
                        }else{
                            completion("error")
                        }
                    }
                    
                }
                
                break
            case .failure(let err):
                print(err.localizedDescription)
                break
            }
        }
    }
}

