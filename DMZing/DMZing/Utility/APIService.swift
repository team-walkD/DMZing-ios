//
//  APIService.swift
//  DMZing
//
//  Created by 강수진 on 2018. 10. 21..
//  Copyright © 2018년 장용범. All rights reserved.
//

import Foundation

protocol APIService {}

extension APIService {
    func url(_ path: String, isChatbot : Bool = false) -> String {
        if isChatbot {
            return "\(NetworkConfiguration.shared().chatbotURL)" + path
        } else {
            return "\(NetworkConfiguration.shared().baseURL)" + path
        }
    }
    
    func gsno(_ value : String?) -> String{
        return value ?? ""
    }
    
    func gino(_ value : Int?) -> Int {
        return value ?? 0
    }
}
