//
//  ApodModel.swift
//  Spaceopedia
//
//  Created by Sanjeev RM on 06/04/23.
//

import Foundation

// Model Object to represent an apod.
struct Apod: Codable, Identifiable, Equatable
{
    var id: UUID = UUID()
    
    var title: String
    var description: String
    var url: URL
    var mediaType: String
    var copyright: String?
    
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
