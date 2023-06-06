//
//  NewsAPI.swift
//  Spaceopedia
//
//  Created by Sanjeev RM on 06/06/23.
//

import Foundation

class NewsAPI
{
    /// The basic request url in String format.
    private static var REQUEST_URL_STRING: String = "https://newsapi.org/v2/everything"
    
    /// The API key for the API.
    private static var API_KEY: String = "5f50f3f28d8547d2a30d50f72b9e97e2"
    
    /// The News domain that the news API will search for.
    private static var NEWS_DOMAIN: String = "astronomy"
    
    /// Options for sortBy query parameter.
    enum ArticlesSortBy: String {
        case relevancy = "relevancy"
        case popularity = "popularity"
        case publishedAt = "publishedAt"
    }
    
    /// Function returns the base request url of the NewsAPI.
    static func getRequestUrl() -> String {
        return REQUEST_URL_STRING
    }
    
    /// Function returns the API Key of the NewsAPI.
    static func getApiKey() -> String {
        return API_KEY
    }
    
    /// Function returns the URL of the request with all the queries included.
    /// SortBy parameter is taken and the URL is created accordingly.
    static func getRequestUrlWith(sortBy: ArticlesSortBy) -> URL? {
        let query: [String:String] = ["q":NewsAPI.NEWS_DOMAIN,
                                      "sortBy":sortBy.rawValue,
                                      "apiKey":NewsAPI.API_KEY]
        
        var urlComponents = URLComponents(string: NewsAPI.REQUEST_URL_STRING)!
        urlComponents.queryItems = query.map({ key, value in
            URLQueryItem(name: key, value: value)
        })
        
        return urlComponents.url
    }
}
