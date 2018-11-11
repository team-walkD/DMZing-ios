//
//  PostableService.swift
//  DMZing
//
//  Created by 강수진 on 2018. 10. 21..
//  Copyright © 2018년 장용범. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol PostableService {
    associatedtype NetworkData : Codable
    typealias networkResult = (resCode : Int, resResult : NetworkData)
    func post(_ URL:String, params : [String : Any], completion : @escaping (Result<networkResult>)->Void)
    
}

extension PostableService {
    
    func gino(_ value : Int?) -> Int {
        return value ?? 0
    }
    
    
    func post(_ URL:String, params : [String : Any], completion : @escaping (Result<networkResult>)->Void){
        
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

        Alamofire.request(encodedUrl, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseData(){
            res in
            switch res.result {
            case .success:
                print(encodedUrl)
                print("networking Post Here")
                print(JSON(res.result))
                if let value = res.result.value {
                    print(JSON(value))
                    let decoder = JSONDecoder()
                    
                    
                    do {
                        
                        let resCode = self.gino(res.response?.statusCode)
                        let data = try decoder.decode(NetworkData.self, from: value)
                        
                        let result : networkResult = (resCode, data)
                        completion(.success(result))
                        
                        
                    }catch{
                        
                        completion(.error("error post"))
                    }
                }
                break
            case .failure(let err):
                print(err.localizedDescription)
                completion(.failure(err))
                break
            }
        }
        
        
    }
    
    
    
}
