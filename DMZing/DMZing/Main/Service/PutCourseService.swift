//
//  PutCourseService.swift
//  DMZing
//
//  Created by 장한솔 on 2018. 11. 18..
//  Copyright © 2018년 장용범. All rights reserved.
//

import Foundation

struct PutCourseService: GettableService {
    
    //MARK: 코스 구매 목록 및 픽된 코스 상세 정보 보기  /api/mission
    typealias NetworkData = FirstVO
    static let shareInstance = PutCourseService()
    
    func putCourse(url : String, completion : @escaping (NetworkResult<Any>) -> Void) {
        
        get(url,method: .put) { (result) in
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
