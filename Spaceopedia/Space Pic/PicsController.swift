//
//  PicsController.swift
//  Spaceopedia
//
//  Created by Sanjeev RM on 01/06/23.
//

import Foundation
import UIKit

class PicsController
{
    enum PicsError: Error {
        case notFound
    }
    
    enum PicError: Error {
        case invalidUrl
        case notFound
    }
    
    /// Fetches PicsAPIResponse from the API.
    /// Fetches the URLS of the images.
    static func fetchPicsOf(word searchQuery : String, sinceYear: Int = 2015) async throws -> PicsAPIResponse {
        
        let query: [String : String] = ["q":searchQuery,
                                        "media_type":"image",
                                        "year_start":String(sinceYear)]
        
        var urlComponents = URLComponents(string: SpacePicAPI.getRequestUrlString())!
        urlComponents.queryItems = query.map { key, value in
            URLQueryItem(name: key, value: value)
        }
        
        let (data, response) = try await URLSession.shared.data(from: urlComponents.url!)
        
        guard let httpUrlResponse = response as? HTTPURLResponse,
              httpUrlResponse.statusCode == 200 else {
            throw PicsError.notFound
        }
        
        let jsonDecoder = JSONDecoder()
        let jsonDecodedPicsAPIResponse = try jsonDecoder.decode(PicsAPIResponse.self, from: data)
        return jsonDecodedPicsAPIResponse
    }
    
    /// Fetches specific image with the given URL.
    static func fetchImageWithUrl(url: URL) async throws -> UIImage {
        
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        urlComponents?.scheme = "https"
        
        guard let url = urlComponents?.url else {
            throw PicError.invalidUrl
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpUrlResponse = response as? HTTPURLResponse,
              httpUrlResponse.statusCode == 200,
              let image = UIImage(data: data) else {
            throw PicError.notFound
        }
        
        return image
    }
}
