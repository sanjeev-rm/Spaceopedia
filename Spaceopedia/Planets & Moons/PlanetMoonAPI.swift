//
//  PlanetMoonAPI.swift
//  Spaceopedia
//
//  Created by Sanjeev RM on 20/05/23.
//

import Foundation

class PlanetMoonAPI {
    private static var REQUEST_URL_STRING: String = "https://api.le-systeme-solaire.net/rest.php/bodies/"
    
    static func getRequestUrlWith(word: String) -> String {
        return PlanetMoonAPI.REQUEST_URL_STRING + word
    }
}
