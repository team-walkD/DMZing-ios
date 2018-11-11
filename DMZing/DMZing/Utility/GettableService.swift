//
//  GettableService.swift
//  DMZing
//
//  Created by 강수진 on 2018. 10. 21..
//  Copyright © 2018년 장용범. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol GettableService {
    associatedtype NetworkData : Codable
    typealias networkResult = (resCode : Int, resResult : NetworkData)
    func get(_ URL:String, method : HTTPMethod, completion : @escaping (Result<networkResult>)->Void)
    
}

extension GettableService {
    
    func gino(_ value : Int?) -> Int {
        return value ?? 0
    }
    
    func get(_ URL:String, method : HTTPMethod = .get, completion : @escaping (Result<networkResult>)->Void){
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
        
        Alamofire.request(encodedUrl, method: method, parameters: nil, headers: headers).responseData {(res) in
            print("encodedURK")
            print(encodedUrl)
            switch res.result {
                
            case .success :
                if let value = res.result.value {
                    print("networking Get Here!")
                    print(encodedUrl)
                    print(JSON(value))
                    
                    let decoder = JSONDecoder()
                    do {
                        let resCode = self.gino(res.response?.statusCode)
                        let data = try decoder.decode(NetworkData.self, from: value)
                        
                        let result : networkResult = (resCode, data)
                        completion(.success(result))
                        
                    }catch{
                        completion(.error("error get"))
                    }
                }
                break
            case .failure(let err) :
                print(err.localizedDescription)
                completion(.failure(err))
                break
            }
            
        }
    }
    
}
