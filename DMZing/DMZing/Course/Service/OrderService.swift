//
//  OrderService.swift
//  DMZing
//
//  Created by 김예은 on 18/11/2018.
//  Copyright © 2018 장용범. All rights reserved.
//

import Foundation

struct OrderService: PostableService{
    typealias NetworkData = DefaultVO
    static let shareInstance = OrderService()
    
    func orderCourse(url : String, params : [String : Any], completion : @escaping (NetworkResult<Any>) -> Void){
        
        post(url, params: params) { (result) in
            switch result {
            case .success(let networkResult):
                switch networkResult.resCode{
                case HttpResponseCode.postSuccess.rawValue :
                    completion(.networkSuccess(""))
//                case HttpResponseCode.accessDenied.rawValue :
//                    completion(.accessDenied)
                case HttpResponseCode.serverErr.rawValue :
                    completion(.serverErr)
                case HttpResponseCode.badRequest.rawValue :
                    completion(.duplicated)
                default :
                    print("no 201/500 rescode is \(networkResult.resCode)")
                    break
                }
                
                break
            case .error(let errMsg) :
                print(errMsg)
                break
            case .failure(_) :
                completion(.networkFail)
            }
        }
        
    }
}
