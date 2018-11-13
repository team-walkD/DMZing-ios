//
//  GetSpotService.swift
//  DMZing
//
//  Created by 강수진 on 2018. 11. 13..
//  Copyright © 2018년 장용범. All rights reserved.
//

import Foundation

struct GetSpotService : GettableService {
    typealias NetworkData = SpotVO
    static let shareInstance = GetSpotService()
    func getMainData(url : String, completion : @escaping (NetworkResult<Any>) -> Void){
        get(url) { (result) in
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
                    print("no 200/500 rescode is \(networkResult.resCode)")
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
