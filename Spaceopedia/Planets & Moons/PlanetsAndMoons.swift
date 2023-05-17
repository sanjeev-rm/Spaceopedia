//
//  PlanetsAndMoons.swift
//  Spaceopedia
//
//  Created by Sanjeev RM on 17/05/23.
//

import Foundation

/// Model to represent the model to represent the response from the API. Also represents the PlanetModel object.
struct PlanetMoon: Codable {
    var id: String
    var name: String
    var englishName: String
    var isPlanet: Bool
    var moons: [Moon]?
    var mass: Mass
    var vol: Volume
    var density: Double
    var gravity: Double
    var meanRadius: Double
    var aroundPlanet: Planet?
    var discoveredBy: String
    var discoveryDate: String
    var bodyType: String
}

/// Model to represent a Moon.
struct Moon: Codable {
    var name: String
    var infoUrlString: String
    
    enum CodingKeys: String, CodingKey {
        case name = "moon"
        case infoUrlString = "rel"
    }
}

/// Model to represent Mass.
struct Mass: Codable {
    var massValue: Double
    var massExponent: Double
    
    func getMassString() -> String {
        return "\(massValue) x 10^\(massExponent) Kg"
    }
}

/// Model to represent Volume.
struct Volume: Codable {
    var volValue: Double
    var volExponent: Double
    
    func getVolumeString() -> String {
        return "\(volValue) x 10^\(volExponent) Km^3"
    }
}

/// Model to represent Planet.
/// Used to represent the Planet that the moon is revolving around.
struct Planet: Codable {
    var name: String
    var infoUrlString: String
    
    enum CodingKeys: String, CodingKey {
        case name = "planet"
        case infoUrlString = "rel"
    }
}
