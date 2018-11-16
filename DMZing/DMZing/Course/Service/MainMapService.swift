//
//  MainMapService.swift
//  DMZing
//
//  Created by 김예은 on 16/11/2018.
//  Copyright © 2018 장용범. All rights reserved.
//

import Foundation

struct MainMapService: GettableService {
    
    //MARK: 전체 코스 종류 및 정보 보기 - /api/course
    typealias NetworkData = CourseData
    static let shareInstance = MainMapService()
    
    func getMainCourseData(url : String, completion : @escaping (NetworkResult<Any>) -> Void) {
        
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

