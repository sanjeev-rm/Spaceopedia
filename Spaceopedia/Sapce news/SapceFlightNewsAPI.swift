//
//  NewsAPI.swift
//  Spaceopedia
//
//  Created by Sanjeev RM on 06/06/23.
//

import Foundation

/*
 MARK: The SapceFlight News API.
 LINK - https://api.spaceflightnewsapi.net/v4/docs/#/
*/

class SpaceFlightNewsAPI
{
    /// The basic request url in String format.
    private static var REQUEST_URL_STRING: String = "https://api.spaceflightnewsapi.net/v4/articles/"
    
    /// Function returns the base request url of the NewsAPI.
    static func getRequestUrlString() -> String {
        return REQUEST_URL_STRING
    }
    
    /// Function returns the URL of the request with all the queries included.
    /// SortBy parameter is taken and the URL is created accordingly.
    static func getRequestUrl() -> URL? {
        return URL(string: SpaceFlightNewsAPI.REQUEST_URL_STRING)
    }
}
