//
//  ApodAPI.swift
//  Spaceopedia
//
//  Created by Sanjeev RM on 06/06/23.
//

import Foundation

class ApodAPI
{
    private static var REQUEST_URL_STRING: String = "https://api.nasa.gov/planetary/apod"
    private static var API_KEY: String = "0sv3eKwe1HYgqizs0CrEZ3Oy5dfjeu41L4Wuzly3"
    
    static func getRequestUrl() -> String {
        return REQUEST_URL_STRING
    }
    
    static func getApiKey() -> String {
        return API_KEY
    }
}
