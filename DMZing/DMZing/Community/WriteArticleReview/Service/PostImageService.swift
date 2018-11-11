//
//  PostImageService.swift
//  DMZing
//
//  Created by 강수진 on 2018. 11. 11..
//  Copyright © 2018년 장용범. All rights reserved.
//

import Foundation

struct PostImageService : PostablewithPhoto {
    typealias NetworkData = PostImageVO
    static let shareInstance = PostImageService()
    func addPhoto(url : String, params : [String : Any], image : [String : Data]?, completion : @escaping (NetworkResult<Any>) -> Void){
        savePhotoContent(url, params: params, imageData: image) { (result) in
            switch result {
        
            case .success(let networkResult):
                switch networkResult.resCode {
            
                case HttpResponseCode.postSuccess.rawValue :
                    completion(.networkSuccess(networkResult.resResult))
                case HttpResponseCode.accessDenied.rawValue :
                    completion(.accessDenied)
                case HttpResponseCode.serverErr.rawValue :
                    completion(.serverErr)
                default :
                    print("no 201/401/500 - statusCode is \(networkResult.resCode)")
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
