//
//  PlaceService.swift
//  DMZing
//
//  Created by 김예은 on 17/11/2018.
//  Copyright © 2018 장용범. All rights reserved.
//

import Foundation

struct PlaceService: GettableService {
    
    //MARK: 코스 내 장소보기 - /api/course/{cid}/places
    typealias NetworkData = PlaceData
    static let shareInstance = PlaceService()
    
    func getPlaceData(url : String, completion : @escaping (NetworkResult<Any>) -> Void) {
        
        get(url) { (result) in
            switch result {
            case .success(let networkResult):
                switch networkResult.resCode{
                    
                case HttpResponseCode.getSuccess.rawValue :
                    
                    completion(.networkSuccess(networkResult.resResult))
                    
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

