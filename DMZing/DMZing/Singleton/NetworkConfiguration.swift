//
//  NetworkConfiguration.swift
//  DMZing
//
//  Created by 강수진 on 2018. 10. 21..
//  Copyright © 2018년 장용범. All rights reserved.
//

import Foundation
class NetworkConfiguration {
    //나중에 실제 TMapAPIKey 변경하면 됨
    //let TMapAPIKey = "AIzaSyDHQ6FCyfyqU79K6J0l0gv18J_D3h81ZHc"
    let baseURL = "http://52.79.50.98:8080/"
    
    struct StaticInstance {
        static var instance: NetworkConfiguration?
    }
    
    class func shared() -> NetworkConfiguration {
        if StaticInstance.instance == nil {
            StaticInstance.instance = NetworkConfiguration()
        }
        return StaticInstance.instance!
    }
}
