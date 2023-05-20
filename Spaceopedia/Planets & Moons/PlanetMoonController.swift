//
//  PlanetMoonController.swift
//  Spaceopedia
//
//  Created by Sanjeev RM on 17/05/23.
//

import Foundation

class PlanetMoonController
{
    /// Error representing an error related to Planet & Moon module.
    enum PlanetMoonError: Error {
        case notFound
    }
    
    /// Fetches the PlanetMoon response from the API.
    /// Parameter - urlString --> The url of the object in string format.
    static func fetch(urlString: String) async throws -> PlanetMoon {
        guard let url = URL(string: urlString) else {
            throw PlanetMoonError.notFound
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpUrlResponse = response as? HTTPURLResponse, httpUrlResponse.statusCode == 200 else {
            throw PlanetMoonError.notFound
        }
        
        let jsonDecoder = JSONDecoder()
        let jsonDecodedPlanetMoon = try jsonDecoder.decode(PlanetMoon.self, from: data)
        return jsonDecodedPlanetMoon
    }
}
