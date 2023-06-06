//
//  SpaceNewsController.swift
//  Spaceopedia
//
//  Created by Sanjeev RM on 06/06/23.
//

import Foundation
import UIKit

class SpaceNewsController
{
    /// An Error type to represents erros that occur during fetching Space News.
    enum SpaceNewsError: Error {
        case invalidArticleUrl
        case invalidImageUrl
        case articleNotFound
        case imageNotFound
    }
    
    /// Fetches Articles in a given sortBy order.
    static func fetchArticles(sortBy: NewsAPI.ArticlesSortBy) async throws -> NewsResponse {
        guard let url = NewsAPI.getRequestUrlWith(sortBy: .publishedAt) else {
            throw SpaceNewsError.articleNotFound
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpUrlResponse = response as? HTTPURLResponse,
              httpUrlResponse.statusCode == 200 else {
            throw SpaceNewsError.articleNotFound
        }
        
        let jsonDecoder = JSONDecoder()
        let jsonDecodedNewsResponse = try jsonDecoder.decode(NewsResponse.self, from: data)
        
        return jsonDecodedNewsResponse
    }
    
    /// Fetches specific artcile's image.
    static func fetchArticleImage(imageUrlString: String) async throws -> UIImage? {
        
        guard let url = URL(string: imageUrlString) else {
            throw SpaceNewsError.invalidImageUrl
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpUrlResponse = response as? HTTPURLResponse,
              httpUrlResponse.statusCode == 200 else {
            throw SpaceNewsError.imageNotFound
        }
        
        let image = UIImage(data: data)
        
        return image
    }
}
