//
//  NewsModel.swift
//  Spaceopedia
//
//  Created by Sanjeev RM on 06/06/23.
//

import Foundation

/// Model that represents a response from the NewsAPI.
struct NewsResponse: Codable {
    var status: String
    var totalResults: Int
    var articles: [Article]
}

/// Model that represents an Article.
struct Article: Codable {
    var source: ArticleSource
    var author: String?
    var title: String
    var description: String
    var url: String
    var urlToImage: String?
    var publishedAt: String
}

/// Model that represents the Source of an Article.
struct ArticleSource: Codable {
    var id: String?
    var name: String
}
