//
//  SpacePicAPI.swift
//  Spaceopedia
//
//  Created by Sanjeev RM on 01/06/23.
//

import Foundation

/// Class with requestURL and Api Key.
class SpacePicAPI {
    private static var requestURL: String = "https://api.unsplash.com/search/photos"
    private static var apiKey: String = "6fDw2r0BGyohzVTvw1YXDqAWrcJKL9eC5Z-hQNEbjWA"
    
    static func getRequestUrl() -> String {
        return requestURL
    }
    
    static func getApiKey() -> String {
        return apiKey
    }
}
