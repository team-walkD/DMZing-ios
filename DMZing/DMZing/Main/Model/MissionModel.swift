//
//  MissionModel.swift
//  DMZing
//
//  Created by 장한솔 on 2018. 11. 19..
//  Copyright © 2018년 장용범. All rights reserved.
//

import Foundation

typealias MissionVO = [FirstDataPickCoursePlace]

struct MissionElement: Codable {
    let address, description, hint: String
    let id: Int
    let infoCenter: String
    let latitude: Double?
    let letterImageURL: String?
    let longitude: Double?
    let mainImageURL, parking: String
    let peripheries: [FirstDataPickCoursePlacePeriphery]
    let restDate: String
    let reward, sequence: Int
    let subImageURL, title: String
    
    enum CodingKeys: String, CodingKey {
        case address, description, hint, id, infoCenter
        case latitude
        case letterImageURL = "letterImageUrl"
       case longitude
        case mainImageURL = "mainImageUrl"
        case parking, peripheries, restDate, reward, sequence
        case subImageURL = "subImageUrl"
        case title
    }
}


