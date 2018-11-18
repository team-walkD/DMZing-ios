//
//  PickService.swift
//  DMZing
//
//  Created by 김예은 on 17/11/2018.
//  Copyright © 2018 장용범. All rights reserved.
//

import Foundation

struct PickService: PuttableService{
    
    typealias NetworkData = DefaultVO
    static let shareInstance = PickService()
    
    func putPick(url : String, completion : @escaping (NetworkResult<Any>) -> Void){
        put(url) { (result) in
            switch result {
            case .success(let networkResult):
                switch networkResult.resCode{
                case HttpResponseCode.getSuccess.rawValue :
                    completion(.networkSuccess(networkResult.resResult))
                case HttpResponseCode.accessDenied.rawValue :
                    completion(.accessDenied)
                case HttpResponseCode.serverErr.rawValue :
                    completion(.serverErr)
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

