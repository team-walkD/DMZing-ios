//
//  WritePhotoReviewService.swift
//  DMZing
//
//  Created by 강수진 on 2018. 11. 13..
//  Copyright © 2018년 장용범. All rights reserved.
//

import Foundation

struct WritePhotoReviewService: PostableService{
    typealias NetworkData = DefaultVO
    static let shareInstance = WritePhotoReviewService()
    func writePhotoReview(url : String, params : [String : Any], completion : @escaping (NetworkResult<Any>) -> Void){
        post(url, params: params) { (result) in
            switch result {
            case .success(let networkResult):
                switch networkResult.resCode{
                case HttpResponseCode.postSuccess.rawValue :
                    completion(.networkSuccess(""))
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
