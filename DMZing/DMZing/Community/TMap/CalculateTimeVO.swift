//
//  CalculateTimeVO.swift
//  DMZing
//
//  Created by 강수진 on 2018. 11. 17..
//  Copyright © 2018년 장용범. All rights reserved.
//

import Foundation


struct CalculateTimeVO: Codable {
    let features: [Feature]
}

struct Feature: Codable {
    let properties: Properties
}

struct Properties: Codable {
    let carDistance: Int?
    let carTime : Int?
    let walkDistance: Int?
    let walkTime : Int?
    enum CodingKeys: String, CodingKey {
        case carDistance = "totalDistance"
        case carTime = "totalTime"
        case walkDistance = "distance"
        case walkTime = "time"
    }
}
