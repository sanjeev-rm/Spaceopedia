//
//  ApodController.swift
//  Spaceopedia
//
//  Created by Sanjeev RM on 06/04/23.
//

import Foundation
import UIKit

class ApodController
{
    /// All the liked APODS.
    var likedApods: [Apod]?
    
    /// Error for the APOD retreiving process.
    enum ApodError: Error, LocalizedError {
        case itemNotFound
        case imageNotFound
    }
    
    /// Function that fetches apod information from the NASA APOD API.
    func fetchApodInfo(query: [String:String]) async throws -> Apod
    {
        var urlComponents = URLComponents(string: "https://api.nasa.gov/planetary/apod")!
        urlComponents.queryItems = query.map({ key, value in
            URLQueryItem(name: key, value: value)
        })
        
        let (data, response) = try await URLSession.shared.data(from: urlComponents.url!)
        
        guard let httpUrlResponse = response as? HTTPURLResponse, httpUrlResponse.statusCode == 200 else {
            throw ApodError.itemNotFound
        }
        
        let jsonDecoder = JSONDecoder()
        let jsonDecodedApod = try jsonDecoder.decode(Apod.self, from: data)
        return jsonDecodedApod
    }
    
    /// Function that fetches apod image from the NASA APOD API.
    func fetchApodImage(imageUrl url: URL) async throws -> UIImage
    {
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        urlComponents?.scheme = "https"
        
        let (data, response) = try await URLSession.shared.data(from: urlComponents!.url!)
        
        guard let httpUrlResponse = response as? HTTPURLResponse,
              httpUrlResponse.statusCode == 200,
              let image = UIImage(data: data) else {
            throw ApodError.imageNotFound
        }
        
        return image
    }
}
