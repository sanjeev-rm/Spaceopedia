//
//  PlanetMoonAPI.swift
//  Spaceopedia
//
//  Created by Sanjeev RM on 20/05/23.
//

import Foundation

class PlanetMoonAPI {
    private static var requestURL: String = "https://api.le-systeme-solaire.net/rest.php/bodies/"
    
    static func getRequestURLString(word: String) -> String {
        return PlanetMoonAPI.requestURL + word
    }
}
