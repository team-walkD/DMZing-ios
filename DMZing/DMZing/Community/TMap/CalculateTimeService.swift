//
//  CalculateTimeService.swift
//  DMZing
//
//  Created by 강수진 on 2018. 11. 17..
//  Copyright © 2018년 장용범. All rights reserved.
//

import Foundation

struct CalculateTimeService: PostableService{
    typealias NetworkData = CalculateTimeVO
    static let shareInstance = CalculateTimeService()
    func calculateTimeToNext(url : String, params : [String : Any], completion : @escaping (NetworkResult<Any>) -> Void){
        post(url, params: params) { (result) in
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
