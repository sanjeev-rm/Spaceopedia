//
//  NewsModel.swift
//  Spaceopedia
//
//  Created by Sanjeev RM on 06/06/23.
//

import Foundation

/// Model that represents a response from the SpaceFlightNewsAPI.
struct SpaceFlightNewsAPIResponse: Codable {
    var count: Int
    var nextTenArticlesUrl: String?
    var previousTenArticlesUrl: String?
    var results: [Article]
}

/// Model that represents an Article.
struct Article: Codable {
    var id: Int
    var title: String
    var url: String
    var imageUrl: String?
    var newsSite: String
    var summary: String
    var publishedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case url
        case imageUrl = "image_url"
        case newsSite = "news_site"
        case summary
        case publishedAt = "published_at"
    }
}
