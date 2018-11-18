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
                    headers = [
                            "authorization" : userToken
                        ]
        }

        
        Alamofire.request(encodedUrl, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseData(){
            res in
            switch res.result {
            case .success:
                print(encodedUrl)
                print("networking Post Here")
                if let value = res.result.value {
                    let resCode = self.gino(res.response?.statusCode)
                    print(resCode)
                   
                    print(JSON(value))
                    
                    if JSON(value) == JSON.null {
                        let result : networkResult = (resCode, DefaultVO()) as! (resCode: Int, resResult: Self.NetworkData)
                        completion(.success(result))
                        break
                    }
                    
                    let decoder = JSONDecoder()
                    do {
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
