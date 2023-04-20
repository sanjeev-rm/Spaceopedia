//
//  ApodModel.swift
//  Spaceopedia
//
//  Created by Sanjeev RM on 06/04/23.
//

import Foundation
import UIKit

// Model Object to represent an apod.
struct Apod: Codable, Identifiable, Equatable
{
    var id: UUID = UUID()
    
    var title: String
    var description: String
    var url: URL
    var mediaType: String
    var copyright: String?
    
    // These properties are not in response from the API.
    // We have added this to use it later in program.
    // The date is used for the liked apods page.
    // The image is used to use the image directly instead of fetching everysingle time.
    var date: Date?
    
    // The image property is too ahead of it's time. It must be implemented later after finding out the another way to store images in the disk as plist don't store images.
//    var image: UIImage?
    
    enum CodingKeys: String, CodingKey
    {
        case title
        case description = "explanation"
        case url
        case mediaType = "media_type"
        case copyright
    }
    
    static func ==(lhs: Apod, rhs: Apod) -> Bool
    {
        return lhs.url == rhs.url
    }
}
