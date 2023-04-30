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
    /// Error for the APOD retreiving process.
    enum ApodError: Error, LocalizedError {
        case itemNotFound
        case imageNotFound
    }
    
    /// Function that fetches apod information from the NASA APOD API.
    static func fetchApodInfo(query: [String:String]) async throws -> Apod
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
    static func fetchApodImage(imageUrl url: URL) async throws -> UIImage
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
    
    static func fetchApodVideo(videoUrl: URL)
    {
    }
}

extension ApodController
{
    /// All the liked APODS.
    static var likedApods: [LikedApod]? {
        return ApodController.loadLikedApodsFromFile()
    }
    
    /// The URL of the file where the Liked Apods data is stored.
    private static var likedApodsPlistUrl: URL {
        let fileManager = FileManager.default
        let documentsDirectoryUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        if #available(iOS 16.0, *) {
            return documentsDirectoryUrl.appending(path: "likedApods.plist")
        } else {
            return documentsDirectoryUrl.appendingPathComponent("likedApods.plist")
        }
    }
    
    /// Saves an array of APODS to the disk.
    static func saveLikedApodsToFile(apods: [LikedApod])
    {
        let pListEncoder = PropertyListEncoder()
        if let encodedLikedApods = try? pListEncoder.encode(apods) {
            try? encodedLikedApods.write(to: likedApodsPlistUrl)
        }
    }
    
    /// Loads the array of APODS from the disk.
    static func loadLikedApodsFromFile() -> [LikedApod]
    {
        let pListDecoder = PropertyListDecoder()
        if let retrievedLikedApods = try? Data(contentsOf: likedApodsPlistUrl),
           let decodedLikedApods = try? pListDecoder.decode([LikedApod].self, from: retrievedLikedApods) {
            return decodedLikedApods
        }
        return []
    }
}
