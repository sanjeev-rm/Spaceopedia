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
        case invalidUrl
        case invalidArticleUrl
        case invalidImageUrl
        case articleNotFound
        case imageNotFound
    }
    
    /// Fetches Articles.
    static func fetchArticles() async throws -> SpaceFlightNewsAPIResponse {
        guard let url = SpaceFlightNewsAPI.getRequestUrl() else {
            throw SpaceNewsError.articleNotFound
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpUrlResponse = response as? HTTPURLResponse,
              httpUrlResponse.statusCode == 200 else {
            throw SpaceNewsError.articleNotFound
        }
        
        let jsonDecoder = JSONDecoder()
        let jsonDecodedNewsResponse = try jsonDecoder.decode(SpaceFlightNewsAPIResponse.self, from: data)
        
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
