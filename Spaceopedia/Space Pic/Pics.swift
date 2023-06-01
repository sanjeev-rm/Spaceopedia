//
//  Pics.swift
//  Spaceopedia
//
//  Created by Sanjeev RM on 01/06/23.
//

import Foundation

struct PicsAPIResponse: Codable {
    var total: Int
    var totalPages: Int
    var pics: [Pic]
    
    enum CodingKeys: String, CodingKey {
        case total
        case totalPages = "total_pages"
        case pics = "results"
    }
}

struct Pic: Codable {
    var id: String
    var description: String?
    var alternateDescription: String
    var imageUrls: ImageUrls
    var photographer: Photographer
    
    enum CodingKeys: String, CodingKey {
        case id
        case description
        case alternateDescription = "alt_description"
        case imageUrls = "urls"
        case photographer = "user"
    }
}

struct ImageUrls: Codable {
    var raw: String
    var full: String
    var regular: String
    var small: String
}

struct Photographer: Codable {
    var firstName: String
    var lastName: String?
    var links: UserLinks
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case links
    }
}

struct UserLinks: Codable {
    var profileLink: String
    
    enum CodingKeys: String, CodingKey {
        case profileLink = "html"
    }
}
