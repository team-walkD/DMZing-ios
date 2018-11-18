//
//  PutCourseService.swift
//  DMZing
//
//  Created by 장한솔 on 2018. 11. 18..
//  Copyright © 2018년 장용범. All rights reserved.
//

import Foundation

struct PutCourseService: GettableService {
    
    //MARK: 코스 픽 하기 /api/pick
    typealias NetworkData = FirstDataPickCourse
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
                print("hhhhhH")
                print(errMsg)
                break
            case .failure(_) :
                completion(.networkFail)
            }
        }
    }
}
