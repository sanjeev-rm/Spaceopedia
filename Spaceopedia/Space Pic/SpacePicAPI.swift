//
//  SpacePicAPI.swift
//  Spaceopedia
//
//  Created by Sanjeev RM on 01/06/23.
//

import Foundation

/// Class with requestURL and Api Key.
//class SpacePicAPI {
//    private static var REQUEST_URL_STRING: String = "https://api.unsplash.com/search/photos"
//    private static var API_KEY: String = "6fDw2r0BGyohzVTvw1YXDqAWrcJKL9eC5Z-hQNEbjWA"
//
//    static func getRequestUrl() -> String {
//        return REQUEST_URL_STRING
//    }
//
//    static func getApiKey() -> String {
//        return API_KEY
//    }
//}

class SpacePicAPI {
    private static var REQUEST_URL_STRING: String = "https://images-api.nasa.gov/search"
    
    static func getRequestUrlString() -> String {
        return REQUEST_URL_STRING
    }
}
