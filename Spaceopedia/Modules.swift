//
//  Modules.swift
//  Spaceopedia
//
//  Created by Sanjeev RM on 30/03/23.
//

import Foundation

enum Modules: CaseIterable, Identifiable
{
    case apod
    case spaceDef
    case spacePic
    case spaceFacts
    case planetsAndMoons
    case spaceNews
    
    var id: String {
        return title
    }
    
    var title: String {
        switch self {
        case .apod: return "APOD"
        case .spaceDef: return "SPACE DEF"
        case .spacePic: return "SPACE PIC"
        case .spaceFacts: return "SPACE FACTS"
        case .planetsAndMoons: return "Planets & Moons"
        case .spaceNews: return "SPACE NEWS"
        }
    }
    
    var description: String {
        switch self {
        case .apod: return "Astronomical picture of the day"
        case .spaceDef: return "Definitions of astronomical terms"
        case .spacePic: return "Pictures of astronomical terms"
        case .spaceFacts: return "Random facts about astronomy"
        case .planetsAndMoons: return "Planets and Moons"
        case .spaceNews: return "Top 10 space news"
        }
    }
    
    var segueIdentifier: String {
        switch self {
        case .apod: return "apodSegue"
        case .spaceDef: return "spaceDefSegue"
        case .spacePic: return "spacePicSegue"
        case .spaceFacts: return "spaceFactsSegue"
        case .planetsAndMoons: return "planetsAndMoonsSegue"
        case .spaceNews: return "spaceNewsSegue"
        }
    }
}
