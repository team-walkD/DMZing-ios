//
//  PostableWithPhoto.swift
//  DMZing
//
//  Created by 강수진 on 2018. 10. 21..
//  Copyright © 2018년 장용범. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol PostablewithPhoto {
    
    associatedtype NetworkData : Codable
    typealias networkResult = (resCode : Int, resResult : NetworkData)
    func savePhotoContent(_ URL:String, params : [String : Any], imageData : [String : Data]?, completion : @escaping (Result<networkResult>)->Void)
}

extension PostablewithPhoto {
    
    func gino(_ value : Int?) -> Int {
        return value ?? 0
    }
    
    
    
    func savePhotoContent(_ URL:String, params : [String : Any], imageData : [String : Data]?, completion : @escaping (Result<networkResult>)->Void) {
        
        
        guard let encodedUrl = URL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            print("networking - invalid url")
            return
        }
        print("url 은 \(encodedUrl)")
        
        let userToken = UserDefaults.standard.string(forKey: "userToken") ?? "-1"
        var headers: HTTPHeaders?
        
        if userToken != "-1" {
//            headers = [
//                "authorization" : userToken
//            ]
        }
        headers = [
            "jwt" : "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdXRob3JpdHkiOiJVU0VSIiwiaXNzIjoiZG16aW5nIiwiZXhwIjoxNTQyMTc4MjM1LCJlbWFpbCI6ImFrc2d1ckBuYXZlci5jb20ifQ.j8W_SA9qHCk7l1AZIqf5BZUHo6shs8Fxq7VKUfIUH2o"
        ]
        
        
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            
            for (x,y) in params {
                if y is String {
                    multipartFormData.append((y as! String).data(using: .utf8)!, withName: x)
                }
                else if y is Int {
                    multipartFormData.append("\(y)".data(using: .utf8)!, withName: x)
                } else if y is Double {
                    multipartFormData.append("\(y)".data(using: .utf8)!, withName: x)
                }
                print("param key is \(x), value is \(y)")
            }
            
            let calendar = Calendar.current
            let time=calendar.dateComponents([.hour,.minute,.second], from: Date())
            let imgName = "\(time.hour!):\(time.minute!):\(time.second!)"
            
            
            if let images_ = imageData {
                
                for (x,y) in images_ {
                    multipartFormData.append(y, withName: x, fileName: "\(imgName).jpeg", mimeType: "image/png")
                    
                }
            }
            
        }, to: encodedUrl, method: .post, headers: headers, encodingCompletion:{
            (encodingResult) in
            switch encodingResult {
            case .success(let upload,_,_):
                upload.responseData(completionHandler: { (res) in
                    
                    switch res.result{
                        
                    case .success:
                        if let value = res.result.value {
                            print(res.response?.statusCode ?? 00)
                            print(JSON(value))
                            let decoder = JSONDecoder()
                            do {
                                
                                let resCode = self.gino(res.response?.statusCode)
                                let data = try decoder.decode(NetworkData.self, from: value)
                                
                                let result : networkResult = (resCode, data)
                                completion(.success(result))
                                
                                
                            }catch{
                                completion(.error("error post photo"))
                            }
                            
                            
                        }
                    case .failure(let err):
                        print(err.localizedDescription)
                        
                        break
                    }
                })
                break
            case .failure(let err):
                print(err.localizedDescription)
                break
            }
        })
    }
}
