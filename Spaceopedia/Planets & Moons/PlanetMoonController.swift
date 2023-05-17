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
    static func fetch(planetOrMoon: String) async throws -> PlanetMoon {
        var url = URL(string: "https://api.le-systeme-solaire.net/rest.php/bodies/\(planetOrMoon)")!
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpUrlResponse = response as? HTTPURLResponse, httpUrlResponse.statusCode == 200 else {
            throw PlanetMoonError.notFound
        }
        
        let jsonDecoder = JSONDecoder()
        let jsonDecodedPlanetMoon = try jsonDecoder.decode(PlanetMoon.self, from: data)
        return jsonDecodedPlanetMoon
    }
}
