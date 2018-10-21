//
//  HttpResCode.swift
//  DMZing
//
//  Created by 강수진 on 2018. 10. 21..
//  Copyright © 2018년 장용범. All rights reserved.
//

import Foundation
enum HttpResponseCode: Int{
    case getSuccess = 200
    case postSuccess = 201
    case selectErr = 300
    case badRequest = 400
    case accessDenied = 401
    case forbidden = 403
    case conflict = 409
    case serverErr = 500
}


enum Result<T> {
    case success(T)
    case error(String)
    case failure(Error)
}

enum NetworkResult<T> {
    case networkSuccess(T)
    case serverErr
    case accessDenied
    case nullValue
    case duplicated
    case networkFail
    case wrongInput
}
