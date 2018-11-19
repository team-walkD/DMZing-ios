//
//  PostableMissionService.swift
//  DMZing
//
//  Created by 장한솔 on 2018. 11. 19..
//  Copyright © 2018년 장용범. All rights reserved.
//

import Foundation

struct PostableMissionService: PostableService{
    typealias NetworkData = MissionVO
    static let shareInstance = PostableMissionService()
    func sendMission(url : String, params : [String : Any], completion : @escaping (NetworkResult<Any>) -> Void){
        post(url, params: params) { (result) in
            switch result {
            case .success(let networkResult):
                switch networkResult.resCode{
                case HttpResponseCode.getSuccess.rawValue :
                    completion(.networkSuccess(networkResult.resResult))
                case HttpResponseCode.serverErr.rawValue :
                    completion(.serverErr)
                default :
                    print("no 201/500 rescode is \(networkResult.resCode)")
                    break
                }
                
                break
            case .error(let resCode) :
                switch resCode{
                case HttpResponseCode.badRequest.rawValue.description :
                     completion(.badRequest)
                default :
                    print("no 400 rescode")
                    break
                }
                break
            case .failure(_) :
                completion(.networkFail)
            }
        }
        
    }
}
