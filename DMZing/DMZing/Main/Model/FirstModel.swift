// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

struct FirstVO : Codable {
    let pickCourse: FirstDataPickCourse
    let purchaseList: [FirstDataPurchaseList]
}

struct SecondVO : Codable {
    let pickCourse: SecondDataPickCourse
}


struct FirstDataPickCourse: Codable {
    let reviewCount, estimatedTime: Int
    let lineImageUrl: String
    let id: Int
    let places: [FirstDataPickCoursePlace]
    let mainDescription, title: String
    let imageUrl: String
    let level: String
    let price: Int
    let subDescription, backgroundImageUrl: String
    
    enum CodingKeys: String, CodingKey {
        case reviewCount, estimatedTime
        case lineImageUrl = "lineImageUrl"
        case id, places, mainDescription, title
        case imageUrl = "imageUrl"
        case level, price, subDescription
        case backgroundImageUrl = "backgroundImageUrl"
    }
}

struct SecondDataPickCourse: Codable {
    let reviewCount, estimatedTime: Int
    let lineImageURL: String
    let id: Int
    let places: [FirstDataPickCoursePlace]
    let mainDescription, title, imageURL, level: String
    let price: Int
    let subDescription, backgroundImageURL: String
    
    enum CodingKeys: String, CodingKey {
        case reviewCount, estimatedTime
        case lineImageURL = "lineImageUrl"
        case id, places, mainDescription, title
        case imageURL = "imageUrl"
        case level, price, subDescription
        case backgroundImageURL = "backgroundImageUrl"
    }
}

struct FirstDataPickCoursePlace: Codable {
    let letterImageURL: String?
    let reward: Int
    let address, description: String
    let subImageURL: String
    let infoCenter: String?
    let latitude: Double?
    let sequence, id: Int
    let restDate, parking: String?
    let peripheries: [FirstDataPickCoursePlacePeriphery]
    let mainImageURL: String
    let title, hint: String
    let longitude: Double?
    
    enum CodingKeys: String, CodingKey {
        case letterImageURL = "letterImageUrl"
        case reward, address, description
        case subImageURL = "subImageUrl"
        case infoCenter, latitude, sequence, id, restDate, parking, peripheries
        case mainImageURL = "mainImageUrl"
        case title, hint, longitude
    }
}

struct FirstDataPickCoursePlacePeriphery: Codable {
    let firstimage: String?
    let title: String
    let contenttypeid: Int
}

struct FirstDataPurchaseList: Codable {
    let title: String
    var isPicked: Bool
    let id: Int
    let mainDescription: String
}
