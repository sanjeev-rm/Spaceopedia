//
//  Pics.swift
//  Spaceopedia
//
//  Created by Sanjeev RM on 01/06/23.
//

import Foundation

/// Model to represent the response from the Nasa Images API.
struct PicsAPIResponse: Codable {
    var collection: Collection
}

/// Model to represent a collection.
struct Collection: Codable {
    var version: String
    var url: String
    var pics: [PicItem]
    
    enum CodingKeys: String, CodingKey {
        case version
        case url = "href"
        case pics = "items"
    }
}

/// Model to represent PicItem.
/// properties data & links will contain only 1 element. So call it like data[0] & links[0].
struct PicItem: Codable {
    var url: String
    var data: [PicData]
    var links: [PicLink]
    
    enum CodingKeys: String, CodingKey {
        case url = "href"
        case data
        case links
    }
}

/// Model to represent PicData.
struct PicData: Codable {
    var title: String
    var dateCreated: String
    var mediaType: String
    var smallDescription: String?
    var description: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case dateCreated = "date_created"
        case mediaType = "media_type"
        case smallDescription = "description_508"
        case description
    }
}

/// Model to represent PicLink.
struct PicLink: Codable {
    var url: String
    var render: String
    
    enum CodingKeys: String, CodingKey {
        case url = "href"
        case render
    }
}
