//
//  PuttableService.swift
//  DMZing
//
//  Created by 김예은 on 18/11/2018.
//  Copyright © 2018 장용범. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol PuttableService {
    associatedtype NetworkData : Codable
    typealias networkResult = (resCode : Int, resResult : NetworkData)
    func put(_ URL:String, completion : @escaping (Result<networkResult>)->Void)
    
}

extension PuttableService {
    
    func gino(_ value : Int?) -> Int {
        return value ?? 0
    }

    func put(_ URL:String, completion : @escaping (Result<networkResult>)->Void){
        
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
            "jwt" : sampleJWT
        ]
        
        let params : [String: Any] = [:]
        
        Alamofire.request(encodedUrl, method: .put, parameters: params, encoding: JSONEncoding.default, headers: headers).responseData(){
            res in
            switch res.result {
            case .success:
                print(encodedUrl)
                print("networking Put Here")
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
