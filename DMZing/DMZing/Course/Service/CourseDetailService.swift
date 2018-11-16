//
//  CourseDetailService.swift
//  DMZing
//
//  Created by 김예은 on 16/11/2018.
//  Copyright © 2018 장용범. All rights reserved.
//

import Foundation

struct CourseDetailService: GettableService {
    
    //MARK: 코스 상세보기 - /api/course/{cid}
    typealias NetworkData = CourseDetailData
    static let shareInstance = CourseDetailService()
    
    func getCourseDetailData(url : String, completion : @escaping (NetworkResult<Any>) -> Void) {
        
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
